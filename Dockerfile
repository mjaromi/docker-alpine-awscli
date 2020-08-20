FROM alpine:latest

LABEL maintainer='mateusz.jaromi@gmail.com'

RUN apk add --no-cache groff jq && \
    GLIBC_VER=$(wget -q -O - https://api.github.com/repos/sgerrand/alpine-pkg-glibc/git/refs/tags | jq -r '.[-1].ref' | awk -F/ '{print $NF}') && \
    wget -q -O glibc-${GLIBC_VER}.apk https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VER}/glibc-${GLIBC_VER}.apk && \
    wget -q -O glibc-bin-${GLIBC_VER}.apk https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VER}/glibc-bin-${GLIBC_VER}.apk && \
    wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub && \
    apk add --no-cache glibc-${GLIBC_VER}.apk && \
    ### fix for: https://github.com/aws/aws-cli/issues/4685#issuecomment-651039956
    rm /usr/glibc-compat/lib/ld-linux-x86-64.so.2 && \
    ln -s /usr/glibc-compat/lib/ld-$(echo ${GLIBC_VER} | cut -d'-' -f1).so /usr/glibc-compat/lib/ld-linux-x86-64.so.2 && \
    ###
    apk add --no-cache glibc-bin-${GLIBC_VER}.apk && \
    wget -q -O awscliv2.zip https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip && \
    unzip -q awscliv2.zip && \
    ./aws/install && \
    ln -s /usr/local/bin/aws /usr/bin/aws && \
    rm -rf awscliv2.zip glibc-${GLIBC_VER}.apk glibc-bin-${GLIBC_VER}.apk /var/cache/apk/*