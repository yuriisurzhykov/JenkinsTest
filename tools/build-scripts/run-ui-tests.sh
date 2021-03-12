#!/bin/bash
#
# Build scripts for Jenkins
#
# (c) 2021 Global Consulting Partners
#
echo "============================== Script run-ui-tests.sh =============================="

#Download sdk image
$ANDROID_HOME\\tools\\bin\\sdkmanager --update "system-images;android-28;google_apis;x86"

#Start the emulator
$ANDROID_HOME\\tools\\bin\\avdmanager create avd -n androidAVD -k "system-images;android-28;google_apis;x86" --skin WVGA800 --force
$ANDROID_HOME\\tools\\emulator -avd testAVD WVGA800 -scale 96dpi -dpi-device 160 -wipe-data -gpu swiftshader_indirect &
EMULATOR_PID=$!

# Wait for Android to finish booting
WAIT_CMD="${ANDROID_HOME}\platform-tools\adb wait-for-device shell getprop init.svc.bootanim"
until $WAIT_CMD | grep -m 1 stopped; do
  echo "Waiting..."
  sleep 1
done

# Unlock the Lock Screen
$ANDROID_HOME\\platform-tools\\adb shell input keyevent 82

# Clear and capture logcat
$ANDROID_HOME\\platform-tools\\adb logcat -c
$ANDROID_HOME\\platform-tools\\adb logcat > build/logcat.log &
LOGCAT_PID=$!

# Run the tests
./gradlew installDebug
./gradlew connectedAndroidTest -i

# Stop the background processes
kill $LOGCAT_PID
kill $EMULATOR_PID
$ANDROID_HOME\\platform-tools\\adb -e emu kill
$ANDROID_HOME\\tools\\bin\\avdmanager delete avd -n androidAVD