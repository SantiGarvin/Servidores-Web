<?php
$solicitudes = 1;

if (file_exists('contador.txt')) {
    $solicitudes = intval(file_get_contents('contador.txt'));
    $solicitudes++;
}

file_put_contents('contador.txt', $solicitudes);

$carga_cpu = sys_getloadavg()[0];

$datos = array(
    'servidor' => gethostname(),
    'solicitudes' => $solicitudes,
    'carga_media' => $carga_cpu
);

header('Content-Type: application/json');
echo json_encode($datos); 