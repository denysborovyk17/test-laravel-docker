FROM php:8.4-fpm-alpine

RUN apk add --no-cache \
    bash \
    curl \
    git \
    unzip \
    libzip-dev \
    icu-dev \
    oniguruma-dev \
    postgresql-dev

RUN apk add --no-cache --virtual .build-deps \
    $PHPIZE_DEPS

RUN docker-php-ext-install \
    pdo \
    pdo_mysql \
    pdo_pgsql \
    pgsql \
    mbstring \
    intl \
    zip \
    bcmath \
    opcache

RUN pecl install redis && docker-php-ext-enable redis

RUN apk del .build-deps

RUN curl -sS https://getcomposer.org/installer | php \
    -- --install-dir=/usr/local/bin --filename=composer

WORKDIR /var/www/laravel

RUN adduser -D -u 1000 www && chown -R www:www /var/www/laravel
USER www

EXPOSE 9000

CMD ["php-fpm"]