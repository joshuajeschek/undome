#!/usr/bin/env sh

build_side() {
  BUILD_FLAGS="-DSHIELD=splitkb_aurora_lily58_$1 -DZMK_CONFIG=/workspaces/zmk-config/config"
  if [ -n "$CENTRAL" ]; then
    BUILD_FLAGS="$BUILD_FLAGS -DCONFIG_ZMK_SPLIT_ROLE_CENTRAL=y"
    echo "building CENTRAL version"
  fi
  echo "===== BUILDING WITH COMMAND ====="
  echo "./exec.sh west build -d build/$1 -b nice_nano_v2 -- $BUILD_FLAGS"
  echo "================================="
  ./exec.sh west build -d build/$1 -b nice_nano_v2 -- $BUILD_FLAGS
  docker cp "$(cat .devcontainer-id):/workspaces/zmk/app/build/$1/zephyr/zmk.uf2" undome-$1.uf2
}

reset() {
  BUILD_FLAGS="-DSHIELD=settings_reset"
  echo "===== BUILDING WITH COMMAND ====="
  echo "./exec.sh west build -b nice_nano_v2 -- $BUILD_FLAGS"
  echo "================================="
  ./exec.sh west build -d build/$1 -b nice_nano_v2 -- $BUILD_FLAGS
  docker cp "$(cat .devcontainer-id):/workspaces/zmk/app/build/zephyr/zmk.uf2" undome-reset.uf2
}

case "$1" in
  left|right)
    build_side "$1"
    exit 0
    ;;
  reset)
    reset
    exit 0
    ;;
  "")
    build_side left
    build_side right
    exit 0
    ;;
  *)
    echo "Usage: $0 [left|right]"
    exit 1
    ;;
esac
