#!/bin/sh
# post.sh is called after the test has been run, if needed to flush any cache / temporary files, clean-up anything, etc.

ubuntu_version=$(echo $1 | cut -f1 -d-)
ubuntu_version_name=$(echo $1 | cut -f2 -d-)

image_name=bperel/pastec-ubuntu-`echo $ubuntu_version | sed "s/\.//g"`-timestamps
container_name=pastec-ubuntu-$ubuntu_version-1

docker rm $container_name
rm Dockerfile
