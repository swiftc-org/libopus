#!/bin/bash

MIN_VERSION="7.0"

config()
{
    autoupdate ./configure.ac
    autoreconf -i
    ./autogen.sh
}

build()
{
    SDKPATH=$1
    ARCH=$2

pushd .

    export SYSROOT="`xcrun -sdk ${SDKPATH} --show-sdk-platform-path`/Developer"
    export CC="xcrun -sdk ${SDKPATH} clang -arch ${ARCH} -miphoneos-version-min=${MIN_VERSION}"
    export CCAS="xcrun -sdk ${SDKPATH} clang -arch ${ARCH} -miphoneos-version-min=${MIN_VERSION} -no-integrated-as"

	./configure --disable-doc --disable-extra-programs --with-sysroot=$(SYSROOT) --host=arm-apple-darwin

    make

    cp .libs/libopus.a ../tmp/libopus_${ARCH}.a

popd

    make clean
}

merge()
{
    cd ../tmp
    lipo -create *.a -output libopus.a
}

mkdir ../tmp

config

build iphoneos armv7
build iphoneos armv7s
build iphoneos arm64
build iphonesimulator i386
build iphonesimulator x86_64

merge

