#!/bin/bash

MAVEN_TAG=229

build() {
	docker image build \
		--build-arg DOCKER_USER="$DOCKER_USER" \
		-t "$IMAGE" .
}

if [ "$DOCKER_USER" = docker4gis ]; then
	# Building the base image.
	build
else
	# Building an extension image (using the docker4gis/maven image).
	pom=$(find . -maxdepth 2 -name pom.xml | head -n 1)
	src_dir=$(dirname "$pom")
	src_dir=$(realpath "$src_dir")
	# The values of the env vars on the line below only prevail for the maven
	# run; afterwards, they still have the value they have now.
	DOCKER_REGISTRY='docker.io' DOCKER_USER=docker4gis \
		"$BASE"/docker4gis/run.sh maven "$MAVEN_TAG" "$src_dir" &&
		{
			webapps_dir=conf/webapps
			mkdir -p "$webapps_dir"
			war_file=$webapps_dir/$(basename "$src_dir").war
			cp "$src_dir"/target/*.war "$war_file"
			build
			rm -f "$war_file"
			rm -rf "$webapps_dir"
		}
fi
