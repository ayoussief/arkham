#!/usr/bin/env bash
#
# Copyright (c) 2019-present The Arkham Core developers
# Distributed under the MIT software license, see the accompanying
# file COPYING or http://www.opensource.org/licenses/mit-license.php.

export LC_ALL=C.UTF-8

export SDK_URL=${SDK_URL:-https://arkhamcore.org/depends-sources/sdks}

export CONTAINER_NAME=ci_macos_cross
export CI_IMAGE_NAME_TAG="mirror.gcr.io/ubuntu:24.04"
export HOST=x86_64-apple-darwin
export PACKAGES="clang lld llvm zip"
export XCODE_VERSION=15.0
export XCODE_BUILD_ID=15A240d
export RUN_UNIT_TESTS=false
export RUN_FUNCTIONAL_TESTS=false
export GOAL="deploy"
export ARKHAM_CONFIG="-DBUILD_GUI=ON -DREDUCE_EXPORTS=ON"
