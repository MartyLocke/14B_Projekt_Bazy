<!DOCTYPE html>
<!--
  Mini Projekt Baz Danych
  2ID14B, Przychodnia
-->
<html lang="pl">
  <head>

  </head>
  <body>

    <input type="button" value="Info" id="btn1">

    <script src="js/req.js"></script>
    <script>

      function komunikatorZSerwerem ( wartosc )
      {
        console.log(wartosc);

        document.body.innerHTML += "<br> " + wartosc.db[0][1] + "<br>" + wartosc.db[1][1];
      }


      btn1.onclick = (e) =>
      {
        dbReq(komunikatorZSerwerem, "test");
      }

      /*
      // -- ok
      dbReq((j) => {
        console.log(" ok, got:", j);
      }, "test");
      // -- invalid
      dbReq((j) => {
        console.log("bad, got:", j);
      }, "test2");
      */
    </script>

    <!-- Podmień zaloguj z Moje Konto w przypadku zalogowania -->
    <!-- Zrub wrapper do logowania w php -->
    <!-- Dodaj loggera do js'a zeby dodawal tokena do linkow -->
    <!-- Wrapper moze obejmowac cale menu -->
    <a href="logowanie.php">Zaloguj</a> 
    <a href="rejestracja.php">Zarejestruj Sie</a> 
    <a href="konto.php">Moje Konto</a> 

    <a href="wizyty.php"> Umuw sie na wizyte </a>
    <a href="informator.php"> Informacje o Pacjencie / Lekarzu </a>
    <a href="apteka.php"> Apteka </a>

  </body>
</html>