-- Skins mod for minetest
-- Adds a skin gallery to the inventory, using inventory_plus
-- Released by Zeg9 under WTFPL
-- Have fun !

skins = {}
skins.type = { SPRITE=0, MODEL=1 }

skins.skins = {}
skins.default = function()
	return "character"
end

skins.get_type = function(texture)
	if not texture then return end
	if string.sub(texture,0,string.len("character")) == "character" then
		return skins.type.MODEL
	end
	if string.sub(texture,0,string.len("player")) == "player" then
		return skins.type.SPRITE
	end
end

dofile(minetest.get_modpath("skins").."/skinlist.lua")

skins.update_player_skin = function(player)
	name = player:get_player_name()
	if skins.get_type(skins.skins[name]) == skins.type.SPRITE then
		player:set_properties({
			visual = "upright_sprite",
			textures = {skins.skins[name]..".png",skins.skins[name].."_back.png"},
			visual_size = {x=1, y=2},
		})
	elseif skins.get_type(skins.skins[name]) == skins.type.MODEL then
		player:set_properties({
			visual = "mesh",
			textures = {skins.skins[name]..".png"},
			visual_size = {x=1, y=1},
		})
	end
end

skins.formspec = {}
skins.formspec.main = function(name, page)
	if page == nil then page = 0 end
	local formspec = "size[8,7.5]"
		.. "button[0,0;2,.5;main;Back]"
		.. "label[0,.5;Your current skin:]"
		.. "label[0,1.5;Choose a skin below:]"
	if skins.get_type(skins.skins[name]) == skins.type.MODEL then
		formspec = formspec .. "image[3,.5;2,1;"..skins.skins[name]..".png]"
	elseif skins.get_type(skins.skins[name]) == skins.type.SPRITE then
		formspec = formspec .. "image[3,0;1,2;"..skins.skins[name]..".png]"
		formspec = formspec .. "image[4,0;1,2;"..skins.skins[name].."_back.png]"
	end
	local imodel = 0
	local isprite = 0
	local smodel = 0 -- Skip models, used for pages
	local ssprite = 0 -- Skip sprites, used for pages (page handling needs cleanup)
	for i, skin in ipairs(skins.list) do
		if skins.get_type(skin) == skins.type.MODEL and imodel < 8 then
			if smodel < page then smodel = smodel + 1 else
				if imodel < 4 then
					formspec = formspec .. "image_button["..(imodel*2)..",2;2,1;"..skin..".png;skins_set_"..i..";]"
				else
					formspec = formspec .. "image_button["..((imodel-4)*2)..",3;2,1;"..skin..".png;skins_set_"..i..";]"
				end
				imodel = imodel +1
			end
		end
		if skins.get_type(skin) == skins.type.SPRITE and isprite < 8 then
			if ssprite < page then ssprite = ssprite + 1 else
				formspec = formspec .. "image_button["..(isprite)..",4.5;1,2;"..skin..".png;skins_set_"..i..";]"
				isprite = isprite +1
			end
		end
	end
	if page > 0 then
		formspec = formspec .. "button[0,7;1,.5;skins_page_"..(page-1)..";<<]"
	end
	formspec = formspec .. "label[3,6.5;Page "..page.."]"
	if imodel > 8 or isprite > 8 then
		formspec = formspec .. "button[7,7;1,.5;skins_page_"..(page+1)..";>>]"
	end
	return formspec
end


minetest.register_on_joinplayer(function(player)
	if not skins.skins[player:get_player_name()] then
		skins.skins[player:get_player_name()] = skins.default()
	end
	skins.update_player_skin(player)
	inventory_plus.register_button(player,"skins","Skin")
end)

minetest.register_on_player_receive_fields(function(player,formname,fields)
	if fields.skins then
		inventory_plus.set_inventory_formspec(player,skins.formspec.main(player:get_player_name()))
	end
	for field, _ in pairs(fields) do
		if string.sub(field,0,string.len("skins_set_")) == "skins_set_" then
			skins.skins[player:get_player_name()] = skins.list[tonumber(string.sub(field,string.len("skins_set_")+1))]
			skins.update_player_skin(player)
			inventory_plus.set_inventory_formspec(player,skins.formspec.main(player:get_player_name()))
		end
		if string.sub(field,0,string.len("skins_page_")) == "skins_page_" then
			inventory_plus.set_inventory_formspec(player,skins.formspec.main(player:get_player_name(),tonumber(string.sub(field,string.len("skins_page_")+1))))
		end
	end
end)

