#!/bin/bash
set -e

IMAGE=$IMAGE
CONTAINER=$CONTAINER
DOCKER_ENV=$DOCKER_ENV
RESTART=$RESTART
NETWORK=$NETWORK
IP=$IP
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
	--mount type=bind,source="$FILEPORT",target=/fileport \
	--mount type=bind,source="$DOCKER_BINDS_DIR"/secrets,target=/secrets \
	--mount type=bind,source="$DOCKER_BINDS_DIR"/runner,target=/util/runner/log \
	--mount source="$VOLUME",target=/host \
	--network "$NETWORK" \
	--ip "$IP" \
	-p "$TOMCAT_PORT":8080 \
	-d "$IMAGE" tomcat "$@"
