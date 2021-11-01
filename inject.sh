#!/bin/bash

# Inputs: 
#	1. path to .ipa file
#   2. path to .dylib file
TARGET_IPA=$1
TARGET_DYLIB=$2

# Check if both files exists
if [[ ! -f "$TARGET_IPA" ]] || [[ ! -f "$TARGET_DYLIB" ]]; then
	echo "Error: input files not found"
	exit 1
fi

# Check input
ipa_filename=$(basename -- "$TARGET_IPA")
ipa_ext="${ipa_filename##*.}"
dylib_filename=$(basename -- "$TARGET_DYLIB")
dylib_ext="${dylib_filename##*.}"
if [[ "$ipa_ext" != ipa ]] || [[ "$dylib_ext" != dylib ]]; then
	echo "Error: invalid input files!"
	exit 1
fi

# Unzip resources?

# Unzip .ipa to temporary folder
TMP=/tmp/$(openssl rand -base64 8)
mkdir -p $TMP
unzip -q "$TARGET_IPA" -d $TMP
echo $TMP

# Create Frameworks folder inside *.app
(cd $TMP/Payload/*.app && mkdir -p Frameworks)

# Copy resources/CydiaSubstrate.framework to *.app/Frameworks
CURRENT_DIR=$(pwd)
cp -rn $CURRENT_DIR/resources/Frameworks/CydiaSubstrate.framework $TMP/Payload/*.app/Frameworks

# Copy resources/dloader.dylib to *.app
cp $CURRENT_DIR/resources/dloader.dylib $TMP/Payload/*.app

# Create *.app/dloader/ folder
(cd $TMP/Payload/*.app && mkdir -p dloader)

# Move .dylib to *.app/dloader/
cp $TARGET_DYLIB $TMP/Payload/*.app/dloader

# Get main binary name
main_binary=$(/usr/libexec/PlistBuddy -c 'Print :CFBundleExecutable' $TMP/Payload/*.app/Info.plist)

# Run install_name_tool
cd $TMP/Payload/*.app
install_name_tool -change /usr/lib/libSystem.B.dylib @executable_path/dloader.dylib $main_binary
install_name_tool -change /Library/Frameworks/CydiaSubstrate.framework/CydiaSubstrate @rpath/CydiaSubstrate.framework/CydiaSubstrate dloader/$dylib_filename
if [[ $? != 0 ]]; then
	echo "Failed to inject dylib into $main_binary"
	exit 1
fi

# Rezip as ipa
cd ../.. && zip -qrFS $CURRENT_DIR/dloaded_$ipa_filename Payload

# Cleanup tmp folder
rm -rf $TMP

exit 0
