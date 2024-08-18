#/bin/bash

set -eu

on() {
    mysql -uroot -proot -e "set global slow_query_log_file = '/var/log/mysql/mysql-slow.log';"
    mysql -uroot -proot -e "set global long_query_time = 0;"
    mysql -uroot -proot -e "set global slow_query_log = ON;"
}

off() {
    mysql -uroot -proot -e "set global long_query_time = 10;"
    mysql -uroot -proot -e "set global slow_query_log = OFF;"
}

if [ "$1" = "off" ]; then
    off
else
    on
fi

