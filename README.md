# php-container

This is part of the [Exove's Local-docker](https://github.com/Exove/local-docker) stack for PHP development (namely [Drupal](https://drupal.org) projects). 

However, this can be used individually as well:

        $ docker run xoxoxo/php-container:7.4-1.0 bash -c 'php -v'
        
        PHP 7.4.16 (cli) (built: Mar  6 2021 04:31:10) ( NTS )
        Copyright (c) The PHP Group
        Zend Engine v3.4.0, Copyright (c) Zend Technologies
            with Zend OPcache v7.4.16, Copyright (c), by Zend Technologies
            with Xdebug v3.0.3, Copyright (c) 2002-2021, by Derick Rethans


PHP 7.4 based on Alpine Linux with following extensions:
- calendar
- curl
- ctype
- date
- dom
- exif
- fileinfo
- filter
- ftp
- hash
- iconv
- json
- libxml
- mbstring
- mysqlnd
- openssl
- pcre
- pdo_sqlite
- Phar
- posix
- readline
- Reflection
- session
- SimpleXML
- tokenizer
- xml
- xmlreader
- xmlwriter
- bcmath
- Zend OPcache
- zip
- zlib
- Xdebug (3.x)

Additional extensions build in:
- gd
- soap
- intl
- sockets
- calendar
- exif
- mysqli
- pdo_mysql
- tidy
- zip
- pcntl
- bz2
- gettext
- hmop
- sysvmsg
- sysvsem
- sysvshm
- xsl
- bcmath
