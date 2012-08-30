#!/bin/sh

# functions
function die() {
  echo ""
  echo "FATAL: $*" >&2
  exit 1
}

# check if xcode-select exists
XCODESELECT=$(which xcode-select)
test -x "$XCODESELECT" || die 'Could not find xcode-select in $PATH. Did you install the Command Line Tools for Xcode?'

# check if a version of Xcode is selected
XCODEBUILDPATH=$(xcode-select --print-path)
test -n "$XCODEBUILDPATH" || die 'Could not find Xcode path.'

# setup variables
FRAMEWORKNAME="ZBarSDK.framework"
SCRIPTDIR=$(pwd)
XCODEBUILD=$XCODEBUILDPATH/usr/bin/xcodebuild
LIPO=$(which lipo)
ZBARIPHONE=$SCRIPTDIR/zbarSDK/iphone
ZBARBUILDDIR=$SCRIPTDIR/zbarSDK/iphone/build/Release-iphoneos/ZBarSDK

FRAMEWORK=$SCRIPTDIR/$FRAMEWORKNAME
UNIVERSAL_BINARY=$ZBARBUILDDIR/libzbar.a

# build library
cd $ZBARIPHONE
echo "Compiling Universal ZBar static library and headers"
$XCODEBUILD \
	-target "ZBarSDK" \
	-configuration Release \
	clean build \
	|| die "Xcode buidl failed for Universal ZBar static library"

echo "Building ZBarSDK.framework."

rm -fr $FRAMEWORK
mkdir $FRAMEWORK \
	|| die "Could not create framework directory $FRAMEWORK"

mkdir $FRAMEWORK/Versions
mkdir $FRAMEWORK/Versions/A
mkdir $FRAMEWORK/Versions/A/Headers
mkdir $FRAMEWORK/Versions/A/Resources

cp \
	$ZBARBUILDDIR/Headers/ZBarSDK/*.h \
	$FRAMEWORK/Versions/A/Headers \
	|| die "Error building framework while copying SDK headers"
cp \
	$ZBARBUILDDIR/Resources/* \
	$FRAMEWORK/Versions/A/Resources \
	|| die "Error building framework while copying resources"
cp \
	$UNIVERSAL_BINARY \ 
	$FRAMEWORK/Versions/A/ZBarSDK \
	|| die "Error building framework while copying $UNIVERSAL_BINARY to $FRAMEWORK/Versions/A/ZBarSDK"

# Current directory matters to ln.
cd $FRAMEWORK
ln -s ./Versions/A/Headers ./Headers
ln -s ./Versions/A/Resources ./Resources
ln -s ./Versions/A/ZBarSDK ./ZBarSDK
cd $FRAMEWORK/Versions
ln -s ./A ./Current

echo "Successfully created framework"