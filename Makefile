VERSION?=dev-master
HTTP_VERSION?=dev-master
TAG?=latest

# example:
# $ make VERSION=dev-master TAG=latest nginx
# $ make TAG=latest push-all

.PHONY: default nginx ppm standalone push-all

default: nginx ppm standalone

nginx:
	docker build -t nevrending/phppm:nginx-${TAG} -f build/Dockerfile-nginx build/ --build-arg version=${VERSION} --build-arg http_version=${HTTP_VERSION}
	docker tag nevrending/phppm:nginx-${TAG} nevrending/phppm:nginx-latest

ppm:
	docker build -t nevrending/phppm:ppm-${TAG} -f build/Dockerfile-ppm build/ --build-arg version=${VERSION} --build-arg http_version=${HTTP_VERSION}
	docker tag nevrending/phppm:ppm-${TAG} nevrending/phppm:ppm-latest

standalone:
	docker build -t nevrending/phppm:standalone-${TAG} -f build/Dockerfile-standalone build/ --build-arg version=${VERSION} --build-arg http_version=${HTTP_VERSION}
	docker tag nevrending/phppm:standalone-${TAG} nevrending/phppm:standalone-latest

push-all:
	docker push nevrending/phppm:nginx-${TAG}
	docker push nevrending/phppm:standalone-${TAG}
	docker push nevrending/phppm:ppm-${TAG}
