<?php

use Crunz\Schedule;

$x = 13;

$scheduler = new Schedule();

$scheduler
    ->run(function () use ($x) {
        echo 'From lambda' . PHP_EOL;
        echo 'Out: ' . $x . PHP_EOL;
    })
    ->description('Lambda echo')
    ->everyMinute();

return $scheduler;
