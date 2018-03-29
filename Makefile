xcodeproj:
	swift package generate-xcodeproj --xcconfig-overrides Package.xcconfig

build:
	swift build -Xswiftc "-target" -Xswiftc "x86_64-apple-macosx10.13"

test:
	swift test -Xswiftc "-target" -Xswiftc "x86_64-apple-macosx10.13"
