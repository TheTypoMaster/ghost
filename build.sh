#!/bin/bash

###### defines ######

local_dir=$PWD
defconfig=msm8960dt_mmi_defconfig
jobs=4

###### defines ######
echo '#############'
echo 'making clean'
echo '#############'
make clean                                                                 # clean the sources
rm -rf out                                                                 # clean the output folder
echo '#############'
echo 'making defconfig'
echo '#############'
make $defconfig
echo '#############'
echo 'making zImage'
echo '#############'
time make -j$jobs
echo '#############'
echo 'copying files to ./out'
echo '#############'
echo ''
mkdir -p out/modules                                                       # make dirs for zImage and modules
cp arch/arm/boot/zImage out/zImage                                         # copy zImage
# Find and copy modules
find -name '*.ko' | xargs -I {} cp {} ./out/modules/
cp -r out/* ~/kernel/anykernel/                                              # copy zImage and modules to a my folder
echo 'done'
echo ''
if [ -a arch/arm/boot/zImage ]; then
echo '#############'
echo 'Making Anykernel zip'
echo '#############'
echo ''
cd ~/kernel/anykernel/                                                       # cd to the my folder
. zip_anykernel.sh                                                              # execute the script to make an anykernel updater zip
if [[ $1 = -d ]]; then
cp $zipname ~/kernel/anykernel/$zipname
echo "Copying $zipname to My Folder"
fi
cd $local_dir                                                              # cd back to the old dir
echo ''
echo '#############'
echo 'build finished successfully'
echo '#############'
else
echo '#############'
echo 'build failed!'
echo '#############'
fi
