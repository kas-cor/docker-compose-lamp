FROM php:8.4.4-apache-bullseye

# Surpresses debconf complaints of trying to install apt packages interactively
# https://github.com/moby/moby/issues/4032#issuecomment-192327844

ARG DEBIAN_FRONTEND=noninteractive

# Update & upgrade & autoremove
RUN apt-get update -y --fix-missing
RUN apt-get upgrade -y --fix-missing
RUN apt-get autoremove -y --fix-missing

# Install useful tools and install important libaries
RUN apt-get install -y --no-install-recommends --fix-missing apt-utils nano wget dialog librdkafka-dev libsqlite3-dev libsodium-dev libsqlite3-0 \
    default-mysql-client zlib1g-dev libzip-dev libpq-dev libicu-dev build-essential git curl libonig-dev unzip libcurl4 ca-certificates gnupg \
    libcurl4-openssl-dev zip golang-go openssl libc-client-dev libkrb5-dev libmagickwand-dev libldap2-dev libnss-ldap libpam-ldap ldap-utils libmemcached-dev

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install XDebug
RUN pecl install xdebug && docker-php-ext-enable xdebug

# Install Redis
RUN pecl install redis && docker-php-ext-enable redis

# Install IMAP
RUN pecl install imap && docker-php-ext-enable imap

# Imagick to install
# https://github.com/Imagick/imagick
RUN cd /usr/local/src && \
    git clone https://github.com/Imagick/imagick && \
    cd imagick && \
    phpize && \
    ./configure && \
    make && \
    make install && \
    cd .. && \
    rm -rf imagick
RUN docker-php-ext-enable imagick

# Install openswoole
RUN pecl install openswoole && docker-php-ext-enable openswoole

# Install Memcached
RUN pecl install memcached && docker-php-ext-enable memcached

# Other PHP84 Extensions
RUN docker-php-ext-install pdo_mysql
RUN docker-php-ext-install pdo_sqlite
RUN docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql && docker-php-ext-install pdo pdo_pgsql pgsql
RUN docker-php-ext-install mysqli
RUN docker-php-ext-install curl
RUN docker-php-ext-install zip
RUN docker-php-ext-install -j$(nproc) intl
RUN docker-php-ext-install mbstring
RUN docker-php-ext-install gettext
RUN docker-php-ext-install calendar
RUN docker-php-ext-install exif
RUN docker-php-ext-install soap
RUN docker-php-ext-install bcmath
RUN docker-php-ext-install ldap
RUN docker-php-ext-install sodium
RUN docker-php-ext-install ftp

# Install Freetype
RUN apt-get install -y --no-install-recommends --fix-missing libfreetype6-dev libjpeg62-turbo-dev libpng-dev
RUN docker-php-ext-configure gd --enable-gd --with-freetype --with-jpeg && docker-php-ext-install gd

# Enable Apache modules
RUN a2enmod rewrite headers

# Install MailHog mhsendmail
RUN mkdir -p /root/gocode && \
    export GOPATH=/root/gocode && \
    go get github.com/mailhog/mhsendmail && \
    cp /root/gocode/bin/mhsendmail /usr/local/bin/

# Install Bun
RUN curl -fsSL https://bun.sh/install | bash

RUN usermod -u 1000 www-data

# Cleanup
RUN rm -rf /usr/src/*
RUN rm -rf /var/lib/apt/lists/*

COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh

RUN echo "\n: \${APACHE_DOCUMENT_ROOT:=/var/www/html}\nexport APACHE_DOCUMENT_ROOT" >> /etc/apache2/envvars

ENTRYPOINT /entrypoint.sh
