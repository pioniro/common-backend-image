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
    && echo extension=redis.so > /usr/local/etc/php/conf.d/redis.ini

## Install Composer.
ENV COMPOSER_HOME /root/composer
ENV COMPOSER_ALLOW_SUPERUSER 1
ENV PATH $COMPOSER_HOME/vendor/bin:$PATH
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer


COPY bin/*.sh /opt/docker/provision/entrypoint.d/
COPY start.sh /opt/docker/provision/


RUN \
    chmod +x /opt/docker/provision/entrypoint.d/*.sh && \
    chmod +x /opt/docker/provision/start.sh && \
    chmod 600 /etc/ssh/id_rsa

WORKDIR /project


CMD /opt/docker/provision/start.sh