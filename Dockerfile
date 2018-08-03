FROM php:7.2-fpm


RUN buildDeps=" \
        libbz2-dev \
        libmemcached-dev \
        libsasl2-dev \
        build-essential \
    " \
    runtimeDeps=" \
        curl \
        git \
        gettext \
        libfreetype6-dev \
        libicu-dev \
        libjpeg-dev \
        libmcrypt-dev \
        libmemcachedutil2 \
        libpng-dev \
        libpq-dev \
        libxml2-dev \
        unzip \
        wget \
        nano \
        gnupg2 \
        apt-transport-https \
    " \
    && apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y $buildDeps $runtimeDeps \
    && docker-php-ext-install iconv intl mbstring opcache pdo_mysql pdo_pgsql pgsql \
    && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
    && curl -sL https://deb.nodesource.com/setup_10.x | bash - \
    && apt-get install -y nodejs \
    && apt-get install yarn \
    && apt-get purge -y --auto-remove $buildDeps \
    && rm -r /var/lib/apt/lists/* \
    && pecl channel-update pecl.php.net \
    && printf "\n" | pecl install redis-3.1.6 \
    && echo extension=redis.so > /usr/local/etc/php/conf.d/redis.ini \
    && pecl install igbinary \
    && printf "\n\
        ; Load igbinary extension\n\
        extension=igbinary.so\n\
\n\
        ; Use igbinary as session serializer\n\
        session.serialize_handler=igbinary\n\
\n\
        ; Enable or disable compacting of duplicate strings\n\
        ; The default is On.\n\
        igbinary.compact_strings=On\n\
\n\
        ; If uncommented, use igbinary as the serializer of APCu\n\
        ; (For PHP 7, APCu 5.1.10 or newer is strongly recommended)\n\
        ; For older PHP versions, APC cache is also supported\n\
        ; (must be version 3.1.7 or newer)\n\
        ;apc.serializer=igbinary\n\
        " > /usr/local/etc/php/conf.d/igbinary.ini

## Install Composer.
ENV COMPOSER_HOME /root/composer
ENV COMPOSER_ALLOW_SUPERUSER 1
ENV PATH $COMPOSER_HOME/vendor/bin:$PATH
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer


COPY bin/*.sh /opt/docker/provision/entrypoint.d/
COPY start.sh /opt/docker/provision/


RUN \
    chmod +x /opt/docker/provision/entrypoint.d/*.sh && \
    chmod +x /opt/docker/provision/start.sh

WORKDIR /project


CMD /opt/docker/provision/start.sh