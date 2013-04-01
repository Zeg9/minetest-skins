#!/bin/sh
cd .previews
for i in ../skins/textures/character_*.png;
do
	cp $i ./character.png
	blender --background character.blend \
		--render-output '//character_##.png' \
		--render-frame 0
	mv character_00.png $i"_preview.png"
	echo "Generated preview for $i"
done
echo "Generated previews !"
