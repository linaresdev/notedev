FROM ubuntu:24.04

LABEL maintainer="Ramon A Linares"

ARG WWWGROUP=moon
ARG WWWUSER=moon
ARG WWWGID=1000
ARG NODE_VERSION=22
ARG MYSQL_CLIENT="mysql-client"

WORKDIR /home/lara

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=America/Santo_Domingo
ENV SUPERVISOR_PHP_COMMAND="/usr/bin/php -d variables_order=EGPCS /var/www/html/artisan serve --host=0.0.0.0 --port=80"
ENV SUPERVISOR_PHP_USER="sail"

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update && apt-get upgrade -y \
    && mkdir -p /etc/apt/keyrings \
    && apt-get install -y gnupg \
        gosu \
        curl \
        ca-certificates \
        zip \
        unzip \
        git \
        supervisor \
        sqlite3 \
        libcap2-bin \
        libpng-dev \
        python3 \
        dnsutils \
        librsvg2-bin \
        fswatch \
        ffmpeg \
        nano \
        nginx

RUN curl -sS 'https://keyserver.ubuntu.com/pks/lookup?op=get&search=0xb8dc7e53946656efbce4c1dd71daeaab4ad4cab6' | gpg --dearmor | tee /etc/apt/keyrings/ppa_ondrej_php.gpg > /dev/null \
    && echo "deb [signed-by=/etc/apt/keyrings/ppa_ondrej_php.gpg] https://ppa.launchpadcontent.net/ondrej/php/ubuntu noble main" > /etc/apt/sources.list.d/ppa_ondrej_php.list

RUN apt-get update \
    && apt-get install -y php8.3-cli \
    php8.3-fpm \
    php8.3-dev \
    php8.3-pgsql \
    php8.3-sqlite3 \
    php8.3-gd \
    php8.3-curl \
    php8.3-mongodb \
    php8.3-imap \
    php8.3-mysql \
    php8.3-mbstring \
    php8.3-xml \
    php8.3-zip \
    php8.3-bcmath \
    php8.3-soap \
    php8.3-intl \
    php8.3-readline \
    php8.3-ldap \
    php8.3-msgpack \
    php8.3-igbinary \
    php8.3-redis \
    php8.3-memcached \
    php8.3-pcov \
    php8.3-imagick \
    php8.3-xdebug \
    php8.3-swoole

RUN curl -sLS https://getcomposer.org/installer | php -- --install-dir=/usr/bin/ --filename=composer \
    && curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg \
    && echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_VERSION.x nodistro main" > /etc/apt/sources.list.d/nodesource.list 

RUN apt-get update \
    && apt-get install -y nodejs \
    && npm install -g npm \
    && npm install -g pnpm \
    && npm install -g bun \
    && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | gpg --dearmor | tee /etc/apt/keyrings/yarn.gpg >/dev/null \
    && echo "deb [signed-by=/etc/apt/keyrings/yarn.gpg] https://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list \
    && apt-get update \
    && apt-get install -y yarn \
    && apt-get install -y $MYSQL_CLIENT \
    && apt-get -y autoremove \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN setcap "cap_net_bind_service=+ep" /usr/bin/php8.3

RUN userdel -r ubuntu

RUN groupadd --force -g ${WWWGID} ${WWWUSER}
RUN useradd -u 1000 -ms /bin/bash --no-user-group -g ${WWWGROUP}  ${WWWUSER}

COPY --chown=${WWWUSER}:${WWWGROUP} ./www /home/${WWWUSER}/www
COPY --chown=${WWWUSER}:${WWWGROUP} ./etc /home/${WWWUSER}/etc

RUN cp /home/${WWWUSER}/etc/nginx/hosts/laravel.conf /etc/nginx/sites-enabled/default

RUN cp /home/${WWWUSER}/etc/app.sh /usr/local/etc/app.sh
RUN chmod +x /usr/local/etc/app.sh

# RUN sed -i 's/user www-data/user lara/g' /etc/nginx/nginx.conf
# RUN sed -i 's/user = www-data/user = lara/g' /etc/php/8.3/fpm/pool.d/www.conf
# RUN sed -i 's/listen.owner = www-data/listen.owner = lara/g' /etc/php/8.3/fpm/pool.d/www.conf
# RUN sed -i 's/listen.group = www-data/listen.group = lara/g' /etc/php/8.3/fpm/pool.d/www.conf

RUN apt-get -y autoremove \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

EXPOSE 80/tcp 443/tcp

ENTRYPOINT ["/usr/local/etc/app.sh"]