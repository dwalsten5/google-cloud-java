#!/bin/bash

# This script is used by Travis-CI to run tests.
# This script is referenced in .travis.yml.

if [ "${TRAVIS_BRANCH}" == "master" -a "${TRAVIS_PULL_REQUEST}" == "false" ]; then
    # Get signing tools and API keyfile
    openssl aes-256-cbc -K $encrypted_631490ecae8f_key -iv $encrypted_631490ecae8f_iv -in target/travis/signing-tools.tar.enc -out target/travis/signing-tools.tar -d
    mkdir $TRAVIS_BUILD_DIR/signing-tools
    chmod 700 $TRAVIS_BUILD_DIR/signing-tools
    tar xvf target/travis/signing-tools.tar -C $TRAVIS_BUILD_DIR/signing-tools
    # Export test env variables
    export GCLOUD_TESTS_PROJECT_ID="gcloud-devel"
    export GCLOUD_TESTS_KEY=$TRAVIS_BUILD_DIR/signing-tools/gcloud-devel-travis.json
    # Run verify
    mvn verify
else
    mvn verify -DskipITs
fi
