#!/bin/bash

DOCKER_IMG="zefzhou44/gradient"

# 查看 Gradient 日志函数
function view_logs() {
    container_id=$(docker ps -q --filter "ancestor=$DOCKER_IMG")
    if [ -z "$container_id" ]; then
        echo "没有找到运行中的 Gradient 容器"
    else
        echo "================================================================"
        docker logs -n 200 "$container_id"
    fi
}

view_logs
