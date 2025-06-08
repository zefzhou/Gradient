#!/bin/bash

DOCKER_IMG="zefzhou44/gradient"

# 查看 Gradient 日志函数
function view_logs() {
    IP=$1
    CONTAINER_NAME="Gradient-${IP//./-}"

    if docker ps -a --format '{{.Names}}' | grep -Fxq "$CONTAINER_NAME"; then
        echo "================================================================"
        docker logs -n 200 "$CONTAINER_NAME"
    fi
}

view_logs $1
