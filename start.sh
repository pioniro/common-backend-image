#!/usr/bin/env sh

echo \\nuser = ${APPLICATION_USER:=0}\\ngroup = ${APPLICATION_GROUP:=0}\\n >> /usr/local/etc/php-fpm.d/www.conf
/opt/docker/provision/entrypoint.d/*.sh

php-fpm -R