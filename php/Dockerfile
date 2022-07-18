ARG PHP_VERSION

FROM php:$PHP_VERSION-fpm

ARG USER_NAME
ARG USER_ID

RUN apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
        libicu-dev \
        zip \
        zlib1g-dev

# Adding php docker extensions
RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/
RUN docker-php-ext-install -j$(nproc) gd zip intl pdo pdo_mysql bcmath mbstring mysqli

# Composer and node install
RUN apt-get install -y --no-install-recommends libssl-dev zlib1g-dev
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN curl -sL https://deb.nodesource.com/setup_12.x -o nodesource_setup.sh && bash nodesource_setup.sh && apt-get -y --force-yes install nodejs

# Needs for mailhog to send mails
RUN apt-get update &&\
    apt-get install --no-install-recommends --assume-yes --quiet ca-certificates curl git &&\
    rm -rf /var/lib/apt/lists/*
RUN curl -Lsf 'https://storage.googleapis.com/golang/go1.8.3.linux-amd64.tar.gz' | tar -C '/usr/local' -xvzf -
ENV PATH /usr/local/go/bin:$PATH
RUN go get github.com/mailhog/mhsendmail
RUN cp /root/go/bin/mhsendmail /usr/bin/mhsendmail
# Needs for mailhog to send mails

# Xdebug install
RUN pecl install xdebug
RUN docker-php-ext-enable xdebug


