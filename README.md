[![docker version semver](https://img.shields.io/docker/v/sinlov/docker-pnpm?sort=semver)](https://hub.docker.com/r/sinlov/docker-pnpm)
[![docker image size](https://img.shields.io/docker/image-size/sinlov/docker-pnpm)](https://hub.docker.com/r/sinlov/docker-pnpm)
[![docker pulls](https://img.shields.io/docker/pulls/sinlov/docker-pnpm)](https://hub.docker.com/r/sinlov/docker-pnpm/tags?page=1&ordering=last_updated)

# docker-pnpm

- docker hub see [https://hub.docker.com/r/sinlov/docker-pnpm](https://hub.docker.com/r/sinlov/docker-pnpm)

## for

- alpine basic build image

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