FROM php:8.3-fpm as php-nginx

RUN apt update -y \
    && apt install -y \
      nginx \
      supervisor \
      wget

COPY configs/supervisord.conf /etc/supervisord.conf
COPY --chmod=744 scripts/entrypoint.sh /usr/local/bin/docker-php-entrypoint

RUN rm /usr/local/etc/php-fpm.conf.default \
      /usr/local/etc/php-fpm.d/www.conf.default \
      /usr/local/etc/php-fpm.d/zz-docker.conf

COPY configs/default.conf /etc/nginx/http.d/default.conf
COPY configs/php.ini-development /usr/local/etc/php/php.ini
COPY configs/php.ini-production /usr/local/etc/php/php.ini-production
COPY configs/php-fpm.conf /usr/local/etc/php-fpm.conf
COPY configs/www.conf /usr/local/etc/php-fpm.d/www.conf

WORKDIR /code

ENV PATH=$PATH:/code/vendor/bin \
    NGINX_START=true \
    PHP_FPM_START=true \
    HTTP_ROOT=/code/public

CMD []

FROM php as builder

COPY --chmod=755 scripts/install-composer.sh /usr/bin/install-composer
COPY --chmod=755 scripts/install-nvm.sh /usr/bin/install-nvm

RUN install-composer \
    && install-nvm \
    && . /root/.bashrc \
    && nvm install 20 \
    && rm /usr/bin/install-composer /usr/bin/install-nvm
