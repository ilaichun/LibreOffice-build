# ARM64 官方基础镜像
FROM arm64v8/debian:bookworm-slim

# 关闭交互式安装
ENV DEBIAN_FRONTEND=noninteractive

# 安装 LibreOffice 7.5（不锁死精确版本，确保源一定能找到）
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        libreoffice \
        libreoffice-writer \
        libreoffice-calc \
        libreoffice-impress && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# 默认命令
CMD ["libreoffice"]
