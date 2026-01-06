#!/usr/bin/env bash
# UID GID to use in containers
export UID_GID="$(id -u):$(id -g)"
# Make mount dirs
if [ ! -d "mars" ]; then
    mkdir mars
fi
if [ ! -d "api" ]; then
    mkdir api
fi
if [ ! -d "server" ]; then
    mkdir server
fi

# throw the compilation tasks in the bg
docker-compose up api_compile mars_compile -d --build
docker exec mars_compile './compile_mars.sh' &
plugin_compile_pid=$!
# effectively, join both of them
docker logs -f api_compile
wait $plugin_compile_pid

# we dont need the API compilation container anymore, it is a one-shot container that compiles and exits
# the plugin compilation container keeps the gradle daemon around, so we do not stop that one
docker stop api_compile

# sanity checks to make sure the compilation outputs are present
if [ ! -d "mars/build" ]; then
    echo "Mars build dir doesn't exist!"
    exit 1
fi
if [ ! -d "api/target" ]; then
    echo "mars-api-rs target dir doesn't exist!"
    exit 1
fi

# start the MC server, API, Redis, DB
docker-compose up -d mcsrv --build
