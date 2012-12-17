-- Skins mod for minetest
-- Adds a skin gallery to the inventory, using inventory_plus
-- Released by Zeg9 under WTFPL
-- Have fun !

skins.list = {}
skins.add = function(skin)
	table.insert(skins.list,skin)
end

id = 1
while io.open(minetest.get_modpath("skins").."/textures/player_"..id..".png") do
	skins.add("player_"..id)
	id = id +1
end

id = 1
while io.open(minetest.get_modpath("skins").."/textures/character_"..id..".png") do
	skins.add("character_"..id)
	id = id +1
end

