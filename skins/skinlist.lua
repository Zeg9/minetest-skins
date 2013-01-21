-- Skins mod for minetest
-- Adds a skin gallery to the inventory, using inventory_plus
-- Released by Zeg9 under WTFPL
-- Have fun !

skins.list = {}
skins.add = function(skin)
	table.insert(skins.list,skin)
end

id = 1
while true do
	local f = io.open(minetest.get_modpath("skins").."/textures/player_"..id..".png")
	if (not f) then break end
	f:close()
	skins.add("player_"..id)
	id = id +1
end

id = 1
while true do
	local f = io.open(minetest.get_modpath("skins").."/textures/character_"..id..".png")
	if (not f) then break end
	f:close()
	skins.add("character_"..id)
	id = id +1
end

