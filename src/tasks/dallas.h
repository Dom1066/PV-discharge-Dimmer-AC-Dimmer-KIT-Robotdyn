#ifndef TASK_DALLAS
#define TASK_DALLAS

#include <OneWire.h>
#include <DallasTemperature.h>
OneWire ds(ONE_WIRE_BUS);   //  (a 4.7K resistor is necessary - 5.7K work with 3.3 ans 5V power)
DallasTemperature sensors(&ds);

extern PubSubClient client;
extern bool AP; // mode point d'accès
extern Mqtt mqtt_config; // configuration mqtt
extern byte present; // capteur dallas présent ou non
extern String logs; // logs
// extern byte security; // sécurité
DeviceAddress addr[MAX_DALLAS];   // array of (up to) MAX_DALLAS temperature sensors NOSONAR
String devAddrNames[MAX_DALLAS];  // array of (up to) MAX_DALLAS temperature sensors NOSONAR
float previous_celsius[MAX_DALLAS] = {0.00};   // NOSONAR // température précédente // NOSONAR
extern IPAddress gatewayIP;
extern HA devicetemp[MAX_DALLAS]; // NOSONAR
extern int deviceCount; // nombre de sonde(s) dallas détectée(s)
int dallas_error[MAX_DALLAS] = {0}; // compteur d'erreur dallas // NOSONAR
int gw_error = 0;   // compteur d'erreur gateway
int dallas_wait_log; // NOSONAR
size_t temp_reponse_dallas = 400; 
size_t temp_reponse_dallas_max = 1500;

float CheckTemperature(String label, DeviceAddress  deviceAddress); // NOSONAR
void restart_dallas();
bool dallaspresent ();
size_t timer_dallas = 500; // timer pour la dallas
size_t dallas_fail = 0; // compteur d'erreur dallas

