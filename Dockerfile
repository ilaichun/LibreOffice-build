FROM ubuntu:24.04

# 阿里云源
RUN sed -i 's@//.*archive.ubuntu.com@//mirrors.aliyun.com@g' /etc/apt/sources.list.d/ubuntu.sources && \
    sed -i 's@//security.ubuntu.com@//mirrors.aliyun.com@g' /etc/apt/sources.list.d/ubuntu.sources && \
    sed -i 's@//ports.ubuntu.com@//mirrors.aliyun.com@g' /etc/apt/sources.list.d/ubuntu.sources

ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=zh_CN.UTF-8
ENV LC_ALL=zh_CN.UTF-8

# 安装依赖
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        openjdk-8-jre \
        openjdk-8-jdk \
        wget \
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

    # 字体
    echo "ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true" | debconf-set-selections && \
    apt-get install -y --no-install-recommends \
        ttf-mscorefonts-installer \
        ttf-wqy-microhei \
        ttf-wqy-zenhei && \

    # 清理
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# 刷新字体
RUN fc-cache -fv

WORKDIR /app

# ============================
# 关键修改：自动下载 war 包
# 不需要上传！不需要COPY！
# ============================
RUN wget https://github.com/kekingcn/kkFileView/releases/download/v4.4.0-beta/kkFileView-4.4.0-beta.war -O kkFileView.war

# 真实 LibreOffice 路径
ENV office.home=/usr/lib/libreoffice
ENV KK_OFFICE_HOME=/usr/lib/libreoffice

EXPOSE 8012
CMD ["java", "-jar", "kkFileView.war"]
