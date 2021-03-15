#!/bin/bash
#-------------------------------------#
# Build scripts for Jenkins           #
#                                     #
# (c) 2021 Global Consulting Partners #
#-------------------------------------#

##Download sdk image
#$ANDROID_HOME/tools/bin/sdkmanager --install "system-images;android-25;google_apis;x86"

##Creating emulator
#$ANDROID_HOME/tools/bin/avdmanager create avd -n androidAVD -k "system-images;android-25;google_apis;x86 --force"
#echo "no"

#Start the emulator
$ANDROID_HOME/tools/emulator no-snapshot -port 5556 -avd androidAVD &
EMULATOR_PID=$!

# Wait for Android to finish booting
WAIT_CMD="${ANDROID_HOME}/platform-tools/adb wait-for-device shell getprop init.svc.bootanim"
until $WAIT_CMD | grep -m 1 stopped; do
  echo "Waiting..."
  sleep 1
done

# Unlock the Lock Screen
$ANDROID_HOME/platform-tools/adb shell input keyevent 82

# Clear and capture logcat
$ANDROID_HOME/platform-tools/adb logcat -c
$ANDROID_HOME/platform-tools/adb logcat > build/logcat.log &
LOGCAT_PID=$!

# Run the tests
./gradlew installDebug
./gradlew connectedAndroidTest -i

# Stop the background processes
echo "LOGCAT_PID = ${LOGCAT_PID}"
echo "EMULATOR_PID = ${EMULATOR_PID}"
kill $LOGCAT_PID
kill $EMULATOR_PID
$ANDROID_HOME/platform-tools/adb -s emulator-5556 emu kill