#!/bin/bash -e
source ./libmodel.sh
RepoSource=sample
echo -D${wxhighguilib}_DIR=${installRepo}/wxHighgui/lib/cmake/wxHighguiLib
pushd ${buildRepo}/$RepoSource
cmake -G"$CMAKE_CONFIG_GENERATOR"   \
-DBUILD_SHARED_LIBS:BOOL=${SharedLibs} \
-DwxWidgets_ROOT_DIR=${myRepo}/install/wxwidgets -DwxWidgets_LIB_DIR=${installRepo}/wxwidgets/lib/${wxlibs} \
-Dopencv_DIR=${installRepo}/opencv/${ocvlibs} \
-D${wxhighguilib}_DIR=${installRepo}/wxHighgui/lib/cmake/wxHighguiLib \
${sourceRepo}/"$RepoSource"


cmake --build .  --config release 
echo "************************* $Source_DIR -->devenv debug"
cmake --build .  --config debug 
popd



