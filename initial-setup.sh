#!/bin/bash

cd ..

if [ ! -d "csvsum" ] ;
  then
    git clone git@github.com:ansell/csvsum.git
    # Use known stable release tag
    (cd csvsum && git checkout v0.6.0)
    (cd csvsum && mvn clean install)
fi

if [ ! -d "dwca-utils" ] ;
  then
    git clone git@github.com:ansell/dwca-utils.git
    # Use known stable release tag
    (cd dwca-utils && git checkout v0.0.5)
    (cd dwca-utils && mvn clean install)
fi
