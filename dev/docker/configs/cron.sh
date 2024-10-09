#!/bin/sh

while true; do
    /usr/bin/php /www/artisan schedule:run
    sleep 60;
done
