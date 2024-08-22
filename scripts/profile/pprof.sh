#/!bin/bash

set -eu

cd $(dirname $0)/../../webapp/golang
APP_FILE=app.go

on() {
    sed -i '' "s/\t\/\/ setPProf()/\tsetPProf()/" $APP_FILE
    sed -i '' 's/\t\/\/ _ "net\/http\/pprof"/\t_ "net\/http\/pprof"/' $APP_FILE
    rm -f ${APP_FILE}-e
}

off() {
    sed -i '' "s/\tsetPProf()/\t\/\/ setPProf()/" $APP_FILE
    sed -i '' 's/\t_ "net\/http\/pprof"/\t\/\/ _ "net\/http\/pprof"/' $APP_FILE
    rm -f ${APP_FILE}-e
}

if [ "$1" = "off" ]; then
    off
else
    on
fi
