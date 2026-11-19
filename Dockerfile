FROM php:8.4-cli-bookworm

RUN apt-get update && apt-get install -y --no-install-recommends \
    git unzip libsqlite3-dev libonig-dev libxml2-dev libcurl4-openssl-dev \
    && docker-php-ext-install pdo_sqlite mbstring xml curl \
    && rm -rf /var/lib/apt/lists/*

COPY --from=composer:2 /usr/bin/composer /usr/local/bin/composer
RUN useradd -m -u 1000 -s /bin/bash app
WORKDIR /workspace/src
COPY --chown=app:app docker-entrypoint.sh /usr/local/bin/playground-entrypoint
RUN chmod +x /usr/local/bin/playground-entrypoint
USER app
EXPOSE 8181
ENTRYPOINT ["playground-entrypoint"]
CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=8181"]
