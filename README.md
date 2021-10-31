## dloader

A small library to assist in creating jailed-tweaks

dloader usage:

install_name_tool -change /usr/lib/libSystem.B.dylib @executable_path/dloader.dylib "YouTube"

install_name_tool -change /Library/Frameworks/CydiaSubstrate.framework/CydiaSubstrate @rpath/CydiaSubstrate.framework/CydiaSubstrate "YouTopia.dylib"


File Hierarchy;

- Payload/Reddit.app/dloader/YouTopia.dylib
- Payload/Reddit.app/dloader.dylib
- Payload/Reddit.app/Frameworks/CydiaSubstrate.framework