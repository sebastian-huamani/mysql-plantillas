<?php
    require_once("Lib/autoloader.php");
    use Lib\conexion;

    $server = "localhost";
    $user = "root";
    $pass = "";
    $db = "dbejemplo";
    $conexion = new conexion($server,$user,$pass,$db);
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Conexion Database</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
</head>
<body>

    
    <h1> conexion establecida</h1>
    <div class="container">
        <div class="d-grid gap-3">
        <?php 
            $conexion->consulta("select * from contactos;");
            while ($fila = $conexion->extraer_reguistro()){
                echo '<div class="card">
                        <div class="card-body">';
                foreach($fila as $campo => $valor){
                    echo "<div>$campo: $valor</div>";
                }
                echo  "</div> </div>";
            }

            // $lista = $conexion->extraer_todo();
            // echo '<pre>';
            //     var_dump($lista);
            // echo '</pre>';
            
        ?>
        </div>
    </div>
</body>
</html>