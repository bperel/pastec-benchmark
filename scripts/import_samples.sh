#!/bin/bash

i=1

for F in /tmp/sample_images/*.jpg;
do
    curl -sS -X PUT --data-binary @"${F}" http://localhost:4212/index/images/$i
    ((i++))
done
