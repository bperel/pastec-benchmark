#!/bin/sh
# interim.sh is called in between test runs for when a test profile is set via TimesToRun to execute multiple times. This is useful for restoring a program's state or any other changes that need to be made in between runs.
BASE_PWD=`dirname "$0"`

argument=$1
ubuntu_version=$(echo $argument | cut -f1 -d-)
ubuntu_version_name=$(echo $argument | cut -f2 -d-)

image_name=bperel/pastec-ubuntu-`echo $ubuntu_version | sed "s/\.//g"`-timestamps
container_name=pastec-ubuntu-$ubuntu_version-1

docker rm -f $container_name
docker run -d --name $container_name -v $BASE_PWD/sample_images/:/tmp/sample_images/ -v $BASE_PWD/scripts:/scripts $image_name || exit 1

while ! `docker logs $container_name | grep -q "Ready to accept queries."`; do
    echo -n "." && sleep 1
done
