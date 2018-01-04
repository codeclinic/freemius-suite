<?php
    require_once 'freemius-php-api/freemius/FreemiusBase.php';
    require_once 'freemius-php-api/freemius/Freemius.php';

    $sandbox = ($argv[6] === 'true');
    define( 'FS__API_SCOPE', 'developer' );
    define( 'FS__API_DEV_ID', $argv[1] );
    define( 'FS__API_PUBLIC_KEY', $argv[2] );
    define( 'FS__API_SECRET_KEY', $argv[3] );

    echo "-Deploy in progress on Freemius\n";

    // Init SDK.
    $api = new Freemius_Api(FS__API_SCOPE, FS__API_DEV_ID, FS__API_PUBLIC_KEY, FS__API_SECRET_KEY, $sandbox);

    // Upload the zip
    $deploy = $api->Api('plugins/'.$argv[5].'/tags.json', 'POST', array(
        'add_contributor' => false
    ), array(
        'file' => $argv[4]
    ));

    if (!is_object($api)) {
        print_r($deploy);
        die();
    }

    echo "-Deploy done on Freemius\n";

    // Set as released
    $is_released = $api->Api('plugins/'.$argv[5].'/tags/'.$deploy->id.'.json', 'PUT', array(
        'is_released' => true
    ), array());

    echo "-Set as released on Freemius\n";

    // Generate url to download the zip
    $zip = $api->GetSignedUrl('plugins/'.$argv[5].'/tags/'.$deploy->id.'.zip');

    $path = pathinfo($argv[4]);
    $newzipname = $path['dirname'] . '/' . basename($argv[4], '.zip');
    $newzipname .= '.free.zip';

    file_put_contents($newzipname,file_get_contents($zip));

    echo "-Download Freemius free version\n";
