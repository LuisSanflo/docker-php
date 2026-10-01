FROM php:8.1-apache
RUN apt-get update && \
    apt-get install -y \
        libzip-dev unzip libicu-dev libxml2-dev libcurl4-openssl-dev libpng-dev libjpeg-dev libfreetype6-dev libonig-dev libssl-dev && \
    docker-php-ext-install \
        zip pdo_mysql mysqli intl mbstring xml curl gd bcmath soap opcache
# Install Xdebug
RUN pecl install xdebug \
    && docker-php-ext-enable xdebug
# Configure Xdebug
COPY xdebug.ini /usr/local/etc/php/conf.d/xdebug.ini
RUN a2enmod rewrite && a2enmod autoindex

COPY apache-custom.conf /etc/apache2/sites-available/000-default.conf
ARG UID=1000
ARG GID=1000
RUN groupadd -g $GID appuser && useradd -m -u $UID -g $GID appuser
RUN chown -R appuser:appuser /var/www/html
USER appuser
EXPOSE 80