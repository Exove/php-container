FROM php:7.1-fpm-alpine as php_builder
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
    tidyhtml-dev \
    libmcrypt-dev \
    bzip2-dev \
    gettext-dev \
    libxslt-dev
RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ --with-webp-dir=/usr/include/
RUN docker-php-ext-install -j$(nproc) \
    gd \
    soap \
    intl \
    sockets \
    calendar \
    exif \
    mysqli \
    pdo_mysql \
    tidy \
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
RUN pecl install igbinary
RUN pecl install msgpack
RUN pecl install imagick
RUN pecl download memcached-3.1.3 && \
    tar -xozvf memcached-3.1.3.tgz && \
    cd memcached-3.1.3 && phpize && \
    ./configure --enable-memcached-igbinary=yes --enable-memcached-msgpack=yes && \
    make -j$(nproc) && make install
# relase date 2019-05-06, see https://pecl.php.net/package/xdebug \
RUN pecl install -f xdebug-2.7.2


FROM php:7.1-fpm-alpine as php

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
    tidyhtml \
    libmcrypt \
    libmemcached \
    gettext \
    imagemagick \
    libintl \
    libxslt

COPY --from=php_builder /usr/local/lib/php/extensions/no-debug-non-zts-20160303/* /usr/local/lib/php/extensions/no-debug-non-zts-20160303/

# docker tool enables xdebug, thus we just have a configuration file for it in conf.d/20-xdebug.ini
RUN docker-php-ext-enable xdebug

COPY conf/php.ini /usr/local/etc/php/php.ini
COPY conf/php.d/ /usr/local/etc/php/conf.d/

RUN php -m
RUN php -v
