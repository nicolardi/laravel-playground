HOST_UID := $(shell id -u)
HOST_GID := $(shell id -g)
export HOST_UID HOST_GID

.PHONY: up down shell artisan migrate fresh test logs
up:
	docker compose up -d --build

down:
	docker compose down

shell:
	docker compose exec app sh

artisan:
	@echo 'Uso: docker compose exec app php artisan <comando>'

migrate:
	docker compose exec app php artisan migrate

fresh:
	docker compose exec app php artisan migrate:fresh

test:
	docker compose exec app php artisan test

logs:
	docker compose logs -f app
