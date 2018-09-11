FROM php:7.1-fpm

RUN mkdir -p /home/docker/www
WORKDIR /home/docker/www

EXPOSE 8001

RUN apt-get update && \
    apt-get install --no-install-recommends -y libicu-dev git wget gnupg zlib1g-dev zip nginx supervisor && \
    apt-get clean && \
    docker-php-ext-install zip pdo pdo_mysql opcache intl mbstring bcmath && \
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN curl -sL https://deb.nodesource.com/setup_8.x | bash - \
	&& apt-get install -y nodejs

COPY docker/site.conf /etc/nginx/nginx.conf

COPY docker/supervisor/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

RUN composer self-update

COPY . /home/docker/www

RUN cd /home/docker/www \
    && composer install --working-dir=/home/docker/www --no-autoloader --no-scripts --no-interaction --no-progress

RUN chown -R www-data:www-data .

RUN cd /home/docker/www \
    && composer dump-autoload

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]