#!/bin/bash

DOCKER_IMG="zefzhou44/gradient"

# 删除 Gradient 容器函数
function delete_gradient() {
    IP=$1
    CONTAINER_NAME="Gradient-${IP//./-}"

    if docker ps -a --format '{{.Names}}' | grep -Fxq "$CONTAINER_NAME"; then
        echo "删除 $CONTAINER_NAME 容器..."
        docker rm -f "$CONTAINER_NAME"
        if [ $? -eq 0 ]; then
            echo "$CONTAINER_NAME 容器删除成功"
        else
            echo "$CONTAINER_NAME 容器删除失败"
        fi
    else
        echo "$CONTAINER_NAME 容器不存在,不需要删除"
    fi
}

delete_gradient
