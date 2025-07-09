FROM ubuntu:25.04

ENV DEBIAN_FRONTEND="noninteractive"
ENV LC_ALL="en_US.UTF-8"
ENV LANG="en_US.UTF-8"
ENV DOCUMENT_ROOT="/var/www/html"
ENV SITE_CONFIG_DIR="/etc/apache2/sites-available"
ENV CERT_DIR="/opt/cert"

ENV PHP_MEMORY_LIMIT="4096M"
ENV PHP_POST_MAX_SIZE="4096M"
ENV PHP_UPLOAD_MAX_FILESIZE="4096M"
ENV LOG_PHP_ERROR="log_errors = On"
ENV PHP_LOG_FILE="error_log = php_errors.log"
ENV PHP_INI="/etc/php/8.4/apache2/php.ini"

# Install basic packages:
RUN apt-get update -y && \
    apt-get upgrade -y && \
    apt-get install -y wget sudo nano curl unzip tzdata locales \
    gpg gnupg2 software-properties-common apt-transport-https lsb-release \
    ca-certificates iputils-ping iproute2 traceroute && \
    apt-get upgrade ca-certificates -y && \
    ln -fs /usr/share/zoneinfo/America/Chicago /etc/localtime && \
    locale-gen en_US.UTF-8 && \
    update-locale LANG=en_US.UTF-8

# Install apache:
RUN apt-get install -y apache2 apache2-utils && \
    rm -rf ${SITE_CONFIG_DIR}/* && \
    mkdir ${CERT_DIR}

# Install php:
RUN apt-get install -y php8.4 php8.4-mysql libapache2-mod-php \
    php8.4-curl php8.4-dom php8.4-imagick php8.4-zip php8.4-gd php8.4-intl

COPY ./entrypoint.sh /usr/bin/entrypoint.sh

RUN chmod +x /usr/bin/entrypoint.sh

EXPOSE 80 443

WORKDIR ${DOCUMENT_ROOT}

ENTRYPOINT ["entrypoint.sh"]