/// @brief / task executé toute les n secondes pour publier la température ( voir déclaration task dans main )
// TODO tout mettre concernant les dallas dans cette task pour isoler les effets de bord 
void mqttdallas() {
  if ( present == 1 ) {
    
    delay(timer_dallas);
    for (int a = 0; a < deviceCount; a++) {
      sysvar.celsius[a]=CheckTemperature("temp_" + devAddrNames[a],addr[a]);
      // gestion des erreurs DS18B20
      if ( (sysvar.celsius[a] == DEVICE_DISCONNECTED_C) || (sysvar.celsius[a] == -255.00) ||
           (sysvar.celsius[a] > 200.00) ) {
        sysvar.celsius[a]=previous_celsius[a];
        dallas_error[a]++;  // incrémente le compteur d'erreur
        char temp_buffer[128]; // Ajustez la taille en fonction de la longueur maximale attendue
        snprintf(temp_buffer, sizeof(temp_buffer), "Dallas %d : échec %d\r\n", a, dallas_error[a]);
        logging.Set_log_init(temp_buffer,true);
        if ( timer_dallas < DALLAS_TIMEOUT )  { timer_dallas = timer_dallas + 100; ; } // on augmente le timer pour la prochaine lecture
        if ( temp_reponse_dallas < temp_reponse_dallas_max )  { temp_reponse_dallas = temp_reponse_dallas + 100; ; } // ça permet de s'adapter aux sondes qui répondent mal
      }
      else {
        sysvar.celsius[a] = (roundf(sysvar.celsius[a] * 10) / 10 ) + 0.1; // pour les valeurs min
        dallas_error[a] = 0; // remise à zéro du compteur d'erreur
      }
    }
    if (!AP && mqtt_config.mqtt) {
      if ( sysvar.celsius[sysvar.dallas_maitre] != previous_celsius[sysvar.dallas_maitre]  ||
           sysvar.celsius[sysvar.dallas_maitre] != 0.99) {
        Mqtt_send_DOMOTICZ(String(config.IDXTemp), String(sysvar.celsius[sysvar.dallas_maitre]),"Temperature");
      }

      if (!discovery_temp) {
        discovery_temp = true;
        device_dimmer_alarm_temp.HA_discovery();
        for (int i = 0; i < deviceCount; i++) {
          device_temp[i].HA_discovery();
        }
        device_temp_master.HA_discovery();
        device_dimmer_maxtemp.HA_discovery();
        device_dimmer_alarm_temp.send(stringBoolMQTT(sysvar.security));
        device_dimmer_maxtemp.sendInt(config.maxtemp);
        device_dimmer_alarm_temp_clear.HA_discovery();
      }

      // uniformisation des valeurs de température ( for en valeur I pour retrouver plus facilement)
      dallas_wait_log++;
      for (int i = 0; i < deviceCount; i++) {

        if ( sysvar.celsius[i] != previous_celsius[i] || sysvar.celsius[i] != 0.99) {
          device_temp[i].sendFloat(sysvar.celsius[i]);
          previous_celsius[i]=sysvar.celsius[i];
          if ( dallas_wait_log > 5 ) { /// limitation de l'affichage des logs de température
            char temp_buffer[128]; 
            snprintf(temp_buffer, sizeof(temp_buffer), "Dallas %d : %.1f\r\n", i, sysvar.celsius[i]);
            logging.Set_log_init(temp_buffer,false);
          }
        }
      }
      if ( dallas_wait_log > 5 ) { dallas_wait_log = 0; }
      device_temp_master.sendFloat(sysvar.celsius[sysvar.dallas_maitre]);
    }
    // on demande la température suivante pour le prochain cycle
    sensors.requestTemperatures();
  }

  // détection sécurité température
  if  ( sysvar.celsius[sysvar.dallas_maitre] >= config.maxtemp ) {
    // coupure du dimmer
    DEBUG_PRINTLN("détection sécurité température");

    unified_dimmer.dimmer_off();

    if ( strcmp(config.child,"") != 0 && strcmp(config.mode,"off") != 0) {
      // si ça n'est pas le cas, on ne fait rien ... c'est bien parfois de ne rien faire
    }
    else {
      sysvar.puissance=0;
      unified_dimmer.dimmer_off();
    }

    if ( mqtt_config.mqtt ) {
      Mqtt_send_DOMOTICZ(String(config.IDX), "0");
    }
    if ( config.HA ) {
      device_dimmer.send("0");
      device_dimmer_power.send("0");

    }
  }

  previous_celsius[sysvar.dallas_maitre]=sysvar.celsius[sysvar.dallas_maitre];

  // si trop d'erreur dallas, on remonte en mqtt
  for (int a = 0; a < deviceCount; a++) {
    if ( dallas_error[a] > 5 ) {
      DEBUG_PRINTLN("détection perte sonde dallas");

      Mqtt_send_DOMOTICZ(String(config.IDXAlarme), String(Dallas_lost),"Dallas perdue");
      char temp_buffer[64];    // Pour les entiers
      snprintf(temp_buffer, sizeof(temp_buffer), "Dallas %d perdue après %d échecs", a, dallas_error[a]);
      logging.Set_log_init(temp_buffer,true);
      dallas_error[a] = 0; // remise à zéro du compteur d'erreur
      /// mise en sécurité
      sysvar.celsius[a] = 99.9;

      previous_celsius[a]=sysvar.celsius[a];
      if (a == sysvar.dallas_maitre) {
        String temp_topic = "Xlyric/" + String(config.say_my_name) + "/dallas";

        String message = String(logging.loguptime()) + "Dallas maitre perdue";
        sysvar.wait_unlock_mqtt();
        client.publish((temp_topic+"dallas").c_str(), String(message).c_str(),true);

        unified_dimmer.dimmer_off(); /// mise en sécurité de l'ensemble
      }
    }
  }
/// cas de recherche de la dallas
  if ( present == 0 && dallas_fail < 10 ) {
      //// récupération des dallas .
    Serial.println("start 18b20");
    sensors.begin();
    delay(1000);
    deviceCount = sensors.getDeviceCount();
    dallas_fail++;  
    if (deviceCount == 0 ) { // si toujours pas trouvé
      sensors.begin(); // réinit du bus one wire
      delay(1500);
      deviceCount = sensors.getDeviceCount();
    }

    char buf_int[12];    // Pour les entiers
    itoa(deviceCount, buf_int, 10);
    logging.Set_log_init(buf_int);
    logging.Set_log_init(DALLAS_detected);
    if ( deviceCount > 0 )  {
      present = 1;
      dallaspresent();
      devices_init(); // initialisation des devices HA
    }
  } 
}

#ifdef ESP32
  void mqttdallas_32 ( void * parameter ) {
    while (true) {
      mqttdallas();
      vTaskDelay(8123 / portTICK_PERIOD_MS); // Délai de 8 seconde pour ESP32
    }
  }
#endif

//***********************************
//************* récupération d'une température du 18b20
//***********************************

float CheckTemperature(String label, DeviceAddress deviceAddress){ // NOSONAR
  float tempC = sensors.getTempC(deviceAddress);
  if ( (tempC == DEVICE_DISCONNECTED_C) || (tempC == -255.00) ) {
    // si problème de récupération de la température, on relance la demande
    sensors.requestTemperaturesByAddress(deviceAddress);
    delay(temp_reponse_dallas);
    // cas d'une sonde trop longue à préparer les valeurs
    // attente de 187ms ( temps de réponse de la sonde )
    tempC = sensors.getTempC(deviceAddress);
  }
  return tempC;
}

