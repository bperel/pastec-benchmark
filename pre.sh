#!/bin/sh
# pre.sh is called prior to running the test, if needed to setup any sample data / create a test file / seed a cache / related pre-run tasks
BASE_PWD=`dirname "$0"`
argument=$1
ubuntu_version=$(echo $argument | cut -f1 -d-)
ubuntu_version_name=$(echo $argument | cut -f2 -d-)

image_name=bperel/pastec:ubuntu-`echo $ubuntu_version | sed "s/\.//g"`-timestamps
container_name=pastec-ubuntu-$ubuntu_version-1

docker rm -f $container_name

cat << EOF > Dockerfile
FROM ubuntu:$ubuntu_version

RUN apt-get update \
  && DEBIAN_FRONTEND=noninteractive apt-get install -y curl wget vim libopencv-dev libmicrohttpd-dev libjsoncpp-dev cmake git
RUN git clone --depth=1 https://github.com/bperel/pastec.git /pastec
RUN mkdir -p /pastec/build && mkdir /pastec/data
RUN apt-get install -y libcurl4-openssl-dev
WORKDIR /pastec/build
RUN cmake ../ && make
RUN cd /pastec/data \
  && wget -q http://pastec.io/files/visualWordsORB.tar.gz \
  && tar zxf visualWordsORB.tar.gz

EXPOSE 4212
VOLUME /pastec/
CMD ./pastec -p 4212 -i pastec-index-last.dat /pastec/data/visualWordsORB.dat
EOF

(docker pull $image_name || docker build . -t $image_name) && \
docker run -d --name $container_name -v $BASE_PWD/sample_images/:/tmp/sample_images/ -v $BASE_PWD/scripts:/scripts $image_name || exit 1

while ! `docker logs $container_name | grep -q "Ready to accept queries."`; do
    echo -n "." && sleep 1
done
