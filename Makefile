up:
	docker compose -f ./docker/docker-compose.local.yml up -d
down:
	docker compose -f ./docker/docker-compose.local.yml down
build:
	docker compose -f ./docker/docker-compose.local.yml build
