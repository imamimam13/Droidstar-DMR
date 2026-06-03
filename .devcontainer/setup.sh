#!/bin/bash
set -e

echo "=== Installing build dependencies ==="

# Install system deps
sudo apt-get update
sudo apt-get install -y wget unzip libgl1-mesa-dev libglib2.0-0

# Install aqtinstall
pip install aqtinstall==3.1.18

# Install Qt for Android and Desktop
echo "=== Installing Qt 6.7.2 ==="
aqt install-qt linux android 6.7.2 android_arm64_v8a -m qtmultimedia --outputdir $HOME/Qt
aqt install-qt linux desktop 6.7.2 linux_gcc_64 --outputdir $HOME/Qt

# Install Android SDK
echo "=== Installing Android SDK ==="
mkdir -p $HOME/android-sdk/cmdline-tools
cd /tmp
wget -q https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip -O cmdline-tools.zip
unzip -q cmdline-tools.zip
mv cmdline-tools $HOME/android-sdk/cmdline-tools/latest

export ANDROID_SDK_ROOT=$HOME/android-sdk
export PATH=$ANDROID_SDK_ROOT/cmdline-tools/latest/bin:$ANDROID_SDK_ROOT/platform-tools:$PATH

yes | sdkmanager --licenses > /dev/null 2>&1
sdkmanager --install "platform-tools" "platforms;android-34" "build-tools;34.0.0" "ndk;26.1.10909125"

# Set environment variables
echo "export ANDROID_SDK_ROOT=$HOME/android-sdk" >> $HOME/.bashrc
echo "export QT_HOST_PATH=$HOME/Qt/6.7.2/gcc_64" >> $HOME/.bashrc
echo "export PATH=$HOME/Qt/6.7.2/gcc_64/bin:$ANDROID_SDK_ROOT/cmdline-tools/latest/bin:$ANDROID_SDK_ROOT/platform-tools:$PATH" >> $HOME/.bashrc
echo "export LD_LIBRARY_PATH=$HOME/Qt/6.7.2/gcc_64/lib:$HOME/Qt/6.7.2/android_arm64_v8a/lib" >> $HOME/.bashrc

echo ""
echo "=== Setup complete! ==="
echo "Run: source ~/.bashrc"
echo "Then: cd /workspaces/Droidstar-DMR && mkdir -p build && cd build"
echo "Then: qmake -r ../DroidStar.pro -spec android-clang CONFIG+=release ANDROID_ABIS=arm64-v8a"
echo "Then: make -j\$(nproc)"
echo "Then: make install INSTALL_ROOT=deploy"
echo "Then: androiddeployqt --input android-DroidStar-deployment-settings.json --output deploy --android-platform android-34 --jdk \$JAVA_HOME --gradle"
