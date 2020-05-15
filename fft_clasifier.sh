#!/bin/bash
# A poor man's art clip classifier using ImageMagick
# Initiated on 2020-05-13
# Clead-up to put on Git

# Image files are supposed to be in ./image/
# The output scaled magnitude spectrum images are written in ./mag_images

# Treshold size in bytes (size<treshold_size)?(art_clip):(photo)
treshold_size=1000000

cd  images
for FN in *
do
    echo -------------
    echo $FN
    convert ${FN} -resize 1600x1600\! temp.png
    convert temp.png -fft +depth +adjoin temp_%d.png
    scale=$(convert temp_0.png -auto-level -format "%[fx:exp(log(mean)/log(0.5))]" info:)
    convert temp_0.png -auto-level -evaluate log $scale ../mag_images/mag_spc_${FN}.png
    filesize=$(wc -c < ../mag_images/mag_spc_${FN}.png)
    echo size: $filesize
        if [ $filesize -ge $treshold_size ]; then
	echo file size over $treshold_size =\> likely a photo
    else
	echo file size under $treshold_size =\> likely a clipart
    fi
done
rm temp*
cd ..
