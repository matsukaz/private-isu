#!/bin/bash

set -eu

cd $(dirname $0)/../profiles/nginx

if [ ! -f kataribe.toml ]; then
    kataribe -generate
fi

cat ../../logs/nginx/access.log | kataribe -f kataribe.toml > kataribe_$(date +%H%M%S).log
