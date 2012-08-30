#!/bin/sh

# check if xcode-select exists
XCODESELECT=$(which xcode-select)
test -x "$XCODESELECT" || die 'Could not find xcode-select in $PATH. Did you install the Command Line Tools for Xcode?'

# check if a version of Xcode is selected
XCODEBUILDPATH=$(xcode-select --pretty-path)
test -n "$XCODEBUILDPATH" || die 'Could not find Xcode path.'

# setup variables
SCRIPTDIR=$(pwd)
XCODEBUILD=$XCODEBUILDPATH/usr/bin/xcodebuild
LIPO=$(which lipo)

# build library