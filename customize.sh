#!/sbin/sh
UNZIP_OPTS="-o"
SKIPUNZIP=0
api_level_arch_detect
ui_print "================================================"
ui_print "  Houdini ARM Translation Layer Installer"
ui_print "  For Android 14 x86_64 (Bliss OS)"
ui_print "================================================"
ui_print "- Device Architecture: $ARCH"
ui_print "- Android API Level: $API"
if [ "$ARCH" != "x64" ]; then
    ui_print ""
    ui_print "ERROR: This module requires x86_64 (x64) architecture"
    ui_print "Your device has: $ARCH"
    abort "Installation aborted - wrong architecture"
fi
if [ $API -lt 31 ]; then
    ui_print "WARNING: Android API level $API is lower than recommended (API 31)"
fi
ui_print ""
ui_print "Checking Houdini library files..."
if [ -f "$MODPATH/system/lib/arm/libhoudini.so" ]; then
    ui_print "✓ Found: 32-bit ARM library (libhoudini.so)"
else
    ui_print "✗ Missing: /system/lib/arm/libhoudini.so"
fi
if [ -f "$MODPATH/system/lib64/arm64/libhoudini.so" ]; then
    ui_print "✓ Found: 64-bit ARM library (libhoudini.so)"
else
    ui_print "✗ Missing: /system/lib64/arm64/libhoudini.so"
fi
ui_print ""
ui_print "Installing system properties..."
ui_print ""
ui_print "Installation complete!"
ui_print "IMPORTANT: Reboot device to activate Houdini"
