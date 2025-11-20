#!/bin/bash -eu

# Get the source code and cd into it...

git clone --depth 1 https://gitlab.gnome.org/GNOME/libxml2.git
cd libxml2

# OSS-Fuzz integration, see
# https://github.com/google/oss-fuzz/tree/master/projects/libxml2

# Add extra UBSan checks
if [ "$SANITIZER" = undefined ]; then
    extra_checks="integer,float-divide-by-zero"
    extra_cflags="-fsanitize=$extra_checks -fno-sanitize-recover=$extra_checks"
    export CFLAGS="$CFLAGS $extra_cflags"
    export CXXFLAGS="$CXXFLAGS $extra_cflags"
fi

# Don't enable zlib with MSan
if [ "$SANITIZER" = memory ]; then
    CONFIG=''
else
    CONFIG='--with-zlib'
fi

# Workaround for a LeakSanitizer crashes,
# see https://github.com/google/oss-fuzz/issues/11798.
if [ "$ARCHITECTURE" = "aarch64" ]; then
    export ASAN_OPTIONS=detect_leaks=0
fi

export V=1

./autogen.sh \
    --disable-shared \
    --without-debug \
    --without-http \
    --without-python \
    $CONFIG
make -j$(nproc)
