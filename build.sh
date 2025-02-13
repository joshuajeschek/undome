#!/usr/bin/env sh

BUILD_FLAGS="-DSHIELD=splitkb_aurora_lily58_$1"
if [ -n "$CENTRAL" ]; then
  BUILD_FLAGS="$BUILD_FLAGS -DCONFIG_ZMK_SPLIT_ROLE_CENTRAL=y"
fi

build_side() {
  ./exec.sh west build -d build/$1 -b nice_nano_v2 -- $BUILD_FLAGS
  docker cp "$(cat .devcontainer-id):/workspaces/zmk/app/build/$1/zephyr/zmk.uf2" undome-$1.uf2
}

case "$1" in
  left|right)
    build_side "$1"
    ;;
  "")
    build_side left
    build_side right
    ;;
  *)
    echo "Usage: $0 [left|right]"
    exit 1
    ;;
esac
