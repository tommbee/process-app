<?php

use Symfony\Component\Debug\Debug;
use Symfony\Component\HttpFoundation\Request;

require __DIR__.'/../app/autoload.php';

$env = getenv('SYMFONY_ENV') ?: 'dev';

if ('dev' !== $env) {
    // don't want to use the bootstrap functionality in dev
    include_once __DIR__.'/../app/bootstrap.php.cache';
}

if (getenv('SYMFONY_DEBUG') === 'true') {
    Debug::enable();
}

$kernel = new AppKernel($env, getenv('SYMFONY_DEBUG') === 'true');
if ('dev' !== $env) {
    // don't want to use the bootstrap functionality in dev
    $kernel->loadClassCache();
}
//$kernel = new AppCache($kernel);

// When using the HttpCache, you need to call the method in your front controller instead of relying on the configuration parameter
//Request::enableHttpMethodParameterOverride();
$request = Request::createFromGlobals();
$response = $kernel->handle($request);
$response->send();
$kernel->terminate($request, $response);
