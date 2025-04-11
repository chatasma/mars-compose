#!/usr/bin/env bash
source ./scripts/common_utils.sh
# UID GID to use in containers
export UID_GID="$(id -u):$(id -g)"
compile_plugin
