#!/bin/sh
PATCHES="allow_screen_sharing.patch extend_internal_window_events.patch extend_cef_response.patch stop_on_redirect.patch"

# in ../cef/chromium/src/cef must be current cef in right branch
cd ../cef/chromium/src/cef
git checkout .
for current_patch in $PATCHES;
do
      patch -p1 < "../../../../cef-builds/patches/${current_patch}";
done
cd tools
./translator.sh
cd ../../../../
