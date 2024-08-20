#!/bin/bash

set -eu

cd $(dirname $0)/../profiles/mysql

pt-query-digest ../../logs/mysql/mysql-slow.log > slow_query_$(date +%H%M%S).log
