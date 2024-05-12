#!/bin/bash

# Check for and source local project configuration if it exists
if [ -f ".weconfig" ]; then
    source ".weconfig"
fi

# Check for .nvmrc and read the version from it if present
if [ -f ".nvmrc" ]; then
    WE_NODE_VERSION=$(cat .nvmrc)
fi

if [ $# -eq 0 ]; then
    echo "No arguments provided."
    exit 1
fi

COMMAND=$1
shift;

case $COMMAND in
    "composer")
        docker run -it --rm \
            --user $(id -u):$(id -g) \
            --volume ~/.composer:/tmp \
            --volume /etc/passwd:/etc/passwd:ro \
            --volume /etc/group:/etc/group:ro \
            --volume $(pwd):/app \
            composer:${WE_COMPOSER_VERSION:-latest} "$@"
        ;;
    "node")
        # Use the Node version based on .nvmrc, .weconfig, or default to the environment variable
        docker run -it --rm \
            --user $(id -u):$(id -g) \
            --volume /etc/passwd:/etc/passwd:ro \
            --volume /etc/group:/etc/group:ro \
            --volume $(pwd):/app \
            --workdir /app \
            node:${WE_NODE_VERSION:-latest} /usr/local/bin/npm "$@"
        ;;
    "php")
        docker run -it --rm \
          --user $(id -u):$(id -g) \
          --volume /etc/passwd:/etc/passwd:ro \
          --volume /etc/group:/etc/group:ro \
          --volume $(pwd):/app \
          --workdir /app \
          php:${WE_PHP_VERSION:-latest} php "$@"
        ;;
    "artisan")
        docker run -it --rm \
          --user $(id -u):$(id -g) \
          --volume /etc/passwd:/etc/passwd:ro \
          --volume /etc/group:/etc/group:ro \
          --volume $(pwd):/app \
          --workdir /app \
          php:${WE_PHP_VERSION:-latest} php artisan "$@"
        ;;
    "hugo")
        docker run -it --rm \
          --user $(id -u):$(id -g) \
          --volume $(pwd):/src \
          --workdir /src \
          hugomods/hugo:${WE_HUGO_VERSION:-latest} "$@"
        ;;
    *)
        echo "bad command";
        ;;
esac
