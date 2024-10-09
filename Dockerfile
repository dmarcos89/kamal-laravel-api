FROM existenz/webstack:8.2

COPY dev/docker/configs/cron.sh /usr/local/bin/

EXPOSE 80

RUN apk -U --no-cache add \
        php82 \
        php82-dev \
        php82-gd \
        php82-curl \
        php82-pdo_mysql \
        php82-pdo_sqlite \
        php82-mbstring \
        php82-xml \
        php82-zip \
        php82-bcmath \
        php82-soap \
        php82-intl \
        php82-phar \
        php82-dom \
        php82-tokenizer \
        php82-xmlwriter \
        php82-session \
        php82-fileinfo \
        php82-simplexml \
        php82-iconv \
        php82-ctype \
        php82-pecl-redis \
        php82-pear \
        openssh \
        gcc \
        musl-dev \
        make \
        redis \
        && rm -rf /var/cache/apk/*

# RUN ln -s /usr/bin/php82 /usr/bin/php

COPY dev/docker/configs/php/opcache.ini /etc/php82/conf.d/
COPY dev/docker/configs/php/local.ini /etc/php82/conf.d/

# Copy vendor first so we don't have to copy this when it didn't change
COPY --chown=php:nginx ./vendor /tmp/vendor
COPY --chown=php:nginx . /www

# Remove the vendor so we don't have to chmod that (saves a lot of time!)
RUN rm -rf /www/vendor

RUN find /www -type d -exec chmod -R 555 {} \; \
    && find /www -type f -exec chmod -R 444 {} \; \
    && find /www/storage /www/bootstrap/cache -type d -exec chmod -R 755 {} \; \
    && find /www/storage /www/bootstrap/cache -type f -exec chmod -R 644 {} \;

# Grant write permissions to the SQLite database file
RUN touch /www/database/database.sqlite \
    && chmod 664 /www/database/database.sqlite
    
# Put vendor back where it belongs
RUN mv /tmp/vendor /www/vendor
