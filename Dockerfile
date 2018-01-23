FROM openjdk:8-jdk

ENV ANDROID_COMPILE_SDK=26 \
	ANDROID_BUILD_TOOLS=26.0.2 \
	ANDROID_SDK_TOOLS_REV=3859397 \
	ANDROID_CMAKE_REV=3.6.4111459 \
	ANDROID_HOME="/app/android-sdk-linux" \
	ANDROID_NDK_HOME="/app/android-sdk-linux/ndk-bundle" \
	PATH="/app/android-sdk-linux/tools:/app/android-sdk-linux/platform-tools:${PATH}:/app/android-sdk-linux"

WORKDIR /app

RUN curl -sL https://deb.nodesource.com/setup_9.x | bash - && \
	apt-get --quiet update --yes && \
	apt-get install -y nodejs npm unzip lib32stdc++6 lib32z1 gradle && \
	#npm install -g cordova && \
	#For sdkmanager configs
	mkdir $HOME/.android && \
	#Avoid warning
	echo 'count=0' > $HOME/.android/repositories.cfg && \
	wget --quiet --output-document=android-sdk.zip https://dl.google.com/android/repository/sdk-tools-linux-${ANDROID_SDK_TOOLS_REV}.zip && \
	mkdir $PWD/android-sdk-linux && \
	unzip -qq android-sdk.zip -d $PWD/android-sdk-linux && \
	#export ANDROID_HOME=$PWD/android-sdk-linux && \
	#Remove if you don't need NDK
	#export ANDROID_NDK_HOME=$ANDROID_HOME/ndk-bundle && \
	#export PATH=$PATH:$ANDROID_HOME/platform-tools/:$ANDROID_NDK_HOME && \
	echo y | $ANDROID_HOME/tools/bin/sdkmanager --update && \
	echo y | $ANDROID_HOME/tools/bin/sdkmanager 'tools' && \
	echo y | $ANDROID_HOME/tools/bin/sdkmanager 'platform-tools' && \
	echo y | $ANDROID_HOME/tools/bin/sdkmanager 'build-tools;'$ANDROID_BUILD_TOOLS && \
	echo y | $ANDROID_HOME/tools/bin/sdkmanager 'platforms;android-'$ANDROID_COMPILE_SDK && \
	#echo y | $ANDROID_HOME/tools/bin/sdkmanager 'platforms;android-'24 && \
	echo y | $ANDROID_HOME/tools/bin/sdkmanager 'extras;android;m2repository' && \
	echo y | $ANDROID_HOME/tools/bin/sdkmanager 'extras;google;google_play_services' && \
	echo y | $ANDROID_HOME/tools/bin/sdkmanager 'extras;google;m2repository' && \
	echo y | $ANDROID_HOME/tools/bin/sdkmanager 'cmake;'$ANDROID_CMAKE_REV && \
	#Remove if you don't need NDK
	echo y | $ANDROID_HOME/tools/bin/sdkmanager 'ndk-bundle'