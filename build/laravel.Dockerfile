FROM composer:2 as composer

ARG version=dev-master
ARG http_version=dev-master
WORKDIR /ppm
COPY etc/composer.json composer.json
RUN composer require php-pm/php-pm:${version} php-pm/httpkernel-adapter:${http_version}

FROM alpine:3.14

ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8

RUN apk --no-cache upgrade --available && \
    sync

RUN apk --no-cache add bash curl nginx tzdata && \
    cp /usr/share/zoneinfo/Etc/UTC /etc/localtime && \
    echo "UTC" | tee /etc/timezone && \
    apk del tzdata

RUN apk --no-cache add \
    php7 php7-common php7-cli php7-cgi php7-fpm php7-opcache php7-phar php7-session \
    php7-bcmath php7-ctype php7-fileinfo php7-json php7-mbstring php7-openssl php7-pdo_mysql php7-tokenizer php7-xml \
    php7-dom php7-pcntl php7-posix php7-simplexml php7-sodium

COPY etc/php.ini /etc/php7/php.ini

# Install composer
ENV PATH ./vendor/bin:/composer/vendor/bin:$PATH
ENV COMPOSER_HOME /composer
ENV COMPOSER_ALLOW_SUPERUSER 1
RUN curl -s https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin/ --filename=composer

COPY etc/nginx_default.conf /etc/nginx/sites-enabled/default
COPY etc/nginx.conf /etc/nginx/nginx.conf

EXPOSE 80

COPY --from=composer /ppm /ppm

WORKDIR /var/www

COPY run-nginx.sh /etc/app/run.sh
ENTRYPOINT ["/bin/bash", "/etc/app/run.sh"]
