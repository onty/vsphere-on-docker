FROM mcandre/docker-debian-32bit
MAINTAINER Lintang Prasojo <lintang.jp@icloud.com>

# Inspired by monokrome/wine
ENV WINE_MONO_VERSION 0.0.8
USER root

# Install some tools required for creating the image
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        curl \
        unzip \
        sudo

# Install wine and related packages
RUN dpkg --add-architecture i386 \
        && apt-get update \
        && apt-get install -y --no-install-recommends \
                wine \
        && rm -rf /var/lib/apt/lists/*

# Use the latest version of winetricks
RUN curl -SL 'http://winetricks.org/winetricks' -o /usr/local/bin/winetricks \
        && chmod +x /usr/local/bin/winetricks

# Get latest version of mono for wine
RUN mkdir -p /usr/share/wine/mono \
    && curl -SL 'http://sourceforge.net/projects/wine/files/Wine%20Mono/$WINE_MONO_VERSION/wine-mono-$WINE_MONO_VERSION.msi/download' -o /usr/share/wine/mono/wine-mono-$WINE_MONO_VERSION.msi \
    && chmod +x /usr/share/wine/mono/wine-mono-$WINE_MONO_VERSION.msi
#RUN curl -SL 'http://vsphereclient.vmware.com/vsphereclient/2/5/0/2/2/2/2/VMware-viclient-all-6.0.0-2502222.exe' -o /home/xclient/viclient.exe
RUN mkdir -p /home/xclient /etc/sudoers.d/ \
    && echo "xclient:x:1000:1000:xclient,,,:/home/xclient:/bin/bash" >> /etc/passwd \
    && echo "xclient:x:1000:" >> /etc/group \
    && echo "xclient ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/xclient \
    && chmod 0440 /etc/sudoers.d/xclient \
    && chown xclient:xclient -R /home/xclient

USER xclient
ENV HOME /home/xclient
ENV WINEPREFIX /home/xclient/.wine
ENV WINEARCH win32
COPY VMware-viclient-all-6.0.0-2502222.exe /home/xclient/
#RUN curl -SL 'http://vsphereclient.vmware.com/vsphereclient/2/5/0/2/2/2/2/VMware-viclient-all-6.0.0-2502222.exe' -o /home/xclient/viclient.exe
# Use xclient's home dir as working dir
#WORKDIR /home/xclient
#RUN wine /home/xclient/VMware-viclient-all-6.0.0-2502222.exe 
#RUN wine /home/xclient/viclient.exe 

#RUN echo "alias winegui='wine explorer /desktop=DockerDesktop,1024x768'" > ~/.bash_aliases
