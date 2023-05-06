#!/bin/bash

# free
sudo dnf install \
     https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm

# non-free
sudo dnf install \
     https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

sudo dnf update -y

sudo dnf install git @development-tools autoconf gtk3-devel gnutls-devel   libtiff-devel giflib-devel libjpeg-devel libpng-devel libXpm-devel   ncurses-devel texinfo   libxml2-devel   jansson jansson-devel libwebp-devel sqlite-devel ImageMagick librsvg2-devel lcms2-devel gpm-devel GConf2-devel m17n-lib-devel libotf-devel libXft-devel libtree-sitter-devel rofi picom akmod-nvidia xorg-11-drv-nvidia-cuda curl polybar zsh alacritty feh lxappearance nautilus openssl openssl-libs GConf2 openssl1.1 blueman

sudo dnf group upgrade --with-optional Multimedia --allowerasing

if ! command -v emacs &> /dev/null
then
    git clone --depth 1 --branch emacs-29 git://git.sv.gnu.org/emacs.git
    cd emacs
    ./autogen.sh
    ./configure --with-json --with-tree-sitter --with-small-ja-dic --with-native-compilation
    make -j
    sudo make install
    cd ..
fi

ROFI_THEME_FILE=~/.local/share/rofi/themes/nord.rasi
if [ ! -f "$ROFI_THEME_FILE" ]; then
    git clone https://github.com/lr-tech/rofi-themes-collection.git
    cd rofi-themes-collection
    mkdir -p ~/.local/share/rofi/themes/
    cp themes/nord.rasi ~/.local/share/rofi/themes/
    cd ..
fi

IOSEVKA_FILE=~/.local/share/fonts/iosevka.ttc
if [ ! -f "$IOSEVKA_FILE" ]; then
    wget https://github.com/be5invis/Iosevka/releases/download/v22.0.2/super-ttc-iosevka-22.0.2.zip
    unzip super-ttc-iosevka-22.0.2.zip
    mkdir -p ~/.local/share/fonts
    cp iosevka.ttc $IOSEVKA_FILE
fi

NORDIC_THEME_DIR=~/.themes/Nordic
if [ ! -d "$NORDIC_THEME_DIR" ];
then
    git clone --depth 1 https://github.com/EliverLara/Nordic.git ~/.themes/Nordic
    sudo cp -r ~/.themes/Nordic/  /usr/share/themes/Nordic
    git clone https://github.com/EliverLara/firefox-nordic-theme && cd firefox-nordic-theme
    ./scripts/install.sh
    cd ..
    git clone https://github.com/alvatip/Nordzy-icon
    cd Nordzy-icon
    ./install.sh
    cd ..
fi

mkdir -p ~/.config/alacritty
cp ./alacritty.yml ~/.config/alacritty/alacritty.yml

cp ./tower-nord.png ~/Pictures/tower-nord.png
sudo cp ./moon-nord.png  /usr/share/backgrounds/moon-nord.png
sudo cp ./me.jpg  /usr/share/backgrounds/me.jpg

cp ./i3_config ~/.config/i3/config

mkdir -p ~/.config/picom
cp ./picom.conf ~/.config/picom/picom.conf

mkdir -p ~/.config/polybar
cp ./polybar.ini ~/.config/polybar/config.ini
cp ./polybar.launch.sh ~/.config/polybar/launch.sh
chmod +x ~/.config/polybar/launch.sh

i3-msg restart

sudo lchsh $USER

# install rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

## install nextest for rust
curl -LsSf https://get.nexte.st/latest/linux | tar zxf - -C ${CARGO_HOME:-~/.cargo}/bin

# install golang

if ! command -v go &> /dev/null
then
    wget https://go.dev/dl/go1.20.3.linux-amd64.tar.gz
    sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf go1.20.3.linux-amd64.tar.gz
    echo -n 'export PATH=$PATH:/usr/local/go/bin' >> ~/.zshenv
fi

# install unity-hub

sudo sh -c 'echo -e "[unityhub]\nname=Unity Hub\nbaseurl=https://hub.unity3d.com/linux/repos/rpm/stable\nenabled=1\ngpgcheck=1\ngpgkey=https://hub.unity3d.com/linux/repos/rpm/stable/repodata/repomd.xml.key\nrepo_gpgcheck=1" > /etc/yum.repos.d/unityhub.repo'
sudo dnf update && sudo dnf install -y unityhub


# install slack
if ! command -v slack &> /dev/null
then
    wget https://downloads.slack-edge.com/releases/linux/4.31.155/prod/x64/slack-4.31.155-0.1.el8.x86_64.rpm
    sudo yum -y install ./slack-4.31.155-0.1.el8.x86_64.rpm
fi

# install zoom
if ! command -v zoom &> /dev/null
then
    wget https://zoom.us/client/latest/zoom_x86_64.rpm
    sudo dnf localinstall zoom_x86_64.rpm
fi
