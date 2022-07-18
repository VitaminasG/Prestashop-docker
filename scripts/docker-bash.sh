#!/bin/bash

ROOT_DIR="$( cd -P "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$ROOT_DIR/../.env"
docker exec -it $NAME"-php-"$PHP_VERSION /bin/bash