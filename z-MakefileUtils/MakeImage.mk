# this file must use as base Makefile
# need var:
# ROOT_NAME is this project name
# ROOT_OWNER is this project owner
# INFO_BUILD_DOCKER_FROM_IMAGE for image running
# INFO_TEST_BUILD_DOCKER_PARENT_IMAGE for image local build
# INFO_BUILD_DOCKER_FILE for build docker image default Dockerfile
# INFO_TEST_BUILD_DOCKER_FILE for local build docker image file
# INFO_TEST_BUILD_DOCKER_PARENT_IMAGE for local build
# INFO_TEST_BUILD_DOCKER_CONTAINER_ARGS is args at build
# ROOT_PARENT_SWITCH_TAG is change parent image tag

ENV_INFO_BUILD_DOCKER_TAG =${ENV_DIST_VERSION}
ENV_INFO_DOCKER_REPOSITORY =${ROOT_NAME}
ENV_INFO_DOCKER_OWNER =${ROOT_OWNER}
# if set ENV_INFO_PRIVATE_DOCKER_REGISTRY= will push to hub.docker.com
# private docker registry use harbor must create project name as ${ENV_INFO_DOCKER_OWNER}
#ENV_INFO_PRIVATE_DOCKER_REGISTRY=harbor.xxx.com/
ENV_INFO_PRIVATE_DOCKER_REGISTRY =
ENV_INFO_BUILD_DOCKER_SOURCE_IMAGE ?=${ENV_INFO_DOCKER_OWNER}/${ENV_INFO_DOCKER_REPOSITORY}
ENV_INFO_BUILD_DOCKER_FILE =${INFO_BUILD_DOCKER_FILE}

ENV_INFO_TEST_BUILD_DOCKER_FILE =${INFO_TEST_BUILD_DOCKER_FILE}
ENV_INFO_TEST_BUILD_DOCKER_PARENT_IMAGE =${INFO_TEST_BUILD_DOCKER_PARENT_IMAGE}:${ROOT_PARENT_SWITCH_TAG}
ENV_INFO_TEST_BUILD_DOCKER_PARENT_CONTAINER =test-parent-${ENV_INFO_DOCKER_REPOSITORY}
ENV_INFO_TEST_TAG_BUILD_DOCKER_CONTAINER_NAME =test-${ENV_INFO_DOCKER_REPOSITORY}
ENV_INFO_TEST_BUILD_DOCKER_CONTAINER_ARGS =${INFO_TEST_BUILD_DOCKER_CONTAINER_ARGS}
ENV_INFO_TEST_BUILD_DOCKER_CONTAINER_ENTRYPOINT =/bin/bash

dockerEnv:
	@echo "== docker env print start"
	@echo "ENV_INFO_DOCKER_REPOSITORY                     ${ENV_INFO_DOCKER_REPOSITORY}"
	@echo "ENV_INFO_DOCKER_OWNER                          ${ENV_INFO_DOCKER_OWNER}"
	@echo "ENV_INFO_BUILD_DOCKER_SOURCE_IMAGE             ${ENV_INFO_BUILD_DOCKER_SOURCE_IMAGE}"
	@echo "ENV_INFO_BUILD_DOCKER_TAG                      ${ENV_INFO_BUILD_DOCKER_TAG}"
	@echo "ENV_INFO_BUILD_DOCKER_FILE                     ${ENV_INFO_BUILD_DOCKER_FILE}"
	@echo "ENV_INFO_PRIVATE_DOCKER_REGISTRY               ${ENV_INFO_PRIVATE_DOCKER_REGISTRY}"
	@echo "REGISTRY tag as:                               ${ENV_INFO_PRIVATE_DOCKER_REGISTRY}${ENV_INFO_BUILD_DOCKER_SOURCE_IMAGE}:${ENV_INFO_BUILD_DOCKER_TAG}"
	@echo ""
	@echo "ENV_INFO_TEST_BUILD_DOCKER_PARENT_IMAGE        ${ENV_INFO_TEST_BUILD_DOCKER_PARENT_IMAGE}"
	@echo "ENV_INFO_TEST_BUILD_DOCKER_PARENT_CONTAINER    ${ENV_INFO_TEST_BUILD_DOCKER_PARENT_CONTAINER}"
	@echo ""
	@echo "ENV_INFO_TEST_TAG_BUILD_DOCKER_CONTAINER_NAME  ${ENV_INFO_TEST_TAG_BUILD_DOCKER_CONTAINER_NAME}"
	@echo "ENV_INFO_TEST_BUILD_DOCKER_FILE                ${ENV_INFO_TEST_BUILD_DOCKER_FILE}"
	@echo ""
	@echo "== docker env print end"

