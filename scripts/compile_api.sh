#!/usr/bin/env bash
# UID GID to use in containers
export UID_GID="$(id -u):$(id -g)"
# Make mount dir
if [ ! -d "api" ]; then
    mkdir api
fi
docker-compose up api_compile
docker rm api_compile
