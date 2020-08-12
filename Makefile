# TAG=$(shell date +%Y%m%d)
TAG=latest
DOCKER_HUB_ORG ?= jozian
DOCKER_HUB_PRJ ?= rapidpro
DOCKER_HUB_COURIER ?= courier
DOCKER_HUB_MAILROOM ?= mailroom
DOCKER_HUB_RP-ARCHIVER ?= rp-archiver
DOCKER_HUB_RP-INDEXER ?= rp-indexer
NETWORK_NAME = rapidpro
NETWORK_ID = $(shell docker network ls -qf name=${NETWORK_NAME})

network:
	@if [ -n "${NETWORK_ID}" ]; then \
		echo "The ${NETWORK_NAME} network already exists. Skipping..."; \
	else \
		docker network create ${NETWORK_NAME}; \
	fi

build:
	@docker-compose build --pull ${BUILD_ARGS}
	# @docker build --tag ${DOCKER_HUB_ORG}/${DOCKER_HUB_PRJ}:${TAG} .

build-no-cache:
	@docker-compose build --pull --no-cache ${BUILD_ARGS}

build-courier:
	@docker build --tag ${DOCKER_HUB_ORG}/${DOCKER_HUB_COURIER}:${TAG} -f ../courier/Dockerfile ../courier

build-mailroom:
	@docker build --tag ${DOCKER_HUB_ORG}/${DOCKER_HUB_MAILROOM}:${TAG} -f ../mailroom/Dockerfile ../mailroom

build-rp-archiver:
	@docker build --tag ${DOCKER_HUB_ORG}/${DOCKER_HUB_RP-ARCHIVER}:${TAG} -f ../rp-archiver/Dockerfile ../rp-archiver

build-rp-indexer:
	@docker build --tag ${DOCKER_HUB_ORG}/${DOCKER_HUB_RP-INDEXER}:${TAG} -f ../rp-indexer/Dockerfile ../rp-indexer

push:
	docker push ${DOCKER_HUB_ORG}/${DOCKER_HUB_PRJ}:${TAG}

up: network
	@sudo sysctl -w vm.max_map_count=262144
	@echo never | sudo tee /sys/kernel/mm/transparent_hugepage/enabled
	@docker-compose up
	# @docker-compose up ${DOCKER_HUB_PRJ}

down:
	@docker-compose down

shell:
	@docker-compose exec ${DOCKER_HUB_PRJ} bash

db-migrate:
	@docker-compose exec ${DOCKER_HUB_PRJ} python manage.py migrate

reset:
	# @sudo rm -rf ../rapidpro-data/

	@mkdir ../primero-data/
	@mkdir -p ../rapidpro-data/rapidpro/sitestatic/
	@cp temba/settings.py.dev.docker ../rapidpro-data/rapidpro/


	@mkdir -p ../primero-data/db/data/

	@mkdir ../primero-data/letsencrypt/

	@mkdir -p ../rapidpro-data/es/data/

	@mkdir -p ../rapidpro-data/celery/schedule

clone:
	@git clone --branch docker git@github.com:Jozian/courier.git ../courier
	@git clone --branch docker git@github.com:Jozian/mailroom.git ../mailroom
	@git clone --branch docker git@github.com:Jozian/rp-archiver.git ../rp-archiver
	@git clone --branch docker git@github.com:Jozian/rp-indexer.git ../rp-indexer
