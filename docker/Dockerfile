ARG VERSION

FROM php:$VERSION

ARG PHP_VERSION
ARG USER_NAME
ARG USER_ID

## Apache ENVs
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_PID_FILE /var/run/apache2/apache2.pid
ENV APACHE_SERVER_NAME localhost
ENV APACHE_CONF_DIR=/etc/apache2
ENV PHP_CONF_DIR=/etc/php/$PHP_VERSION
ENV PHP_DATA_DIR=/var/lib/php

COPY install.sh ./install.sh

RUN bash ./install.sh $PHP_VERSION

## Install Xdebug
RUN BEFORE_PWD=$(pwd) \
    && mkdir -p /opt/xdebug \
    && cd /opt/xdebug \
    && curl -k -L https://github.com/xdebug/xdebug/archive/XDEBUG_2_5_5.tar.gz | tar zx \
    && cd xdebug-XDEBUG_2_5_5 \
    && phpize \
    && ./configure --enable-xdebug \
    && make clean \
    && sed -i 's/-O2/-O0/g' Makefile \
    && make \
    # && make test \
    && make install \
    && cd "${BEFORE_PWD}" \
    && rm -r /opt/xdebug
RUN docker-php-ext-enable xdebug
COPY ./PHP/docker-php.ini /usr/local/etc/php/php.ini

COPY ./Apache/configs/apache2.conf ${APACHE_CONF_DIR}/apache2.conf
COPY ./Apache/configs/app.conf ${APACHE_CONF_DIR}/sites-enabled/app.conf
COPY ./Apache/configs/php.ini  ${PHP_CONF_DIR}/apache2/conf.d/custom.ini

RUN useradd -r -u $USER_ID -ms /bin/bash $USER_NAME
USER $USER_NAME
WORKDIR /home/$USER_NAME

EXPOSE 80 81 443

RUN echo 'cd /var/www/html' >> ~/.bashrc

## Launch Apache
CMD ["/usr/sbin/apache2", "-DFOREGROUND"]
