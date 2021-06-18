![GitHub Workflow Status](https://img.shields.io/github/workflow/status/nevrending/php-pm-docker/Publish%20Docker%20image?style=flat-square)
![Docker Version](https://img.shields.io/docker/v/nevrending/phppm?style=flat-square&sort=semver)
![Docker Pulls](https://img.shields.io/docker/pulls/nevrending/phppm?style=flat-square)
![Docker Image Size (latest by date)](https://img.shields.io/docker/image-size/nevrending/phppm?style=flat-square&sort=date)

# NevREnding's Fork of PHP-PM Docker

## Noteable Changes and Differences

- [x] Built with the latest [PHP-PM](https://github.com/php-pm/php-pm) and [HttpKernel](https://github.com/php-pm/php-pm-httpkernel).
- [x] Base image is Alpine 3.13.
- [x] New `Laravel` tag/image flavour.
- [x] Optimized NGiNX configurations.
- [ ] Optimized PHP configurations.

# PHP-PM Docker

You can use [PHP-PM](https://github.com/php-pm/php-pm) using Docker. We provide you several images always with PHP-PM and PHP7 pre-installed.

## Images

- [`nevrending/phppm:laravel`](https://hub.docker.com/layers/nevrending/phppm/laravel-latest): Contains php-pm, composer, and uses NGiNX as static file serving. Only PHP extensions that Laravel requires are installed (recommended)
- [`nevrending/phppm:nginx`](https://hub.docker.com/layers/nevrending/phppm/nginx-latest): Contains php-pm and uses NGiNX as static file serving (recommended)
- [`nevrending/phppm:standalone`](https://hub.docker.com/r/nevrending/phppm:standalone-latest): Contains php-pm and uses php-pm's ability to serve static files (slower)
- [`nevrending/phppm:ppm`](https://hub.docker.com/r/nevrending/phppm:ppm-latest): Just the php-pm binary as entry point

### Examples

```sh
# change into your project folder first
cd your/symfony-project/

# see what php-pm binary can do for you.
$ docker run -v `pwd`:/var/www/ nevrending/phppm:ppm-latest --help
$ docker run -v `pwd`:/var/www/ nevrending/phppm:ppm-latest config --help

# with nginx as static file server
$ docker run -v `pwd`:/var/www -p 8080:80 nevrending/phppm:nginx-latest

# with php-pm as static file server (dev only)
$ docker run -v `pwd`:/var/www -p 8080:80 nevrending/phppm:standalone-latest

# use `PPM_CONFIG` environment variable to choose a different PPM config file.
$ docker run  -v `pwd`:/var/www -p 80:80 nevrending/phppm:nginx-latest -c ppm-prod.json

# enable file tracking, to automatically restart PPM when PHP source changed
$ docker run -v `pwd`:/var/www -p 80:80 nevrending/phppm:nginx-latest --debug=1 --app-env=dev

# change static file directory. PPM_STATIC relative to mounted /var/www/.
$ docker run -v `pwd`:/var/www -p 80:80 nevrending/phppm:nginx-latest --static-directory=web/

# Use 16 threads/workers for PHP-PM.
$ docker run -v `pwd`:/var/www -p 80:80 nevrending/phppm:nginx-latest --workers=16
```

###  Docker Compose

```yaml
version: "3.1"

services:
  ppm:
    image: nevrending/phppm:nginx-latest
    command: --debug=1 --app-env=dev --static-directory=web/
    volumes:
      - ./symfony-app/:/var/www
    ports:
      - "80:80"
```

### Configurations

You can configure PPM via the `ppm.json` file in the root directory, which is within the container mounted to
`/var/www/`. Alternatively, you can overwrite each option using the regular CLI arguments.

```sh
# change the ppm.json within current directory
docker run -v `pwd`:/var/www nevrending/phppm:ppm-latest config --help

# not persisting config changes
docker run -v `pwd`:/var/www -p 80:80 nevrending/phppm:nginx-latest --help
docker run -v `pwd`:/var/www -p 80:80 nevrending/phppm:nginx-latest --workers=1 --debug 1
docker run -v `pwd`:/var/www -p 80:80 nevrending/phppm:nginx-latest --c prod-ppm.json
```

## Build Image With Your Own Tools/Dependencies

If your application requires additional PHP modules or other tools and libraries in your container, you
can use our image as base. We use lightweight Alpine Linux.

```Dockerfile
FROM nevrending/phppm:nginx-latest

RUN apk --no-cache add git
RUN apk --no-cache add ca-certificates wget

# whatever you need
```

```sh
docker build -f Dockerfile -t my-repo/my-image .
```

## Bulding With Make

```sh
$ make VERSION=dev-master HTTP_VERSION=dev-master TAG=latest nginx
$ make TAG=latest push-all
```

Recommendations:
- `VERSION=2.2.2`
- `HTTP_VERSION=2.0.6`

## License

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow?style=flat-square)](https://github.com/nevrending/php-pm-docker/blob/master/LICENSE)
