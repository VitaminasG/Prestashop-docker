#!/bin/bash
set -e

apt-get update && \
apt-get install -y build-essential && \
apt-get install -y software-properties-common && \
apt-get install -y \
    curl \
    wget \
    git \
    nano \
    gnupg \
    man \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libmcrypt-dev \
    libpng-dev \
    libxml2-dev \
    libxslt1-dev \
    unzip \
    zip \
    cron

apt-get update && \
apt-get install -y apache2

docker-php-ext-install -j$(nproc) iconv pdo_mysql bcmath xml xsl mbstring soap json zip intl

docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/
docker-php-ext-install -j$(nproc) gd

curl -sL 'https://deb.nodesource.com/setup_10.x' | bash
apt-get install --yes nodejs
npm install -g grunt-cli

rm -rf /var/lib/apt/lists/*

curl -Lsf 'https://storage.googleapis.com/golang/go1.8.3.linux-amd64.tar.gz' | tar -C '/usr/local' -xvzf -

export PATH=$PATH:/usr/local/go/bin
source /etc/environment && export PATH

go get github.com/mailhog/mhsendmail
cp /root/go/bin/mhsendmail /usr/bin/mhsendmail

php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php composer-setup.php --install-dir=/usr/local/bin --filename=composer \
    && php -r "unlink('composer-setup.php');"

## Install Xdebug
phpVersionCut=$(printf %.3s "$1")

if [ $phpVersionCut == "5.6" ];then
  BEFORE_PWD=$(pwd)
  mkdir -p /opt/xdebug
  cd /opt/xdebug
  curl -k -L https://github.com/xdebug/xdebug/archive/XDEBUG_2_5_5.tar.gz | tar zx
  cd xdebug-XDEBUG_2_5_5
  phpize
  ./configure --enable-xdebug
  make clean
  sed -i 's/-O2/-O0/g' Makefile
  make install
  cd "${BEFORE_PWD}"
  rm -r /opt/xdebug
  docker-php-ext-enable xdebug
else
  docker-php-ext-install mysqli
  pecl install xdebug-2.7.0
  docker-php-ext-enable xdebug
fi

## For PrestaShop
a2enmod rewrite
service apache2 restart