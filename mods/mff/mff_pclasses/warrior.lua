-------------------
-- Warrior class --
-------------------

--
-- See https://github.com/Ombridride/minetest-minetestforfun-server/issues/113
--

pclasses.api.register_class("warrior", {
	on_assigned = function(pname, inform)
		if inform then
			minetest.sound_play("pclasses_full_warrior", {to_player=pname, gain=1})
			minetest.chat_send_player(pname, "You are now a warrior")
		end
		sprint.set_maxstamina(pname, 20)
		minetest.log("action", "[PClasses] Player " .. pname .. " becomes a warrior")
	end,
	on_unassigned = function(pname)
		sprint.set_default_maxstamina(pname)
	end,
	switch_params = {
		color = {r = 06, g = 06, b = 30},
		tile = "default_steel_block.png",
		holo_item = "default:dungeon_master_s_blood_sword"
	},
	informations = pclasses.api.textify("'Warriors' is a class of players designed to improve fighting parameters of players who\n" ..
	   "chose to belong to it. You become a big tank, of human shape. Not only can you wear\n" ..
	   "stronger protections (like the Black Mithril armor's pieces, because Black Mithril is a thing\n" ..
	   "here), and use more powerful hand-to-hand weapons (such as the Dungeon Master's\n" ..
	   "blood sword, because yes, you are going to fight Dungeon Masters and drain their blood),\n" ..
	   "but your stamina bar is boosted up to 20! Trust us, running away is an important part\n" ..
	   "of fighting a Dungeon Master. Being a warrior, you regenerate health faster, which is,\n" ..
	   "again, quite handy, at the cost of needing to eat more frequently (less handy). The\n" ..
	   "pedestal tied to the Warriors' includes the strongest sword, available only to Warriors :\n" ..
	   "the Dungeon Master's Blood Sword. It just looks like what you imagine, just\n" ..
	   "more pixel-ish.")
})

pclasses.api.reserve_item("warrior", "default:sword_mithril")
pclasses.api.reserve_item("warrior", "default:dungeon_master_s_blood_sword")

for _, i in pairs({"helmet", "chestplate", "boots", "leggings"}) do
	pclasses.api.reserve_item("warrior", "3d_armor:" .. i .. "_blackmithril")
	pclasses.api.reserve_item("warrior", "3d_armor:" .. i .. "_mithril")
end

pclasses.api.reserve_item("warrior", "shields:shield_mithril")
pclasses.api.reserve_item("warrior", "shields:shield_blackmithril")
