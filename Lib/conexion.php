<?php 
namespace Lib;
use mysqli;

class conexion{

    private mysqli $conexion;
    private mixed $resultado;

    function __construct(
        private string $server = SERVIDOR,
        private string $user = USUARIO,
        private string $password = CONTRASENA,
        private string $database = BASE_DATOS   
    ){
        $this->conexion = $this->conectar();
    }

    private function conectar() {
        $conexion = new mysqli($this->server,$this->user,$this->password,$this->database);
        if(mysqli_connect_error()){
            echo "erroren la coneccion " . mysqli_connect_errno();
        }
        return $conexion;
    }

    public function consulta(string $consultaSQL): void{
        $this->resultado = $this->conexion->query($consultaSQL);
    }
    public function extraer_reguistro(): mixed{
        return ($fila = $this->resultado->fetch_array(MYSQLI_ASSOC))? $fila:false;
    }
    public function extraer_todo(): array{
        return ($this->resultado->fetch_all(MYSQLI_ASSOC));
    }
}
