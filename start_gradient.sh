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

# 检查并安装 Docker
function check_install_docker() {
    if ! command -v docker &>/dev/null; then
        echo "Docker 未安装，开始安装..."
        curl -fsSL https://get.docker.com | sh
        if [ $? -ne 0 ]; then
            echo "Docker 安装失败"
            return 1
        fi
        systemctl start docker
        systemctl enable docker
        echo "Docker 安装完成"
    else
        echo "Docker 已安装"
    fi

    if ! command -v docker-compose &>/dev/null; then
        echo "Docker Compose 未安装，开始安装..."
        curl -L "https://github.com/docker/compose/releases/download/v2.24.5/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
        if [ $? -ne 0 ]; then
            echo "Docker Compose 安装失败"
            return 1
        fi
        chmod +x /usr/local/bin/docker-compose
        echo "Docker Compose 安装完成"
    else
        echo "Docker Compose 已安装"
    fi
    return 0
}

# 启动 Gradient 函数
function start_gradient() {
    # 首先检查并安装 Docker
    if check_install_docker; then
        echo "Docker 和 Docker Compose 安装或已存在，继续执行..."
        echo "Current directory: $(pwd)"
        echo "Make sure you have config.txt !!!"

        # 停止已存在的容器
        existing_container=$(docker ps -q --filter "ancestor=$DOCKER_IMG")
        if [ ! -z "$existing_container" ]; then
            echo "停止已存在的容器..."
            docker stop "$existing_container"
        fi

        # 运行新容器
        echo -e "\n开始运行 Docker 容器..."
        CONFIG_FILE="$(pwd)/config.txt"
        docker run -d \
            -v "$CONFIG_FILE:/app/config.txt" \
            $DOCKER_IMG

        if [ $? -eq 0 ]; then
            echo "Docker 容器已成功启动！"
            echo "当前运行的容器："
            docker ps | grep gradient
        else
            echo "Docker 容器启动失败，请检查错误信息"
        fi
    else
        echo "Docker 或 Docker Compose 安装失败，请手动安装后重试。"
        return 1
    fi
}

start_gradient
