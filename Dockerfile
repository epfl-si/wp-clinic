# Use:
#     docker build -t epfl-si/clinic .
#     docker run --entrypoint=/bin/bash -it --rm epfl-si/clinic

################################################################################
ARG WP_PHP_IMAGE_VERSION=2026-165
FROM quay-its.epfl.ch/svc0041/wp-php:${WP_PHP_IMAGE_VERSION} AS base

# Install some conveniance tools
RUN set -e -x; \
    apt-get update; \
    apt-get install -y --no-install-recommends --no-install-suggests \
        bash \
        ca-certificates \
        curl \
        dnsutils \
        file \
        git \
        htop \
        iputils-ping \
        jq \
        less \
        libjudydebian1 \
        lsof \
        tcpdump \
        traceroute \
        vim \
        wget; \
    rm -rf /var/lib/apt/lists/*

# Chmod the WordPress volume
RUN chmod a+rwX -R /wp

# Change the destination of the debug log to /wp/_debug-clinic.log
# in "our" nginx-entrypoint.php
# RUN sed -i "s|.*'WP_DEBUG_LOG'.*|    define( 'WP_DEBUG_LOG', '/wp/_debug-clinic.log' );|" /wp/nginx-entrypoint/nginx-entrypoint.php

################################################################################
FROM base AS build
RUN set -e -x; \
    apt-get update; \
    apt-get install -y --no-install-recommends --no-install-suggests \
        bison \
        build-essential \
        libjudy-dev \
        php-dev \
        re2c; \
    rm -rf /var/lib/apt/lists/*

# Install PIE (PHP Installer for Extensions)
RUN curl -sfL --output /usr/local/bin/pie https://github.com/php/pie/releases/latest/download/pie.phar \
 && chmod +x /usr/local/bin/pie
# Install a memory profiler
RUN pie install arnaud-lb/memprof

################################################################################
FROM base
ARG WP_PHP_VERSION=8.4
ENV MEMPROF_PROFILE=dump_on_limit
COPY --from=build /usr/lib/php/20240924/memprof.so \
                  /usr/lib/php/20240924/memprof.so
COPY --from=build /etc/php/${WP_PHP_VERSION}/mods-available/memprof.ini \
                  /etc/php/${WP_PHP_VERSION}/mods-available/memprof.ini
RUN phpenmod memprof
