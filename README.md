# dloader
A small library to assist in creating jailed-tweaks

## Requirements
`install_name_tool` and patience

## Usage
For an automated process
```bash
sh inject.sh <path to .ipa file> <path to .dylib>
```
For users more familiar with Xcode's dev tools
```bash
install_name_tool -change /usr/lib/libSystem.B.dylib @executable_path/dloader.dylib "YouTube"

install_name_tool -change /Library/Frameworks/CydiaSubstrate.framework/CydiaSubstrate @rpath/CydiaSubstrate.framework/CydiaSubstrate "YouTopia.dylib"
```
File Hierarchy;

- Payload/YouTube.app/dloader/YouTopia.dylib
- Payload/YouTube.app/dloader.dylib
- Payload/YouTube.app/Frameworks/CydiaSubstrate.framework

or if you need to visualize it: 

```bash
Payload
└── YouTube.app
    ├── Frameworks
    │   └── CydiaSubstrate.framework
    ├── YouTube
    ├── dloader
    │   └── YouTopia.dylib
    └── dloader.dylib
```

## Building
Just invoke `make` (requires that you have [theos](https://github.com/theos/theos/wiki/Installation) installed on your machine)

## Credits 
- [daniel (me)](https://twitter.com/insan1d) for dloader.m
- [n3d1117](https://github.com/n3d1117) for simplifying the process with a inject.sh
- [saurik](https://twitter.com/saurik) for CydiaSubstrate
