#!/bin/sh
set -eu
. ./config
PREFIX=~/rigs-of-rods/install
# Initialization
if [ ! -e "$ROR_SOURCE_DIR" ]; then
  mkdir -p "$ROR_SOURCE_DIR"
fi

# OGRE
cd "$ROR_SOURCE_DIR"
if [ ! -e ogre ]; then
  hg clone https://bitbucket.org/sinbad/ogre -b v1-9
fi
cd ogre
 hg pull -r v1-9 && hg update
cmake -DCMAKE_INSTALL_PREFIX="$ROR_INSTALL_DIR" \
-DFREETYPE_INCLUDE_DIR=/usr/include/freetype2/ \
-DOGRE_BUILD_RENDERSYSTEM_GL=TRUE \
-DOGRE_BUILD_RENDERSYSTEM_GL3PLUS=TRUE \
-DOGRE_BUILD_RENDERSYSTEM_GLES2=TRUE \
-DOGRE_BUILD_SAMPLES:BOOL=OFF \
-DOGRE_BUILD_COMPONENT_TERRAIN=TRUE \
-DOGRE_BUILD_PLUGIN_CG=TRUE \
-DOGRE_CONFIG_ENABLE_FREEIMAGE=TRUE \
-DOGRE_CONFIG_ENABLE_DDS=TRUE \
-DOGRE_CONFIG_ENABLE_ETC=TRUE \
-DOGRE_USE_BOOST=FALSE \
-DCMAKE_BUILD_TYPE:STRING=RelWithDebInfo \
-DCMAKE_CXX_FLAGS="-march=native" .
make $ROR_MAKEOPTS
make install

# OpenAL
cd "$ROR_SOURCE_DIR"
 wget -c http://kcat.strangesoft.net/openal-releases/openal-soft-1.16.0.tar.bz2
cd openal-soft-1.16.0
cmake -DCMAKE_INSTALL_PREFIX="$ROR_INSTALL_DIR" \
-DCMAKE_CXX_FLAGS="-march=native" .
make $ROR_MAKEOPTS
make install

# MyGUI
cd "$ROR_SOURCE_DIR"
if [ ! -e mygui ]; then
#  git clone https://github.com/MyGUI/mygui
echo "No MyGUI"
fi
cd mygui
# git pull
cmake -DCMAKE_INSTALL_PREFIX="$ROR_INSTALL_DIR" \
-DFREETYPE_INCLUDE_DIR=/usr/include/freetype2/ \
-DMYGUI_BUILD_DEMOS:BOOL=OFF \
-DMYGUI_BUILD_DOCS:BOOL=OFF \
-DMYGUI_BUILD_TEST_APP:BOOL=OFF \
-DMYGUI_BUILD_TOOLS:BOOL=OFF \
-DMYGUI_BUILD_PLUGINS:BOOL=OFF \
-DCMAKE_BUILD_TYPE:STRING=RelWithDebInfo \
-DCMAKE_CXX_FLAGS="-march=native" .
make $ROR_MAKEOPTS
make install

# Paged Geometry
cd "$ROR_SOURCE_DIR"
if [ ! -e ogre-paged ]; then
  git clone https://github.com/Hiradur/ogre-paged.git
echo "fark"
fi
cd ogre-paged
# git pull
cmake -DCMAKE_INSTALL_PREFIX="$ROR_INSTALL_DIR" \
-DPAGEDGEOMETRY_BUILD_SAMPLES:BOOL=OFF \
-DCMAKE_BUILD_TYPE:STRING=RelWithDebInfo \
-DCMAKE_CXX_FLAGS="-march=native" .
make $ROR_MAKEOPTS
make install

# Caelum
cd "$ROR_SOURCE_DIR"
if [ ! -e ogre-caelum ]; then
  git clone https://github.com/RigsOfRods/ogre-caelum.git
echo "fark"
fi
cd ogre-caelum
 git pull
cmake -DCMAKE_INSTALL_PREFIX="$ROR_INSTALL_DIR" \
-DCMAKE_BUILD_TYPE:STRING=RelWithDebInfo \
-DCMAKE_CXX_FLAGS="-march=native" .
make $ROR_MAKEOPTS
make install
# important step, so the plugin can load:
ln -sf "$ROR_INSTALL_DIR/lib/libCaelum.so" "$ROR_INSTALL_DIR/lib/OGRE/"

# MySocketW
cd "$ROR_SOURCE_DIR"
if [ ! -e mysocketw ]; then
  git clone https://github.com/Hiradur/mysocketw.git
echo "fark"
fi
cd mysocketw
# git pull
sed -i '/^PREFIX *=/d' Makefile.conf
make $ROR_MAKEOPTS shared
PREFIX="$ROR_INSTALL_DIR" make install

# Angelscript
cd "$ROR_SOURCE_DIR"
if [ ! -e angelscript ]; then
  mkdir angelscript
  cd angelscript
  svn co http://svn.code.sf.net/p/angelscript/code/trunk
fi
cd angelscript
#unzip -o angelscript_*.zip
cd sdk/angelscript/projects/gnuc
sed -i '/^LOCAL *=/d' Makefile
# make fails when making the symbolic link, this removes the existing versions

SHARED=1 VERSION=2.33.0 make $ROR_MAKEOPTS

SHARED=1 VERSION=2.33.0 PREFIX="$ROR_INSTALL_DIR" LOCAL="$ROR_INSTALL_DIR" make -s install

#Hydrax (included in RoR's source tree)
#git clone --depth=1 https://github.com/imperative/CommunityHydrax.git
#cd CommunityHydrax
#make -s -j$cpucount PREFIX=/usr/local
#sudo make install PREFIX=/usr/local
#cd ..

echo "$(tput setaf 1)All dependencies were installed successfully"
echo "You can now proceed with RoRcore.sh$(tput sgr 0)"
