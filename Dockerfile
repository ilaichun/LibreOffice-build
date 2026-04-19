# 最小基础镜像
FROM debian:bookworm-slim

# 安装 LibreOffice 7.5 固定版本
RUN apt-get update && \
    # 精确安装 7.5 版本
    apt-get install -y --no-install-recommends \
        libreoffice=1:7.5.9-1~deb12u1 \
        libreoffice-base=1:7.5.9-1~deb12u1 \
        libreoffice-calc=1:7.5.9-1~deb12u1 \
        libreoffice-impress=1:7.5.9-1~deb12u1 \
        libreoffice-writer=1:7.5.9-1~deb12u1 && \
    # 清理缓存，减小体积
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# 默认启动命令
CMD ["libreoffice"]
