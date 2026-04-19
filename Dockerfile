# ARM64 官方基础镜像
FROM arm64v8/debian:bookworm-slim

# 关闭交互式安装
ENV DEBIAN_FRONTEND=noninteractive

# --------------------------
# 1. 安装 Locale 并配置中文编码
# --------------------------
ENV LANG=zh_CN.UTF-8
ENV LANGUAGE=zh_CN:zh
ENV LC_ALL=zh_CN.UTF-8

RUN apt-get update && \
    apt-get install -y --no-install-recommends locales && \
    sed -i 's/^# zh_CN.UTF-8 UTF-8/zh_CN.UTF-8 UTF-8/' /etc/locale.gen && \
    locale-gen zh_CN.UTF-8 && \
    update-locale LANG=zh_CN.UTF-8 LC_ALL=zh_CN.UTF-8

# --------------------------
# 2. 安装 LibreOffice + 中文语言包 + 中文字体
# --------------------------
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        libreoffice \
        libreoffice-writer \
        libreoffice-calc \
        libreoffice-impress \
        libreoffice-l10n-zh-cn \
        # 关键：安装中文字体（文泉驿系列，开源且兼容）
        fonts-wqy-microhei \
        fonts-wqy-zenhei && \
    # 更新字体缓存
    fc-cache -fv && \
    # 清理缓存，减小镜像体积
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# 默认命令（保持不变）
CMD ["libreoffice"]
