#!/bin/bash

DOCKER_IMG="zefzhou44/gradient"

# 删除 Gradient 容器函数
function delete_gradient() {
    container_id=$(docker ps -q --filter "ancestor=$DOCKER_IMG")
    if [ -z "$container_id" ]; then
        echo "没有找到运行中的 Gradient 容器"
    else
        echo "删除 Gradient 容器..."
        docker rm -f "$container_id"
        if [ $? -eq 0 ]; then
            echo "Gradient 容器已成功删除"
        else
            echo "删除容器失败"
        fi
    fi
}

delete_gradient
