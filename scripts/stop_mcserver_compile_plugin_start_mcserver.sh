source ./scripts/common_utils.sh
export UID_GID="$(id -u):$(id -g)"

kill_mcserver
compile_plugin
docker-compose up mcsrv -d
docker logs mcsrv -f
