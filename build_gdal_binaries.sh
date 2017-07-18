#!/usr/bin/env bash

OUT_PREFIX='/home/ubuntu/gdal_build'

PROJ4_ZIP='http://download.osgeo.org/proj/proj-4.9.3.tar.gz'
GEOS_TARBALL='http://download.osgeo.org/geos/geos-3.6.1.tar.bz2'
SOURCE_TARBALL='http://download.osgeo.org/gdal/2.2.1/gdal-2.2.1.tar.gz'

echo "Building proj.4"

curl -L ${PROJ4_ZIP} | tar jx
#rm 4.9.3.zip

pushd proj.4-4.9.3 > /dev/null 1>&2
./configure --prefix='/app/.heroku/vendor' &&
make
make install
popd

#echo "Building geos"

curl -L ${GEOS_TARBALL} | tar jx
pushd geos-3.6.1 > /dev/null 1>&2
./configure  --prefix='/app/.heroku/vendor' &&
make
make install
popd



echo "Building gdal..."

curl -L $SOURCE_TARBALL | tar zx

cd gdal-2.2.1
./configure --prefix='/app/.heroku/vendor' \
    --with-jpeg \
    --with-png=internal \
    --with-geotiff=internal \
    --with-libtiff=internal \
    --with-libz=internal \
    --with-curl \
    --with-gif=internal \
    --with-geos='/app/.heroku/vendor/bin/geos-config' \
    --with-static-proj4='/app/.heroku/vendor/bin/proj' \
    --without-expat \
    --with-threads
make
make install

# Cleanup
cd ..