dockerAllPull:
	docker pull ${ENV_INFO_TEST_BUILD_DOCKER_PARENT_IMAGE}

dockerCleanImages:
	(while :; do echo 'y'; sleep 3; done) | docker image prune

dockerCleanPruneAll:
	(while :; do echo 'y'; sleep 3; done) | docker container prune
	(while :; do echo 'y'; sleep 3; done) | docker image prune

dockerRunContainerParentBuild:
	@echo "run rm container image: ${ENV_INFO_TEST_BUILD_DOCKER_PARENT_IMAGE}"
	$(info docker run -d --rm --name ${ENV_INFO_TEST_BUILD_DOCKER_PARENT_CONTAINER} ${ENV_INFO_TEST_BUILD_DOCKER_PARENT_IMAGE})
	docker run -d --rm --name ${ENV_INFO_TEST_BUILD_DOCKER_PARENT_CONTAINER} ${ENV_INFO_TEST_BUILD_DOCKER_PARENT_IMAGE} tail -f /dev/null
	@echo ""
	@echo "-> run rm container name: ${ENV_INFO_TEST_BUILD_DOCKER_PARENT_CONTAINER}"
	@echo "-> into container use: docker exec -it ${ENV_INFO_TEST_BUILD_DOCKER_PARENT_CONTAINER} bash"

dockerRmContainerParentBuild:
	-docker rm -f ${ENV_INFO_TEST_BUILD_DOCKER_PARENT_CONTAINER}

dockerPruneContainerParentBuild: dockerRmContainerParentBuild
	-docker rmi -f ${ENV_INFO_TEST_BUILD_DOCKER_PARENT_IMAGE}

# set export DOCKER_SCAN_SUGGEST=false to fix
# Use 'docker scan' to run Snyk tests against images to find vulnerabilities and learn how to fix them
dockerTestBuildLatest: export DOCKER_SCAN_SUGGEST=false
dockerTestBuildLatest:
	docker build --rm=true --tag ${ENV_INFO_BUILD_DOCKER_SOURCE_IMAGE}:${ENV_INFO_BUILD_DOCKER_TAG} --file ${ENV_INFO_TEST_BUILD_DOCKER_FILE} .

dockerTestRunLatest:
	docker image inspect --format='{{ .Created}}' ${ENV_INFO_BUILD_DOCKER_SOURCE_IMAGE}:${ENV_INFO_BUILD_DOCKER_TAG}
	$(warning you can change test docker run args at here for dev)
	-docker run --rm --name ${ENV_INFO_TEST_TAG_BUILD_DOCKER_CONTAINER_NAME} \
	-e RUN_MODE=dev \
	${ENV_INFO_BUILD_DOCKER_SOURCE_IMAGE}:${ENV_INFO_BUILD_DOCKER_TAG} \
	${ENV_INFO_TEST_BUILD_DOCKER_CONTAINER_ARGS}
	$(info for inner check can use like this)
	$(info docker run --rm -it --entrypoint ${ENV_INFO_TEST_BUILD_DOCKER_CONTAINER_ENTRYPOINT} --name ${ENV_INFO_TEST_TAG_BUILD_DOCKER_CONTAINER_NAME} ${ENV_INFO_BUILD_DOCKER_SOURCE_IMAGE}:${ENV_INFO_BUILD_DOCKER_TAG})
	-docker inspect --format='{{ .State.Status}}' ${ENV_INFO_TEST_TAG_BUILD_DOCKER_CONTAINER_NAME}

dockerTestLogLatest:
	-docker logs ${ENV_INFO_TEST_TAG_BUILD_DOCKER_CONTAINER_NAME}

dockerTestRmLatest:
	-docker rm -f ${ENV_INFO_TEST_TAG_BUILD_DOCKER_CONTAINER_NAME}

dockerTestRmiLatest:
	-docker rmi -f ${ENV_INFO_BUILD_DOCKER_SOURCE_IMAGE}:${ENV_INFO_BUILD_DOCKER_TAG}

