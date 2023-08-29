[![ci](https://github.com/sinlov/docker-pnpm/actions/workflows/ci.yml/badge.svg)](https://github.com/sinlov/docker-pnpm/actions/workflows/ci.yml)

[![GitHub license](https://img.shields.io/github/license/sinlov/docker-pnpm)](https://github.com/sinlov/docker-pnpm)
[![GitHub latest SemVer tag)](https://img.shields.io/github/v/tag/sinlov/docker-pnpm)](https://github.com/sinlov/docker-pnpm/tags)
[![GitHub release)](https://img.shields.io/github/v/release/sinlov/docker-pnpm)](https://github.com/sinlov/docker-pnpm/releases)

[![docker version semver](https://img.shields.io/docker/v/sinlov/docker-pnpm?sort=semver)](https://hub.docker.com/r/sinlov/docker-pnpm)
[![docker image size](https://img.shields.io/docker/image-size/sinlov/docker-pnpm)](https://hub.docker.com/r/sinlov/docker-pnpm)
[![docker pulls](https://img.shields.io/docker/pulls/sinlov/docker-pnpm)](https://hub.docker.com/r/sinlov/docker-pnpm/tags?page=1&ordering=last_updated)

# docker-pnpm

- docker hub see [https://hub.docker.com/r/sinlov/docker-pnpm](https://hub.docker.com/r/sinlov/docker-pnpm)

## for

- [![](https://img.shields.io/docker/v/_/node/bookworm?label=node&logo=node&style=social)](https://hub.docker.com/_/node/tags?page=1&name=bookworm) latest semver version
- node build image with pnpm, start maintain version `node:20.5.1`
  - has install [pnpm](https://pnpm.io/)

### fast use

```bash
docker run --rm -it \
  --entrypoint /bin/bash \
  --name "test-docker-pnpm" \
  sinlov/docker-pnpm:latest

# then can use
pnpm --version
```

## source repo

[https://github.com/sinlov/docker-pnpm](https://github.com/sinlov/docker-pnpm)

## source usage

### dev mode

```bash
# check env
make dockerEnv

# change build.dockerfile
# then test image
make dockerTestRestartLatest
# remove test image
make clean
```

then change github workflows config to use

## Contributing

[![Contributor Covenant](https://img.shields.io/badge/contributor%20covenant-v1.4-ff69b4.svg)](.github/CONTRIBUTING_DOC/CODE_OF_CONDUCT.md)
[![GitHub contributors](https://img.shields.io/github/contributors/sinlov/docker-pnpm)](https://github.com/sinlov/docker-pnpm/graphs/contributors)

We welcome community contributions to this project.

Please read [Contributor Guide](.github/CONTRIBUTING_DOC/CONTRIBUTING.md) for more information on how to get started.

请阅读有关 [贡献者指南](.github/CONTRIBUTING_DOC/zh-CN/CONTRIBUTING.md) 以获取更多如何入门的信息