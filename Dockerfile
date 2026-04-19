# 替换为公开的 JDK8 + Tomcat8 基础镜像
FROM tomcat:8.5-jdk8-corretto
LABEL maintainer="keking <keking@kkview.cn>"

# 安装依赖 + 安装稳定兼容版 LibreOffice 7.5
RUN sed -i 's@//.*archive.ubuntu.com@//mirrors.aliyun.com@g' /etc/apt/sources.list && \
    sed -i 's@//security.ubuntu.com@//mirrors.aliyun.com@g' /etc/apt/sources.list && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        software-properties-common && \
    add-apt-repository ppa:libreoffice/libreoffice-7-5 -y && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        libreoffice \
        libreoffice-writer \
        libreoffice-calc \
        libreoffice-impress \
        libreoffice-draw \
        libreoffice-headless \
        fonts-wqy-zenhei \
        fonts-wqy-microhei \
        fontconfig \
    && rm -rf /var/lib/apt/lists/*

# 部署 kkFileView
RUN rm -rf /usr/local/tomcat/webapps/ROOT
COPY target/FileServer.war /usr/local/tomcat/webapps/ROOT.war

# 启动 Tomcat
CMD ["catalina.sh", "run"]
