#!/bin/bash
set -e

IMAGE=$IMAGE
CONTAINER=$CONTAINER
DOCKER_ENV=$DOCKER_ENV
RESTART=$RESTART
NETWORK=$NETWORK
FILEPORT=$FILEPORT
VOLUME=$VOLUME

XMS=${XMS:-256m}
XMX=${XMX:-2g}

TOMCAT_PORT=$(docker4gis/port.sh "${TOMCAT_PORT:-9090}")

docker container run --restart "$RESTART" --name "$CONTAINER" \
	-e DOCKER_ENV="$DOCKER_ENV" \
	-e DOCKER_USER="$DOCKER_USER" \
	-e XMS="$XMS" \
	-e XMX="$XMX" \
	-v "$(docker4gis/bind.sh "$FILEPORT" /fileport)" \
	-v "$(docker4gis/bind.sh "$DOCKER_BINDS_DIR"/secrets /secrets)" \
	-v "$(docker4gis/bind.sh "$DOCKER_BINDS_DIR"/runner /util/runner/log)" \
	--mount source="$VOLUME",target=/host \
	--network "$NETWORK" \
	-p "$TOMCAT_PORT":8080 \
	-d "$IMAGE" tomcat "$@"
