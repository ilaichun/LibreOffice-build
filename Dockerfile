FROM ubuntu:24.04

# 阿里云源
RUN sed -i 's@//.*archive.ubuntu.com@//mirrors.aliyun.com@g' /etc/apt/sources.list.d/ubuntu.sources && \
    sed -i 's@//security.ubuntu.com@//mirrors.aliyun.com@g' /etc/apt/sources.list.d/ubuntu.sources && \
    sed -i 's@//ports.ubuntu.com@//mirrors.aliyun.com@g' /etc/apt/sources.list.d/ubuntu.sources

ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=zh_CN.UTF-8
ENV LC_ALL=zh_CN.UTF-8

# 安装全部依赖 + 中文字体 + LibreOffice + JDK（kkFileView 需要）
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        openjdk-8-jre \
        openjdk-8-jdk \
        tzdata \
        locales \
        xfonts-utils \
        fontconfig \
        libreoffice-nogui \
        debconf-utils && \

    # 中文环境
    echo 'Asia/Shanghai' > /etc/timezone && \
    ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    localedef -i zh_CN -c -f UTF-8 -A /usr/share/locale/locale.alias zh_CN.UTF-8 && \
    locale-gen zh_CN.UTF-8 && \

    # 自动接受微软字体协议
    echo "ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true" | debconf-set-selections && \

    # 安装系统自带中文（足够用，不会乱码）
    apt-get install -y --no-install-recommends \
        ttf-mscorefonts-installer \
        ttf-wqy-microhei \
        ttf-wqy-zenhei \
        fonts-wqy-zenhei \
        fonts-wqy-microhei \
        fonts-arphic-ukai \
        fonts-arphic-uming && \

    # 清理
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# 刷新系统字体
RUN fc-cache -fv

# ============================
# kkFileView 集成（关键部分）
# ============================
WORKDIR /app

# 复制 kkFileView WAR 包
COPY kkFileView.war /app/kkFileView.war

# 配置 LibreOffice 真实路径（不是假目录！）
ENV office.home=/usr/lib/libreoffice
ENV KK_OFFICE_HOME=/usr/lib/libreoffice

# 暴露端口
EXPOSE 8012

# 启动 kkFileView
CMD ["java", "-jar", "kkFileView.war"]
