VERSION?=dev-master
HTTP_VERSION?=dev-master
TAG?=latest

.PHONY: default standalone ppm nginx laravel push-all

default: standalone ppm nginx laravel

standalone:
	docker build -t nevrending/phppm:standalone-${TAG} -f build/Dockerfile-standalone build/ --build-arg version=${VERSION} --build-arg http_version=${HTTP_VERSION}
	docker tag nevrending/phppm:standalone-${TAG} nevrending/phppm:standalone-latest

ppm:
	docker build -t nevrending/phppm:ppm-${TAG} -f build/Dockerfile-ppm build/ --build-arg version=${VERSION} --build-arg http_version=${HTTP_VERSION}
	docker tag nevrending/phppm:ppm-${TAG} nevrending/phppm:ppm-latest

nginx:
	docker build -t nevrending/phppm:nginx-${TAG} -f build/Dockerfile-nginx build/ --build-arg version=${VERSION} --build-arg http_version=${HTTP_VERSION}
	docker tag nevrending/phppm:nginx-${TAG} nevrending/phppm:nginx-latest

laravel:
	docker build -t nevrending/phppm:laravel-${TAG} -f build/laravel.Dockerfile build/ --build-arg version=${VERSION} --build-arg http_version=${HTTP_VERSION}
	docker tag nevrending/phppm:laravel-${TAG} nevrending/phppm:laravel-latest

push-all:
	docker push nevrending/phppm:standalone-${TAG}
	docker push nevrending/phppm:ppm-${TAG}
	docker push nevrending/phppm:nginx-${TAG}
	docker push nevrending/phppm:laravel-${TAG}
