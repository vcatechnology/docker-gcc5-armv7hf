FROM conanio/gcc5

LABEL maintainer="Luis Martinez de Bartolome <luism@jfrog.com>"

ENV CC=arm-linux-gnueabihf-gcc-5 \
    CXX=arm-linux-gnueabihf-g++-5 \
    CMAKE_C_COMPILER=arm-linux-gnueabihf-gcc-5 \
    CMAKE_CXX_COMPILER=arm-linux-gnueabihf-g++-5 \
    STRIP=arm-linux-gnueabihf-strip \
    RANLIB=arm-linux-gnueabihf-ranlib\
    AS=arm-linux-gnueabihf-as \
    AR=arm-linux-gnueabihf-ar \
    LD=arm-linux-gnueabihf-ld \
    FC=arm-linux-gnueabihf-gfortran-5

COPY sources.list /etc/apt/sources.list
COPY armhf.list /etc/apt/sources.list.d/armhf.list

RUN sudo dpkg --add-architecture armhf \
    && sudo apt-get -qq update \
    && sudo apt-get -qq install -y --force-yes --no-install-recommends \
       ".*5.*arm-linux-gnueabihf.*" \
       binutils-arm-linux-gnueabi \
       qemu \
       ssh \
    && sudo update-alternatives --install /usr/bin/arm-linux-gnueabihf-g++ arm-linux-gnueabihf-g++ /usr/bin/arm-linux-gnueabihf-g++-5 100 \
    && sudo update-alternatives --install /usr/bin/arm-linux-gnueabihf-c++ arm-linux-gnueabihf-c++ /usr/bin/arm-linux-gnueabihf-g++-5 100 \
    && sudo update-alternatives --install /usr/bin/arm-linux-gnueabihf-gcc arm-linux-gnueabihf-gcc /usr/bin/arm-linux-gnueabihf-gcc-5 100 \
    && sudo update-alternatives --install /usr/bin/arm-linux-gnueabihf-cc arm-linux-gnueabihf-cc /usr/bin/arm-linux-gnueabihf-gcc-5 100 \
    && sudo rm -rf /var/lib/apt/lists/* \
    && pip install -q --no-cache-dir conan conan-package-tools --upgrade \
    && conan profile new default --detect \
    && conan profile update settings.arch=armv7hf default \
    && conan config rm storage.path \ 
    && sudo ln -s /usr/arm-linux-gnueabihf/lib/ld-linux-armhf.so.3 /lib/ld-linux-armhf.so.3 \
    && curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash - \
    && sudo apt-get install -y --no-install-recommends nodejs \
    && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list \
    && sudo apt-get update && sudo apt-get install -y --no-install-recommends yarn

