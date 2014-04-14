#! /bin/bash

gm=`which gm`
cvt="";
cmp="";

if [ "$gm" ]; then
	cvt="$gm convert";
	cmp="$gm composite";
else
	cvt=`which convert`;
	cmp=`which composite`;
fi

if [ ! "$cmp$cvt" ]; then
	echo "*** Neither GraphicsMagick nor ImageMagick could be found." >&2;
	echo "*** Please install one of them and run this script again." >&2;
	echo "*** Stop." >&2;
	exit 1;
fi

cd "$(dirname "$0")";

blit() # ID SX SY DX DY W H [HFLIP]
{

	$cvt skins/textures/character_$1.png \
	  -crop $6x$7+$2+$3 .tmp/blit_tmp.png;

	if [ "$8" ]; then
		$cvt -flop .tmp/blit_tmp.png .tmp/blit_tmp.png;
	fi

	$cmp -compose src-over -geometry +$4+$5 \
	  .tmp/blit_tmp.png .tmp/char_tmp.png .tmp/char_tmp_out.png;

	mv .tmp/char_tmp_out.png .tmp/char_tmp.png;

}

convert_one() # ID
{

	id="$1";

	mkdir -p .tmp;

	# Eh... this is one huge overkill. There are prolly better ways to do
	# As always, patches welcome :) -- kaeza

	# Front view
	$cvt -size 16x32 canvas:none .tmp/char_tmp.png
	blit $id  8  8  4  0  8  8      # Head
	blit $id 40  8  4  0  8  8      # Headgear
	blit $id 20 20  4  8  8 12      # Body
	blit $id  4 20  4 20  4 12      # Right Leg
	blit $id  4 20  8 20  4 12 t    # Left Leg
	blit $id 44 20  0  8  4 12      # Right Arm
	blit $id 44 20 12  8  4 12 t    # Left Arm
	mv .tmp/char_tmp.png skins/textures/character_${id}_preview.png;

	# Back view
	$cvt -size 16x32 canvas:none .tmp/char_tmp.png
	blit $id 24  8  4  0  8  8      # Head
	blit $id 56  8  4  0  8  8      # Headgear
	blit $id 32 20  4  8  8 12      # Body
	blit $id 12 20  4 20  4 12 t    # Right Leg
	blit $id 12 20  8 20  4 12      # Left Leg
	blit $id 52 20  0  8  4 12 t    # Right Arm
	blit $id 52 20 12  8  4 12      # Left Arm
	mv .tmp/char_tmp.png skins/textures/character_${id}_preview_back.png;

}

x=1;
while [ -f "skins/textures/character_$x.png" ]; do
	convert_one $x;
	x=$[x+1];
done
