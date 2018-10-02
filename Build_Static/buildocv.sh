#!/bin/bash -e
SharedLibs=OFF
zlibname=zlib
pnglibname=libpng16
if [[ $SharedLibs = OFF ]]
then
zlibname=${zlibname}static
pnglibname=${pnglibname}_static
fi

myRepo=$(pwd)
installRepo=${myRepo}/install
librepo=opencv_contrib
CMAKE_CONFIG_GENERATOR="Visual Studio 15 2017 Win64" 
if [ ! -d "$myRepo/$librepo" ]; 
then echo "cloning $librepo" 
git clone https://github.com/opencv/opencv_contrib.git 
else 
cd $librepo 
git pull --rebase 
cd .. 
fi 

librepo=opencv
CMAKE_CONFIG_GENERATOR="Visual Studio 15 2017 Win64" 
if [ ! -d "$myRepo/$librepo" ]; 
then echo "cloning $librepo" 
git clone https://github.com/opencv/opencv.git 
mkdir Build/$librepo 
mkdir Install/$librepo 
else 
cd $librepo 
git pull --rebase 
cd .. 
fi 


CMAKE_CONFIG_GENERATOR="Visual Studio 15 2017 Win64"
RepoSource=opencv
pushd Build/$RepoSource
CMAKE_OPTIONS='-DBUILD_opencv_world:BOOL=$SharedLibs -DBUILD_PERF_TESTS:BOOL=OFF -DBUILD_TESTS:BOOL=OFF -DBUILD_DOCS:BOOL=OFF -DWITH_CUDA:BOOL=OFF -DBUILD_EXAMPLES:BOOL=OFF -DCV_TRACE:BOOL=OFF -DBUILD_PNG:BOOL=OFF -DBUILD_ZLIB:BOOL=OFF '
cmake -G"$CMAKE_CONFIG_GENERATOR"   -DBUILD_SHARED_LIBS:BOOL=OFF -DBUILD_WITH_STATIC_CRT:BOOL=OFF \
-DZLIB_INCLUDE_DIR:PATH=${installRepo}/zlib/include -DZLIB_LIBRARY_DEBUG:FILEPATH=${installRepo}/zlib/lib/${zlibname}d.lib -DZLIB_LIBRARY_RELEASE:FILEPATH=${installRepo}/zlib/lib/${zlibname}.lib \
-DPNG_PNG_INCLUDE_DIR:PATH=${installRepo}/libpng/include -DPNG_LIBRARY_RELEASE:FILEPATH=${installRepo}/libpng/lib/${pnglibname}.lib -DPNG_LIBRARY_DEBUG:FILEPATH=${installRepo}/libpng/lib/${pnglibname}d.lib \
$CMAKE_OPTIONS -DOPENCV_EXTRA_MODULES_PATH=../../opencv_contrib/modules -DOPENCV_ENABLE_NONFREE:BOOL=ON \
-DCMAKE_INSTALL_PREFIX=${installRepo}/"$RepoSource"  ../../"$RepoSource"

popd
tototot
echo "************************* $Source_DIR -->devenv debug"
cmake --build $RepoSource  --config release 
echo "************************* $Source_DIR -->devenv release"
cmake --build $RepoSource  --target install --config release 
echo "************************* $Source_DIR -->devenv debug"
cmake --build $RepoSource  --config debug 
echo "************************* $Source_DIR -->devenv release"
cmake --build $RepoSource  --target install --config debug 
cd ..


