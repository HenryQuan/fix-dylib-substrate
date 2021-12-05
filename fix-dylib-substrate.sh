#!/bin/bash

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
SUBSTRATE_LINE=$(otool -L "$COPY_PATH" | egrep substrate)

if [ -z "$SUBSTRATE_LINE" ]; then
    echo "substrate framework not found in $COPY_PATH"
    exit 1
fi

echo $SUBSTRATE_LINE
OLD_FRAMEOWRK_PATH=($SUBSTRATE_LINE)
install_name_tool -change "$OLD_FRAMEOWRK_PATH" @loader_path/libsubstrate.dylib "$COPY_PATH"
ldid -s "$COPY_PATH"
echo "Patched and signed $COPY_PATH"
