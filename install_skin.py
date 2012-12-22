#!/usr/bin/python
from sys import argv
from os.path import exists
from shutil import copyfile

skinspath = "skins/textures"

sprite = False
if '-2d' in argv:
	sprite = True
if not sprite and not '-3d' in argv:
	print("Usage:",argv[0]," <-2d|-3d> <files...>")
	exit(1)

fnbase = skinspath + "/character_"
if sprite:
	fnbase = skinspath + "/player_"

for f in argv:
	if f[0] == '-' or f == argv[0]:
		continue
	if sprite and "_back.png" in f:
		continue
	if sprite and not exists (f.replace(".png","_back.png")):
		continue
	print ("\033[1;37mInstalling\033[0m",f)
	i = 1
	while exists(fnbase + str(i) + ".png"):
		i += 1
	print(f,"=>",fnbase + str(i) + ".png")
	copyfile(f,fnbase + str(i) + ".png")
	if sprite:
		copyfile(f.replace(".png","_back.png"),fnbase + str(i) + "_back.png")

