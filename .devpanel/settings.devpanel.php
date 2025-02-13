<?php

$databases['default']['default'] = array (
  'database' => getenv('DB_NAME'),
  'username' => getenv('DB_USER'),
  'password' => getenv('DB_PASSWORD'),
  'host' => getenv('DB_HOST'),
  'port' => getenv('DB_PORT'),
  'driver' => getenv('DB_DRIVER'),
);
$settings['config_sync_directory'] = '../config/sync';
$settings['trusted_host_patterns'] = [
  '^.+',
];
