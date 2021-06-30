## Docker install on Ubuntu system:

```console
sudo apt-get install docker docker-compose  
```

## Run Docker configuration to get all components:

```console
sudo docker-compose up
```

## Running php container as ssh connection:

```console
sudo scripts/docker-bash.sh php
```

## Database import:

1. `sudo chmod 777 db/`
2. Move import db script to `db/` directory.
3. `sudo scripts/docker-bash.sh db`
4. `cd var/lib/mysql`
5. `mysql -u <username> -p <database_name> < file.sql`

## Xdebug 2.5.5 setup for PHPStorm

All required xdebug settings will be places in docker
`/usr/local/etc/php/php.ini`, only will need to 
configure PhpStorm IDE to catch breakpoints on execution. Will need to
fallow this tutorial https://hackernoon.com/how-to-debug-php-container-with-xdebug-and-phpstorm-1b2k3yjo - How To Debug PHP Container With Xdebug And PhpStorm!