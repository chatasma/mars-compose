# utils
container_exists () {
    if [ "$(docker ps -aq -f name=^${1}$)" ]; then
        echo 1
    else
        echo 0
    fi
}

container_is_running () {
    if [ ! "$(docker ps -a | grep $1)" ]; then
        echo 0
        return
    fi
    if [ "$( docker container inspect -f '{{.State.Running}}' $1 )" == "true" ]; then
        echo 1
    else
        echo 0
    fi
}

kill_mcserver () {
    # send stop to the MC server
    mcsrv_container="mcsrv"
    if [ $(container_is_running "${mcsrv_container}") -eq 1 ]; then
        echo "stop" | socat EXEC:"docker attach ${mcsrv_container}",pty STDIN
        sleep 5 &
        sleeper=$!
        docker wait ${mcsrv_container} &
        waiter=$!
        wait -n ${sleeper} ${waiter}
        # if it didnt exit kill it
        if [ $(container_is_running "${mcsrv_container}") -eq 1 ]; then
            docker kill ${mcsrv_container}
        fi
    fi
}

compile_plugin () {
    # Make mount dir
    if [ ! -d "mars" ]; then
        mkdir mars
    fi
    docker-compose up mars_compile -d
    docker exec mars_compile './compile_mars.sh'
}
