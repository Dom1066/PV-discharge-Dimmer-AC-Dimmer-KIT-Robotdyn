<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
    <meta name="description" content="" />
    <meta name="author" content="" />
    <title>%NAME% - <%block name="page_title">Tableau de bord</%block></title>

    <link href="css/all.min.css?%FS_RELEASE%" rel="stylesheet" type="text/css" />
  </head>
  <body id="page-top">
    <!-- Page Wrapper -->
    <div id="wrapper">
      <!-- Sidebar -->
      <ul
        class="navbar-nav bg-gradient-primary sidebar sidebar-dark accordion"
        id="accordionSidebar"
      >
        <!-- Sidebar - Brand -->
        <a class="sidebar-brand d-flex align-items-center justify-content-center" href="./">
          <div class="sidebar-brand-icon rotate-n-15">
            <i class="fas fa-laugh-wink"></i>
          </div>
          <div class="sidebar-brand-text mx-3">%NAME%</div>
        </a>
        <!-- Divider -->
        <hr class="sidebar-divider my-0" />
        <!-- Nav Item - Dashboard -->
                <li class="nav-item active">
                    <a class="nav-link" href="/">
                        <i class="fas fa-fw fa-tachometer-alt"></i>
                        <span>Tableau de bord</span>
                        <br>
                        <i class="fas fa-fw fa-code-branch"></i>
                        <span id="version"> %VERSION%</span>
                        <br>
                        <br>
                        <i class="fa fa-wifi"></i>
                        <span id="RSSI">Signal WiFi : %RSSI% dBm</span>
                    </a>
                </li>
        <!-- Divider -->
        <hr class="sidebar-divider" />
        <!-- Heading -->
        <div class="sidebar-heading">Interface</div>
        <!-- Nav Item - Pages Collapse Menu -->
        <%block name="menu">
        <li class="nav-item active">
          <a class="nav-link" href="config.html">
            <i class="fas fa-fw fa-cog"></i>
            <span>Configuration</span>
          </a>
        </li>
        </%block>
        <!-- Divider -->
        <hr class="sidebar-divider" />
        <!-- Sidebar Toggler (Sidebar) -->
        <div class="text-center d-none d-md-inline">
          <button class="rounded-circle border-0" id="sidebarToggle"></button>
        </div>
      </ul>
      <!-- End of Sidebar -->

      <!-- Content wrapper -->
      <div id="content-wrapper" class="d-flex flex-column">
        <!-- Main content -->
        <div id="content">
          <%block name="topbar">
          <!-- Topbar -->
          <nav class="navbar navbar-expand navbar-light bg-white topbar mb-4 static-top shadow">
            <%block name="topbar_content">
            <div class="alert alert-danger" id="alertBox">
              <span class="mr-2 d-none d-lg-inline text-gray-600"></span>
              <p role="alert" id="alertContainer"></p>
            </div>


            <!-- Topbar Navbar -->
            <ul class="navbar-nav ml-auto">
                            <li class="nav-item dropdown no-arrow">

                                    <span class="mr-2 d-none d-lg-inline text-gray-600">
                                        <button class="btn btn-primary active col-lg-12" id="time" >%time%</button></b>
                                    </span>

                            </li>
            </ul>
            <div class="topbar-divider d-none d-sm-block"></div>
            </%block>
          </nav>
          <!-- End of Topbar -->
          </%block>
          <!-- Page Content -->
          <div class="container-fluid">
            <%block name="content">
            <!-- Page Heading -->
            <div class="d-sm-flex align-items-center justify-content-between mb-4">
              <h1 class="h3 mb-0 text-gray-800">Tableau de bord</h1>
            </div>
            <!-- Content Row -->
            <div class="row">
              <!-- Area Chart -->
              <div class="col-xl-3 col-md-6 mb-4">
                <div class="card shadow mb-4">
                  <!-- Card Header - Dropdown -->
                  <div
                    class="card-header py-3 d-flex flex-row align-items-center justify-content-between"
                  >
                  <div class="m-0 font-weight-bold text-primary" data-toggle="popover" data-placement="bottom" data-content="Puissance photovoltaïque instantanée envoyée au cumulus">Puissance gradateur <i class="text-secondary fas fa-info-circle"></i>
					 </div>				  
					</div>
                  <div class="card-body">
                    <div id="curve_chart2" style="width: auto; height: 200px"></div>
                  </div>
                </div>
              </div>
              <div class="col-xl-3 col-md-6 mb-4">
                <div class="card shadow mb-4">
                  <!-- Card Header - Dropdown -->
                  <div
                    class="card-header py-3 d-flex flex-row align-items-center justify-content-between"
                  >
                  <div class="m-0 font-weight-bold text-primary" data-toggle="popover" data-placement="bottom" data-content="Température à mi-hauteur du cumulus (emplacement de la sonde)">Température <i class="text-secondary fas fa-info-circle"></i>
					</div>
                  </div>
                  <div class="card-body">
                    <div id="curve_temp" style="width: auto; height: 200px"></div>
                  </div>
                </div>
              </div>
              <div class="col-xl-3 col-md-6 mb-4">
                <div class="card shadow mb-4">
                  <!-- Card Header - Dropdown -->
                  <div
                    class="card-header py-3 d-flex flex-row align-items-center justify-content-between"
                  >
                  <div class="m-0 font-weight-bold text-primary">Etats & commandes
					</div>
                  </div>
                  <div class="card-body">
				  
                            <p class=" h6 lh-base text-primary text-nowrap">
                            <b>Statut : <span id="alerte">%alerte%</span></b>
                            </p>
							
                            <p class="h6 lh-base text-primary text-nowrap">							
                            <b>Minuteur d'appoint <span id="minuteur">%minuteur%</span></b>
                            <br><br>
                           <b>Marche forcée  <span id="boost" <button class="btn btn-success" id="boost" >N/A </button></b>
						   <span class=h6 id="boost_endtime"></span>                            
                            </p>
							
                            <p class="h6 lh-base text-primary text-nowrap">
                            <b>Relais 1  &emsp;&emsp;&emsp; <span id="relais 1" <button class="btn btn-success" id="relais 1" >N/A </button></b>
                            </p>

                           <p class="h6 lh-base text-primary text-nowrap">
						   <b>Relais 2  &emsp;&emsp;&emsp; <span id="relais 2" <button class="btn btn-success" id="relais 2" >N/A </button></b>
                            </p>
							
                    <div>

                    </div>                    
                  </div>
                </div>
              </div>
              <div class="col-xl-3 col-md-6 mb-4">
                <div class="card shadow mb-4">
                  <!-- Card Header - Dropdown -->
                  <div
                    class="card-header py-3 d-flex flex-row align-items-center justify-content-between"
                  >
                  <div class="m-0 font-weight-bold text-primary">Infos sondes
					</div>
                  </div>
                  <div class="card-body">
                    <span id="dallas"></span>
                  </div>
                </div>
              </div>
            </div>
            </%block>
          </div>
          <!-- End of Page Content -->
        </div>
        <!-- End of Main Content -->
      </div>
      <!-- End of Content wrapper -->
    </div>

    <!-- Footer -->
    <footer class="sticky-footer bg-white">
      <div class="container my-auto">
        <div class="copyright text-center my-auto">
          <span>https://github.com/xlyric/ - 2024</span>
        </div>
      </div>
    </footer>
    <!-- End of Footer -->

    <script type="text/javascript" src="js/all.min.js?%FS_RELEASE%"></script>

    <%block name="pagescript">
    <%text>
    <script type="text/javascript">
    $('[data-toggle="popover"]').popover();
    $('body').on('click', function (e) {
    $('[data-toggle=popover]').each(function () {
        // hide any open popovers when the anywhere else in the body is clicked
        if (!$(this).is(e.target) && $(this).has(e.target).length === 0 && $('.popover').has(e.target).length === 0) {
            $(this).popover('hide');
          }
      });
  });
  
      window.onload = function () {
        horloge("time");
      };
      google.charts.load("current", { packages: ["corechart", "gauge"] });
      google.charts.setOnLoadCallback(drawChart);
      var chart;
      var options = {
        title: "Oscilloscope Mode",
        curveType: "function",
        legend: { position: "bottom" },
      };
      var data;
      var inc;
      function drawChart() {
        var optionsGauge = {
          redFrom: 75,
          redTo: 100, redColor: '#FF0000',
          yellowFrom: 50,
          yellowTo: 75,
          greenFrom: 0,
          greenTo: 50, greenColor: '#01DF3A',
          minorTicks: 4,
          min: 0,
          max: 100,
        };
        var optionsGaugetemp = {
          redFrom: 60, 
          redTo: 70, redColor: '#FF0000',
          yellowFrom: 20, 
          yellowTo: 30, yellowColor: '#2DA4FF',
          greenFrom: 30, 
          greenTo: 60, greenColor: '#01DF3A',
          minorTicks: 5, majorTicks: ['20','30','40','50','60','70'],
          min: 20, 
          max: 70, 
        };
        // mise à jour de la jauge  -->
        var gaugePA = new google.visualization.Gauge(document.getElementById("curve_chart2"));
        var dataGaugePA = new google.visualization.DataTable();
        dataGaugePA.addColumn("string", "Puissance");
        dataGaugePA.addColumn("number", "Value");
        dataGaugePA.addRows(1);
        // mise à jour de la jauge  -->
        var gaugePAtemp = new google.visualization.Gauge(document.getElementById("curve_temp"));
        var dataGaugePAtemp = new google.visualization.DataTable();
        dataGaugePAtemp.addColumn("string", "Power");
        dataGaugePAtemp.addColumn("number", "Value");
        dataGaugePAtemp.addRows(1);
        // récupération valeur sigma et State -->
        function refreshvalue() {
          $.getJSON("/state", function (data) {
            // Récupérer les données du JSON
            var dimmer = data.dimmer;
            var power = data.power;
            var temperature = data.temperature;
            var alerte = data.alerte;
            var minuteur = data.minuteur;
            var relais1 = data.relay1;
            var relais2 = data.relay2;
            var boost = data.boost;
            var boost_endtime = data.boost_endtime;
            // Mettre à jour les éléments HTML
            dataGaugePA.setValue(0, 0, "Watts");
            dataGaugePA.setValue(0, 1, power);
            var pmaxtemp = parseInt((power * 100) / dimmer);
            let pmax = isNaN(pmaxtemp) ? 1600 : pmaxtemp;
            optionsGauge.max = pmax;
            optionsGauge.redTo = pmax;
        optionsGauge.redFrom = parseInt(pmax/1.07);
        optionsGauge.yellowTo = parseInt(pmax/1.07);
		optionsGauge.yellowFrom = parseInt(pmax/1.77);
		optionsGauge.greenTo = parseInt(pmax/1.77);
            gaugePA.draw(dataGaugePA, optionsGauge);
            dataGaugePAtemp.setValue(0, 0, "°C");
            dataGaugePAtemp.setValue(0, 1, temperature);
            gaugePAtemp.draw(dataGaugePAtemp, optionsGaugetemp);
            // recupération de l'état de sécurité
            // ecriture de "refroidissement" dans le div alerte si l'état est à 1
            if (alerte == "") {
              document.getElementById("alerte").innerHTML = "Normal";
              document.getElementById("alerte").style.color = "#01DF3A";

            } else {
              document.getElementById("alerte").innerHTML = "Refroidissement";
              document.getElementById("alerte").style.color = "#FF0000";
            }
            // ecriture de "minuteur" dans le div minuteur si l'état est à 1
            if (minuteur == 1) {
              document.getElementById("minuteur").innerHTML = "en marche";
              document.getElementById("minuteur").style.color = "#01DF3A";
            } else {
              document.getElementById("minuteur").innerHTML = "à l'arrêt.";
              document.getElementById("minuteur").style.color = "grey";
            }
            // ecriture de "ON" dans le div relais 1 si l'état est à 1
            if (relais1 == 1) {
              document.getElementById("relais 1").innerHTML = "🟠";
              document.getElementById("relais 1").style.color = "#7ced56";
            } else {
              document.getElementById("relais 1").innerHTML = "🔘";
              document.getElementById("relais 1").style.color = "#c2c5c1";
            }
            // ecriture de "ON" dans le div relais 2 si l'état est à 1
            if (relais2 == 1) {
              document.getElementById("relais 2").innerHTML = "🟠";
              document.getElementById("relais 2").style.color = "#7ced56";
            } else {
              document.getElementById("relais 2").innerHTML = "🔘";
              document.getElementById("relais 2").style.color = "#c2c5c1";
            }
            // ecriture de "ON" dans le div boost si l'état est à 1
            if (boost == 1) {
              document.getElementById("boost").innerHTML = "🟠";
              document.getElementById("boost").style.color = "#7ced56";
              document.getElementById("boost_endtime").innerHTML = "Fin à " + boost_endtime ;
            } else {
              document.getElementById("boost").innerHTML = "🔘";
              document.getElementById("boost").style.color = "#c2c5c1";
              document.getElementById("boost_endtime").innerHTML = "" ;
            }
            if (data.alerte && data.alerte.trim() != "")
            or
            if (data.alerte && data.alerte.trim() != "Alerte Température")	{
              const alertContainer = document.getElementById("alertContainer");
              alertContainer.innerHTML = "⚠️ " + data.alerte;
              $("#alertBox").fadeIn();
            } else {
              $("#alertBox").fadeOut();		

            }
          });
        }
        setInterval(refreshvalue, 5000); // Rafraîchir les données toutes les 5 secondes
        document.getElementById("relais 1").addEventListener("click", function () {
          fetch("/get?relay1=2")
            .then((response) => response.text())
            .then((data) => {
              console.log("Response:", data);
              setTimeout(refreshvalue, 500);
            })
            .catch((error) => {
              console.error("Error:", error);
            });
        });
        document.getElementById("relais 2").addEventListener("click", function () {
          fetch("/get?relay2=2")
            .then((response) => response.text())
            .then((data) => {
              console.log("Response:", data);
              setTimeout(refreshvalue, 500);
            })
            .catch((error) => {
              console.error("Error:", error);
            });
        });
      document.getElementById("boost").addEventListener("click", function () {
          fetch("/boost")
            .then((response) => response.text())
            .then((data) => {
              console.log("Response:", data);
              setTimeout(refreshvalue, 500);
            })
            .catch((error) => {
              console.error("Error:", error);
            });
        });
      }
      function horloge(el) {
        if (typeof el == "string") {
          el = document.getElementById(el);
        }
        function actualiser() {
          var date = new Date();
          var str = date.getHours();
          str += ":" + (date.getMinutes() < 10 ? "0" : "") + date.getMinutes();
          str += ":" + (date.getSeconds() < 10 ? "0" : "") + date.getSeconds();
          el.innerHTML = str;
        }
        actualiser();
        setInterval(actualiser, 1000);
      }
      function refresh_temp() {
        $.getJSON("/state_dallas", function (data) {
          // affichage des dallas et les Température ( boucle sur les dallas )
          var dallasData = {}; // Objet pour stocker les données des capteurs Dallas
          var dallasNumber;
          // Extraction des données des capteurs Dallas du JSON
          for (var key in data) {
            if (key.startsWith("dallas")) {
              dallasNumber = key.substring(6); // Récupérer le numéro du capteur Dallas
              var dallasTemperature = data[key];
              var dallasAddressKey = "addr" + dallasNumber;
              var dallasAddress = data[dallasAddressKey];
              dallasData[dallasNumber] = {
                temperature: dallasTemperature,
                address: dallasAddress,
              };
            }
          }
          // Affichage des données des capteurs Dallas dans la page HTML
          var dallasHtml = "";
          for (dallasNumber in dallasData) {
            dallasHtml +=
              "<p>Dallas sensor " +
              dallasNumber +
              ": " +
              dallasData[dallasNumber].temperature +
              "°C <br>Address: " +
              dallasData[dallasNumber].address +
              "</p>";
          }
          document.getElementById("dallas").innerHTML = dallasHtml;
        });
      }
      setInterval(refresh_temp, 5000); // Rafraîchir les données toutes les 5 secondes
    </script>
    </%text>
    </%block>
  </body>
</html>
