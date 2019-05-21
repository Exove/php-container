FROM php:7.2-fpm-alpine as php_builder
ADD conf/php.ini /usr/local/etc/php/php.ini
RUN apk update
RUN apk upgrade
RUN apk add --no-cache bash libpng-dev libxml2-dev icu-dev tidyhtml-dev
RUN docker-php-ext-install -j2 gd soap intl sockets calendar exif pdo_mysql tidy zip pcntl
RUN apk add --no-cache build-base autoconf libmemcached libmemcached-dev imagemagick-dev
RUN pecl install igbinary
RUN pecl install msgpack
RUN pecl install imagick
RUN pecl download memcached-3.1.3 && tar -xozvf memcached-3.1.3.tgz && cd memcached-3.1.3 && phpize && ./configure --enable-memcached-igbinary=yes --enable-memcached-msgpack=yes && make && make install

# relase date 2019-05-06, see https://pecl.php.net/package/xdebug \
# docker tool enables xdebug, thus we just have a configuration file for it in conf.d/20-xdebug.ini
RUN apk --update --no-cache add autoconf g++ make && \
    pecl install -f xdebug-2.7.2

FROM php:7.2-fpm-alpine as php

RUN apk update
RUN apk upgrade
RUN apk del -r --purge gcc musl-dev libc-dev zlib-dev
RUN apk add --no-cache bash libpng libxml2 icu tidyhtml libmemcached gettext imagemagick

COPY --from=php_builder /usr/local/lib/php/extensions/no-debug-non-zts-20170718/* /usr/local/lib/php/extensions/no-debug-non-zts-20170718/

RUN docker-php-ext-enable xdebug

ADD conf/php.ini /usr/local/etc/php/php.ini
ADD conf/php.d/ /usr/local/etc/php/conf.d/
