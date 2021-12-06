#!/bin/bash

<<'###LICENSE'
 Based on https://www.jianshu.com/p/8236249edd35
 Written by HenryQuan
 Repo: https://github.com/HenryQuan/fix-dylib-substrate
 
 This script will backup the original library and change the path pointing to subtrate.
 Xcode might be needed for this to work and it may also works on Linux.
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
BACKUP_PATH="$DYLIB_PATH.bak"
cp "$DYLIB_PATH" "$BACKUP_PATH"
SUBSTRATE_LINE=$(otool -L "$DYLIB_PATH" | egrep [Ss]ubstrate)

if [ -z "$SUBSTRATE_LINE" ]; then
    echo "substrate framework not found in $DYLIB_PATH"
    exit 1
fi

OLD_FRAMEOWRK_PATH=($SUBSTRATE_LINE)
install_name_tool -change "$OLD_FRAMEOWRK_PATH" @loader_path/CydiaSubstrate.framework/CydiaSubstrate "$DYLIB_PATH"
# install_name_tool -change "$OLD_FRAMEOWRK_PATH" @loader_path/libsubstrate.dylib "$COPY_PATH"
ldid -s "$DYLIB_PATH"
echo "Patched and signed $DYLIB_PATH"
