#!/usr/bin/env bash

# some checks
if [ "${TRAVIS_PULL_REQUEST}" != "false" ]; then
  echo "This is a pull request - not uploading wheel";
  exit 0
fi

if [ -z "${DOCUSER}" ] || [ -z "${DOCPASS}" ] || [ -z "${BOB_UPLOAD_WHEEL}" ]; then
  echo "Server username and/or password undefined - not uploading wheel";
  exit 0
fi

# check branch (see: http://stackoverflow.com/a/229606)
branch=$(git branch)
#if [[ "$branch" != *"master"* ]]; then
#  echo "Not on master branch, but on branch '$branch' -- not uploading wheel";
#  exit 0;
#fi

echo "Detected branch '$branch' to be master branch -- uploading wheel to Idiap servers"

# create wheel
if [ "${BOB_UPLOAD_WHEEL}" != "1" ]; then
  WHEEL_OPTION=${BOB_UPLOAD_WHEEL}
fi
bin/python setup.py bdist_wheel -d wheel $WHEEL_OPTION

# uplaod wheel
wheel=`find wheel -name "*.whl"`
server=https://${DOCUSER}:${DOCPASS}@www.idiap.ch/software/bob/wheels-upload/travis/

echo -e "\n\nUploading wheel $wheel to server https://www.idiap.ch/software/bob/wheels-upload/travis/"

# send
curl --silent --insecure --upload-file $wheel ${server}
