FROM alpine:3.9

RUN apk add --update bash openssl ca-certificates

RUN apk update && \
  apk add --no-cache libstdc++ g++ make git && \
  git clone https://github.com/DCMTK/dcmtk.git && \
  cd dcmtk/config && \
  ./rootconf && \
  cd .. && \
  ./configure --ignore-deprecation && \
  make all && \
  make install && \
  make distclean && \
  cd .. && \
  rm -r dcmtk && \
  apk add alpine-sdk perl tzdata cmake && \
  mkdir -p /opt/GDCM/BUILD && cd /opt/GDCM && \
  git clone -b 'release' --depth=1 https://github.com/malaterre/GDCM.git && \
  cd /opt/GDCM/BUILD && \
  cmake -DCMAKE_BUILD_TYPE=Release -DGDCM_BUILD_SHARED_LIBS:BOOL=ON -DGDCM_BUILD_TESTING:BOOL=OFF -DGDCM_BUILD_APPLICATIONS:BOOL=ON /opt/GDCM/GDCM && \
  make && make install && rm -rf /opt/GDCM && \
  apk del --purge alpine-sdk perl tzdata cmake && apk add libstdc++ && \
  apk del g++ make git && \
  rm /var/cache/apk/*



