FROM ubuntu:rolling

ARG GST_VERSION=1.12.4

RUN apt-get -y update

# Install compiler etc.
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y \
  autoconf \
  automake \
  autopoint \
  bison \
  flex \
  libtool \
  yasm \
  nasm \
  git-core \
  build-essential \
  gettext

# Install dependencies necessary to build our custom GStreamer build
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y \
  libglib2.0-dev \
  libpthread-stubs0-dev \
  libssl-dev \
  liborc-dev \
  libmpg123-dev \
  libmp3lame-dev \
  libsoup2.4-dev \
  libshout3-dev \
  libpulse-dev \
  libva-dev


# Fetch and build GStreamer
RUN git clone -b $GST_VERSION --depth 1 git://anongit.freedesktop.org/git/gstreamer/gstreamer && \
  cd gstreamer && \
  git checkout $GST_VERSION && \
  ./autogen.sh --disable-gtk-doc && \
  make -j`nproc` && \
  make install && \
  cd .. && \
  rm -rvf /gstreamer

# Fetch and build gst-plugins-base
RUN git clone -b $GST_VERSION --depth 1 git://anongit.freedesktop.org/git/gstreamer/gst-plugins-base && \
  cd gst-plugins-base && \
  git checkout $GST_VERSION && \
  ./autogen.sh --prefix=/usr \
    --disable-gtk-doc && \
  make -j`nproc` && \
  make install && \
  cd .. && \
  rm -rvf /gst-plugins-base

# Fetch and build gst-plugins-good
RUN git clone -b $GST_VERSION --depth 1 git://anongit.freedesktop.org/git/gstreamer/gst-plugins-good && \
  cd gst-plugins-good && \
  git checkout $GST_VERSION && \
  ./autogen.sh \
    --disable-gtk-doc && \
  make -j`nproc` && \
  make install && \
  cd .. && \
  rm -rvf /gst-plugins-good

# Fetch and build gst-plugins-bad
RUN git clone -b $GST_VERSION --depth 1 git://anongit.freedesktop.org/git/gstreamer/gst-plugins-bad && \
  cd gst-plugins-bad && \
  git checkout $GST_VERSION && \
  ./autogen.sh \
    --disable-gtk-doc && \
  make -j`nproc` && \
  make install && \
  cd .. && \
  rm -rvf /gst-plugins-bad

# Fetch and build gst-plugins-ugly
RUN git clone -b $GST_VERSION --depth 1 git://anongit.freedesktop.org/git/gstreamer/gst-plugins-ugly && \
  cd gst-plugins-ugly && \
  git checkout $GST_VERSION && \
  ./autogen.sh \
    --disable-gtk-doc && \
  make -j`nproc` && \
  make install && \
  cd .. && \
  rm -rvf /gst-plugins-ugly
  
# Fetch and build gst-libav
RUN git clone -b $GST_VERSION --depth 1 git://anongit.freedesktop.org/git/gstreamer/gst-libav && \
  cd gst-libav && \
  git checkout $GST_VERSION && \
  ./autogen.sh \
    --disable-gtk-doc && \
  make -j`nproc` && \
  make install && \
  cd .. && \
  rm -rvf /gst-libav
  
# Fetch and build gst-rtsp-server
RUN git clone -b $GST_VERSION --depth 1 git://anongit.freedesktop.org/git/gstreamer/gst-rtsp-server && \
  cd gst-rtsp-server && \
  git checkout $GST_VERSION && \
  ./autogen.sh \
    --disable-gtk-doc && \
  make -j`nproc` && \
  make install && \
  cd .. && \
  rm -rvf /gst-rtsp-server
  
# Fetch and build gstreamer-vaapi
RUN git clone -b $GST_VERSION --depth 1 git://anongit.freedesktop.org/git/gstreamer/gstreamer-vaapi && \
  cd gstreamer-vaapi && \
  git checkout $GST_VERSION && \
  ./autogen.sh \
    --disable-gtk-doc && \
  make -j`nproc` && \
  make install && \
  cd .. && \
  rm -rvf /gstreamer-vaapi

# Do some cleanup
RUN DEBIAN_FRONTEND=noninteractive  apt-get clean && \
  apt-get autoremove -y
