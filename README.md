# ZBarSDK Framework

Execute the `build_framework.sh` script to build a universal (iOS/iPhoneSimulator) ZBarSDK.Framework for you that you can use with your iOS projects.

Issue `./build_framework.sh` in the cloned directory.

## Dependencies

Requires the zbar sdk it self which is included as a submodule that is a git mirror of the actual zbar Mercurial repository.

On cloning the repository just issue the following commands to get the submodule going.

	git submodule init
	git submodule update
	
## Usage

Drag and drop the finished product `ZBarSDK.Framework` into your project and it should automatically be setup within your project settings.