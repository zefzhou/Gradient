#!/bin/bash

DOCKER_IMG="zefzhou44/gradient"

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
    CONFIG_FILE_NAME=$1                                # ip .隔开
    CONTAINER_NAME="Gradient-${CONFIG_FILE_NAME//./-}" # - 隔开

    # 首先检查并安装 Docker
    if check_install_docker; then
        echo "Docker 和 Docker Compose 安装或已存在，继续执行..."
        echo "Current directory: $(pwd)"
        echo "Make sure you have config.txt !!!"

        # 强制删除容器
        if docker ps -a --format '{{.Names}}' | grep -Fxq "$CONTAINER_NAME"; then
            echo "删除 $CONTAINER_NAME 容器..."
            docker rm -f "$CONTAINER_NAME"
            if [ $? -eq 0 ]; then
                echo "$CONTAINER_NAME 容器删除成功"
            else
                echo "$CONTAINER_NAME 容器删除失败"
            fi
        else
            echo "$CONTAINER_NAME 容器不存在, 不需要删除"
        fi

        # 运行新容器
        echo -e "\n开始运行 Docker 容器..."
        CONFIG_FILE="$(pwd)/${CONFIG_FILE_NAME}.txt"
        docker run -d \
            --name "$CONTAINER_NAME" \
            -v "$CONFIG_FILE:/app/config.txt" \
            $DOCKER_IMG

        if [ $? -eq 0 ]; then
            echo "$CONTAINER_NAME 容器已成功启动！"
            echo "当前运行的容器："
            docker ps | grep gradient
        else
            echo "$CONTAINER_NAME 容器启动失败，请检查错误信息"
        fi
    else
        echo "Docker 或 Docker Compose 安装失败，请手动安装后重试。"
        return 1
    fi
}

start_gradient