dockerTestRestartLatest: dockerTestRmLatest dockerTestRmiLatest dockerTestBuildLatest dockerTestRunLatest
	@echo "restart ${ENV_INFO_TEST_TAG_BUILD_DOCKER_CONTAINER_NAME} ${ENV_INFO_BUILD_DOCKER_SOURCE_IMAGE}:${ENV_INFO_BUILD_DOCKER_TAG}"

dockerTestStopLatest: dockerTestRmLatest dockerTestRmiLatest
	@echo "stop and remove ${ENV_INFO_TEST_TAG_BUILD_DOCKER_CONTAINER_NAME} ${ENV_INFO_BUILD_DOCKER_SOURCE_IMAGE}:${ENV_INFO_BUILD_DOCKER_TAG}"

dockerTestPruneLatest: dockerTestStopLatest
	@echo "prune and remove ${ENV_INFO_BUILD_DOCKER_SOURCE_IMAGE}:${ENV_INFO_BUILD_DOCKER_TAG}"

dockerRmiBuild:
	-docker rmi -f ${ENV_INFO_BUILD_DOCKER_SOURCE_IMAGE}:${ENV_INFO_BUILD_DOCKER_TAG}
	-docker rmi -f ${ENV_INFO_PRIVATE_DOCKER_REGISTRY}${ENV_INFO_BUILD_DOCKER_SOURCE_IMAGE}:${ENV_INFO_BUILD_DOCKER_TAG}

dockerBuild:
	docker build --rm=true --tag ${ENV_INFO_BUILD_DOCKER_SOURCE_IMAGE}:${ENV_INFO_BUILD_DOCKER_TAG} --file ${ENV_INFO_BUILD_DOCKER_FILE} .

dockerTag:
	docker tag ${ENV_INFO_BUILD_DOCKER_SOURCE_IMAGE}:${ENV_INFO_BUILD_DOCKER_TAG} ${ENV_INFO_PRIVATE_DOCKER_REGISTRY}${ENV_INFO_BUILD_DOCKER_SOURCE_IMAGE}

dockerBeforePush: dockerRmiBuild dockerBuild dockerTag
	@echo "===== then now can push to ${ENV_INFO_PRIVATE_DOCKER_REGISTRY}"

dockerPushBuild: dockerBeforePush
	docker push ${ENV_INFO_PRIVATE_DOCKER_REGISTRY}${ENV_INFO_BUILD_DOCKER_SOURCE_IMAGE}:${ENV_INFO_BUILD_DOCKER_TAG}
	@echo "=> push ${ENV_INFO_PRIVATE_DOCKER_REGISTRY}${ENV_INFO_BUILD_DOCKER_SOURCE_IMAGE}:${ENV_INFO_BUILD_DOCKER_TAG}"

helpDocker:
	@echo "=== this make file can include MakeImage.mk then use"
	@echo "- must has file: [ ${ENV_INFO_BUILD_DOCKER_FILE} ${ENV_INFO_TEST_BUILD_DOCKER_FILE}" ]
	@echo "- then change tag as:                       ENV_DIST_VERSION"
	@echo "- then change repository as:                ROOT_NAME"
	@echo "- then change owner as:                     ROOT_OWNER"
	@echo "- then change private docker repository as: ENV_INFO_PRIVATE_DOCKER_REGISTRY"
	@echo "- then change build parent image as:        INFO_TEST_BUILD_DOCKER_PARENT_IMAGE"
	@echo "- then change build parent image tag as:    ROOT_PARENT_SWITCH_TAG"
	@echo "- check by task"
	@echo "$$ make dockerEnv"
	@echo ""
	@echo "- first use can pull images"
	@echo "$$ make dockerAllPull"
	@echo ""
	@echo "- then use to show how to build docker parent image"
	@echo "$$ make dockerRunContainerParentBuild"
	@echo "- and prune resource at parent image"
	@echo "$$ make dockerPruneContainerParentBuild"
	@echo ""
	@echo "- test run container use ./${ENV_INFO_TEST_BUILD_DOCKER_FILE}"
	@echo "$$ make dockerTestRestartLatest"
	@echo "- prune test container and image"
	@echo "$$ make dockerTestPruneLatest"
	@echo ""
	@echo "- build and tag as use ./${ENV_INFO_BUILD_DOCKER_FILE}"
	@echo "$$ make dockerBeforePush"
	@echo "- prune build"
	@echo "$$ make dockerRmiBuild"
	@echo "- then final push use"
	@echo "$$ make dockerPushBuild"
	@echo ""