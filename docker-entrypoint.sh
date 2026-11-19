#!/bin/sh
set -eu

if [ ! -d vendor ]; then
    composer install --no-interaction --prefer-dist
fi
if [ ! -f .env ]; then
    cp .env.example .env
fi
if ! grep -Eq '^APP_KEY=.+$' .env; then
    php artisan key:generate --no-interaction
fi
if [ ! -f database/database.sqlite ]; then
    touch database/database.sqlite
    php artisan migrate --force --no-interaction
fi
exec "$@"
