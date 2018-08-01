#!/bin/bash

NUMBER_OF_PREVIOUS_VERSIONS="$1"

if [ $NUMBER_OF_PREVIOUS_VERSIONS -gt 0 ]; then
  echo "checking out $NUMBER_OF_PREVIOUS_VERSIONS previous versions of prebid.js"
else
  NUMBER_OF_PREVIOUS_VERSIONS=2
  echo "checking out $NUMBER_OF_PREVIOUS_VERSIONS previous versions of prebid.js"
fi

PREBID_DIR="prebid.js"
if [ ! -d "$PREBID_DIR" ]
  then
    mkdir $PREBID_DIR
    cd $PREBID_DIR
    git clone https://github.com/prebid/Prebid.js.git working_master
  else
    cd $PREBID_DIR
fi
cd working_master
git pull

for TAG in `git tag --sort=-creatordate | head -n $NUMBER_OF_PREVIOUS_VERSIONS`
  do 
    DIR_NAME="../prebid_${TAG}"
    if [ -d "$DIR_NAME" ]
      then 
        echo "$DIR_NAME already installed"
      else
        git clone https://github.com/prebid/Prebid.js.git $DIR_NAME
        cd $DIR_NAME
        git checkout ${TAG}
        npm install
        gulp build 
        echo "$DIR_NAME installed"
      fi
  done
echo "update complete"