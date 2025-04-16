#!/usr/bin/env sh
set -e
DIR=~/Downloads
MIRROR=https://tuf.werf.io/targets/releases
APP=werf

dl()
{
    local ver=$1
    local os=$2
    local arch=$3
    local dotexe=${4:-}
    local platform="$os-$arch"

    # https://tuf.werf.io/targets/releases/2.2.0/linux-amd64/bin/werf
    # https://tuf.werf.io/targets/releases/2.2.0/windows-amd64/bin/werf.exe
    local url=$MIRROR/$ver/${platform}/bin/${APP}${dotexe}
    local lfile=$DIR/${APP}-${ver}-${platform}${dotexe}

    if [ ! -e $lfile ];
    then
        curl -sSLf -o $lfile $url
    fi

    printf "    # %s\n" $url
    printf "    %s: sha256:%s\n" $platform $(sha256sum $lfile | awk '{print $1}')
}

dlver () {
    local ver=$1
    printf "  '%s':\n" $ver
    dl $ver darwin amd64
    dl $ver darwin arm64
    dl $ver linux amd64
    dl $ver linux arm64
    dl $ver windows amd64 .exe
}

dlver ${1:-2.35.2}