// fonction pour relancer une détection de la dallas en cas de perte ou de non détection
void restart_dallas() {
  if (deviceCount == 0 ) {
    sensors.begin();
    delay(DALLAS_TIMEOUT);
    deviceCount = sensors.getDeviceCount();
    if ( deviceCount > 0 )  {
      char buf_int[12];    // Pour les entiers
      present = 1;
      itoa(deviceCount, buf_int, 10);
      logging.Set_log_init(buf_int);
      logging.Set_log_init(" DALLAS detected\r\n");
      devices_init(); // initialisation des devices HA
    }

    if (!dallaspresent()) {
      delay(3000);
    }
  }
}


//***********************************
//************* Test de la présence d'une 18b20
//***********************************
int devicealerte=0;

bool dallaspresent () {

  /// alerte d'une deection de dallas passée non trouvée
  if (deviceCount == 0 && ( strcmp("null", config.DALLAS) != 0 || strcmp("none", config.DALLAS) != 0 )) {
    /// remonter l'alerte une fois toute les 10 secondes
    if (devicealerte == 0) {
      logging.Set_log_init(Alerte_Dallas_not_found);
      Mqtt_send_DOMOTICZ(String(config.IDXTemp), String("Alerte Dallas non trouvée"),"Alerte");  /// send alert to MQTT
      device_dimmer_alarm_temp.send("Alerte Dallas non trouvée");
      logging.alerte_web="Dallas Maitre non trouvée";
      devicealerte++;
    }
    else {
      devicealerte++;
      if (devicealerte > 10) {
        devicealerte = 0;
      }
    }
    return false;
  }

  logging.alerte_web="RAS";

  //// recherche des adresses des sondes
  /// réglage de la préciion des sondes
  for (int i = 0; i < deviceCount; i++) {
    if (!sensors.getAddress(addr[i], i)) Serial.println("Unable to find address for Device " + String(i));
    else {
      sensors.setResolution(addr[i], TEMPERATURE_PRECISION);
    } 
  }
  
  for (int a = 0; a < deviceCount; a++) {
    String address = "";
    Serial.print("ROM =");
    // affichage de l'adresse de la sonde
    for (uint8_t i = 0; i < 8; i++) {
      if (addr[a][i] < 0x10) address += "0";
      address += String(addr[a][i], HEX);
      Serial.write(' ');
      Serial.print(addr[a][i], HEX);
    }

    devAddrNames[a] = address;
    Serial.println();
    // détection de la sonde maitre
    if (strcmp(address.c_str(), config.DALLAS) == 0) {
      sysvar.dallas_maitre = a;
      logging.Set_log_init("MAIN " );
    }

    // détection de la 1ere présence d'une dallas si pas de dallas maitre
    if (strcmp("none", config.DALLAS) == 0 || strcmp("null", config.DALLAS) == 0 ) {
      sysvar.dallas_maitre = a;
      logging.Set_log_init("Default MAIN " );
      // sauvegarde de l'adresse de la sonde maitre
      strcpy(config.DALLAS, address.c_str()); // nno sonar
      config.saveConfiguration();
    }

    logging.Set_log_init(Dallas_sensor);
    char buf_int[12];    // Pour les entiers
    itoa(a, buf_int, 10);
    logging.Set_log_init(buf_int);
    logging.Set_log_init(found_Address);
    logging.Set_log_init(address.c_str());
    logging.Set_log_init("\r\n");
    present = 1;
    if (sensors.isParasitePowerMode())  { logging.Set_log_init("parasite power is on"); }
    // usage de oneWire.reset_search() pour réinitialiser la recherche
    // de la sonde suivante ( est ce vraiment utile, comme dans les docs, ça n'est pas fait )
    // --> très tiré par les cheveux comme la librairie dallas le fait déja https://arduino.blaisepascal.fr/capteur-de-temperature-dallas/

    /// cas d'une adresse à 0 0 0 0 0 0 0 0
    for (int i = 0; i < deviceCount; i++)  {
      if (addr[i][0] == 0 && addr[i][1] == 0 && addr[i][2] == 0 && addr[i][3] == 0 && addr[i][4] == 0 && addr[i][5] == 0 && addr[i][6] == 0 && addr[i][7] == 0) {
        char temp_buffer[64]; 
        snprintf(temp_buffer, sizeof(temp_buffer)," Dallas %d : Adresse 0 0 0 0 0 0 0 0\r\n", i);
        logging.Set_log_init(temp_buffer,true);
        present = 0;
        restart_dallas();
      }
    }
  }
  return true;
}
#endif