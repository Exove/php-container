FROM php:5.6-fpm-alpine as php_builder
COPY conf/php.ini /usr/local/etc/php/php.ini
RUN apk update
RUN apk upgrade
RUN apk add --no-cache \
    bash \
    libpng-dev \
    jpeg-dev \
    libjpeg-turbo-dev \
    zlib-dev freetype-dev \
    libwebp-dev \
    libxml2-dev \
    icu-dev \
    libmcrypt-dev \
    bzip2-dev \
    gettext-dev \
    libxslt-dev
RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/
RUN docker-php-ext-install -j$(nproc) \
    gd \
    soap \
    intl \
    sockets \
    calendar \
    exif \
    mysqli \
    pdo_mysql \
    zip \
    mcrypt \
    pcntl \
    bz2 \
    gettext \
    shmop \
    sysvmsg \
    sysvsem \
    sysvshm \
    wddx \
    xsl
RUN apk add --no-cache \
    build-base \
    autoconf \
    libmemcached \
    libmemcached-dev \
    imagemagick-dev \
    g++
RUN pecl install imagick
RUN pecl install memcached-2.2.0
RUN pecl install xdebug-2.5.5


FROM php:5.6-fpm-alpine as php

RUN apk update
RUN apk upgrade
RUN apk del -r --purge gcc musl-dev libc-dev zlib-dev
RUN apk add --no-cache \
    bash \
    libpng \
    jpeg \
    libjpeg \
    libjpeg-turbo \
    zlib \
    freetype \
    libwebp \
    libxml2 \
    icu \
    libmcrypt \
    libmemcached \
    gettext \
    imagemagick \
    libintl \
    libxslt

COPY --from=php_builder /usr/local/lib/php/extensions/no-debug-non-zts-20131226/* /usr/local/lib/php/extensions/no-debug-non-zts-20131226/

# docker tool enables xdebug, thus we just have a configuration file for it in conf.d/20-xdebug.ini
RUN docker-php-ext-enable xdebug

COPY conf/php.ini /usr/local/etc/php/php.ini
COPY conf/php.d/ /usr/local/etc/php/conf.d/

RUN php -m
RUN php -v

