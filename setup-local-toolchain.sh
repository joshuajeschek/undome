#!/usr/bin/env sh
docker volume create --driver local -o o=bind -o type=none -o device="$(pwd)" zmk-config
devcontainer up --workspace-folder "$(pwd)/zmk" | tee >(tail | jq '.containerId' -r > .devcontainer-id)

docker container exec -w /workspaces/zmk -it `cat .devcontainer-id` west init -l app/
docker container exec -w /workspaces/zmk -it `cat .devcontainer-id` west update

docker container stop `cat .devcontainer-id`
docker container start `cat .devcontainer-id`
