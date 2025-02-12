#!/usr/bin/env sh
docker container exec -w /workspaces/zmk/app -it `cat .devcontainer-id` "$@"
