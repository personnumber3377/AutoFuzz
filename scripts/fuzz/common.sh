#!/usr/bin/env bash

# This script is to try to set similar environment variables as oss-fuzz sets before starting to do the autofuzzing campaign...

export SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# echo "${BASH_SOURCE[0]}"
# echo $SCRIPT_DIR
export SANITIZER="address"
export CC=clang
export CXX=clang++
export CFLAGS="-fsanitize=address,undefined,fuzzer-no-link -g -O3"
export CXXFLAGS="-fsanitize=address,undefined,fuzzer-no-link -g -O3"
export LIB_FUZZING_ENGINE="-fsanitize=fuzzer" # Actually link the fuzzer here too...
export OUT="$(realpath "$SCRIPT_DIR/../../fuzz_bin/")"
export WORK="$(realpath "$SCRIPT_DIR/../../work/")"


# echo $OUT
