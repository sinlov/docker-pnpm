# This dockerfile uses extends image https://hub.docker.com/_/node
# VERSION 1
# Author: sinlov
# dockerfile offical document https://docs.docker.com/engine/reference/builder/
# maintainer="https://github.com/sinlov/docker-pnpm"

# https://hub.docker.com/_/node
FROM node:20.5.1

#USER root

ARG PNPM_VERSION=8.7.0

ARG PNPM_HOME=/root/.local/share/pnpm
ENV PNPM_HOME=${PNPM_HOME}

RUN npm --registry https://registry.npmmirror.com \
  install -g pnpm@${PNPM_VERSION} && \
  rm -rf $(npm config get cache) && \
  mkdir -p ${PNPM_HOME}/store

# ENTRYPOINT ["pnpm"]