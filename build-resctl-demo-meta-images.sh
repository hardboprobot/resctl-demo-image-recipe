#!/bin/sh
set -e

IMAGE=ghcr.io/go-debos/debos:main

mkdir -p out

docker pull $IMAGE
docker run \
       --rm \
       -w /recipes \
       -v $(pwd):/recipes \
       -u $(id -u):$(id -g) \
       --group-add=$(getent group kvm | cut -d : -f 3) \
       --device /dev/kvm \
       --security-opt label=disable \
       $IMAGE \
       --artifactdir=/recipes/out --scratchsize=16G -t variant:resctl-demo-meta /recipes/resctl-demo-ospack.yaml

docker run \
       --rm \
       -w /recipes \
       -v $(pwd):/recipes \
       -u $(id -u):$(id -g) \
       --group-add=$(getent group kvm | cut -d : -f 3) \
       --device /dev/kvm \
       --security-opt label=disable \
       $IMAGE \
       --artifactdir=/recipes/out -t variant:resctl-demo-meta /recipes/resctl-demo-image-efiboot.yaml

docker run \
       --rm \
       -w /recipes \
       -v $(pwd):/recipes \
       -u $(id -u):$(id -g) \
       --group-add=$(getent group kvm | cut -d : -f 3) \
       --device /dev/kvm \
       --security-opt label=disable \
       $IMAGE \
       --artifactdir=/recipes/out  -t variant:resctl-demo-meta /recipes/resctl-demo-flasher-efiboot.yaml
