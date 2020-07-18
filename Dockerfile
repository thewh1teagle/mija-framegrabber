FROM debian

RUN dpkg --add-architecture armhf
RUN apt-get update
RUN apt-get install -y \
	bash-completion \
	vim nano git curl wget \
	unzip p7zip-full \
	g++-arm-linux-gnueabihf \
	make file \
	libev-dev:armhf \
	apt-utils

### Prepare framegrabber

RUN mkdir $HOME/framegrabber
WORKDIR $HOME/framegrabber

# Download sdk with toolchain ( we don't need the toolchain ), unzip it and delete the zip file and script
COPY download_sdk .
RUN ./download_sdk && unzip mstar_sdk.zip && rm mstar_sdk.zip download_sdk
RUN mv 'MStar MSC3XX SDK' mstar_sdk

## start extract the sdk
RUN mkdir sdk
RUN cp mstar_sdk/MSC3XX_SDK_V_1610192019-I1_master.lite.7z sdk/sdk.7z
WORKDIR $HOME/framegrabber/sdk
# extract with auto rename for duplicates
RUN 7z e sdk.7z -aou

# sample folder in sdk
WORKDIR $HOME/framegrabber/sdk/sample 
COPY lib/* $HOME/framegrabber/sdk/lib/

CMD ["/bin/bash"]

