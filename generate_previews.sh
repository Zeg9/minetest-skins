#!/bin/sh
cd .previews
rm ../skins/textures/*_preview.png # Remove all previous previews
for i in ../skins/textures/character_*.png;
do
	cp $i ./character.png
	blender --background character.blend \
		--render-output '//character_##.png' \
		--render-frame 0 # Render the preview thanks to blender
	mv character_00.png $i"_preview.png" # put this in the textures folder
	echo "Generated preview for $i"
done
echo "Generated previews !"
