#!/system/bin/sh
until [[ "$(getprop sys.boot_completed)" == "1" ]]; do sleep 1; done
sleep 2
mount binfmt_misc -t binfmt_misc /proc/sys/fs/binfmt_misc 2>/dev/null
echo ':arm_exe:M::\x7fELF\x01\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x28::/system/bin/houdini:P' >> /proc/sys/fs/binfmt_misc/register 2>/dev/null
echo ':arm_dyn:M::\x7fELF\x01\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x03\x00\x28::/system/bin/houdini:P' >> /proc/sys/fs/binfmt_misc/register 2>/dev/null
echo ':arm64_exe:M::\x7fELF\x02\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\xb7::/system/bin/houdini64:P' >> /proc/sys/fs/binfmt_misc/register 2>/dev/null
echo ':arm64_dyn:M::\x7fELF\x02\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x03\x00\xb7::/system/bin/houdini64:P' >> /proc/sys/fs/binfmt_misc/register 2>/dev/null
