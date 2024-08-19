#/!bin/bash

set -eu

cd $(dirname $0)/../../webapp/etc/nginx
NGINX_CONF_FILE=nginx.conf

on() {
    sed -i '' "s/access_log off;/access_log \/var\/log\/nginx\/access.log with_time;/" $NGINX_CONF_FILE
    rm -f ${NGINX_CONF_FILE}-e
}

off() {
    sed -i '' "s/access_log \/var\/log\/nginx\/access.log with_time;/access_log off;/" $NGINX_CONF_FILE
    rm -f ${NGINX_CONF_FILE}-e
}

if [ "$1" = "off" ]; then
    off
else
    on
fi
