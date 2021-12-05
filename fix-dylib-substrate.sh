#!/bin/bash

<<'###LICENSE'
 Based on https://www.jianshu.com/p/8236249edd35
 Written by HenryQuan
 Repo: https://github.com/HenryQuan/fix-dylib-substrate
 
 This script will backup the original library and change the path pointing to subtrate.
 Xcode might be needed for this to work and maybe, it also works on Linux.
 Use this only for educational or research purposes.
 
 MIT LICENSE
###LICENSE

usage() {
    echo "Usage: $0 <dylib-path>"
    exit 1
}

if [ -z "$1" ]; then
    usage
fi

DYLIB_PATH="$1"
COPY_PATH="fixed-$DYLIB_PATH"
cp "$DYLIB_PATH" "$COPY_PATH"
# find the line with substrate in it and this is the line we need to change
SUBSTRATE_LINE=$(otool -L "$COPY_PATH" | egrep substrate)

if [ -z "$SUBSTRATE_LINE" ]; then
    echo "substrate framework not found in $COPY_PATH"
    exit 1
fi

echo $SUBSTRATE_LINE
# split the string by space and get the first element
# /usr/lib/xxx.dylib (xxx) (xxx) -> /usr/lib/xxx.dylib
OLD_FRAMEOWRK_PATH=($SUBSTRATE_LINE)
# update path so that it doesn't crash if the device is not jailbroken
install_name_tool -change "$OLD_FRAMEOWRK_PATH" @loader_path/libsubstrate.dylib "$COPY_PATH"
ldid -s "$COPY_PATH"
echo "Patched and signed $COPY_PATH"
