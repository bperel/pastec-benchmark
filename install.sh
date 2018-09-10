#!/bin/sh
# the actual running/execution of the test, etc... This is called at run-time.
# The program under test and/or any parsing/wrapper scripts should then pipe the results to $LOG_FILE for parsing.
# Passed to the script as arguments are any of the test arguments/options as defined by the test-definition.xml.

# Editing the test profile's results-definition.xml controls how the Phoronix Test Suite will capture the program's result.

ubuntu_version=$(echo $1 | cut -f1 -d-)
ubuntu_version_name=$(echo $1 | cut -f2 -d-)

image_name=bperel/pastec-ubuntu-`echo $ubuntu_version | sed "s/\.//g"`-timestamps
container_name=pastec-ubuntu-$ubuntu_version-1

echo -n "Result: " > $LOG_FILE
/usr/bin/time -o $LOG_FILE --append -f '%e' \
    docker exec -i $container_name /bin/bash /scripts/import_samples.sh
echo $? > ~/test-exit-status
