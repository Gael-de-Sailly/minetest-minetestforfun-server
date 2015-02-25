-----------------------------------------------------------------------------------------------
-- Fishing - Mossmanikin's version - Recipes 0.0.8
-----------------------------------------------------------------------------------------------
-- License (code & textures): 	WTFPL
-- Contains code from: 		animal_clownfish, animal_fish_blue_white, fishing (original), stoneage
-- Looked at code from:
-- Dependencies: 			default, farming
-- Supports:				animal_clownfish, animal_fish_blue_white, animal_rat, mobs
-----------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------
-- Fishing Pole
-----------------------------------------------------------------------------------------------
-- mc style
minetest.register_craft({
	output = "fishing:pole",
	recipe = { 
		{"", 				"",					"group:stick"	},
		{"", 				"group:stick",	"farming:string"},
		{"group:stick",	"",					"farming:string"},
	}
})

minetest.register_craft({
	output = "fishing:pole",
	recipe = { 
		{"", 				"",					"group:stick"  },
		{"", 				"group:stick",	"moreblocks:rope"},
		{"group:stick",	"",					"moreblocks:rope"},
	}
})
if minetest.get_modpath("ropes") ~= nil then
minetest.register_craft({
	output = "fishing:pole",
	recipe = { 
		{"", 				"",					"group:stick"	},
		{"", 				"group:stick",	"ropes:rope"   	},
		{"group:stick",	"",					"ropes:rope"   	},
	}
})
end

-----------------------------------------------------------------------------------------------
-- Roasted Fish
-----------------------------------------------------------------------------------------------
minetest.register_craft({
	type = "cooking",
	output = "fishing:fish",
	recipe = "fishing:fish_raw",
	cooktime = 2,
})

-----------------------------------------------------------------------------------------------
-- Wheat Seed
-----------------------------------------------------------------------------------------------
minetest.register_craft({
	type = "shapeless",
	output = "farming:seed_wheat",
	recipe = {"farming:wheat"},
})
-----------------------------------------------------------------------------------------------
-- Sushi
-----------------------------------------------------------------------------------------------
minetest.register_craft({
	type = "shapeless",
	output = "fishing:sushi",
	recipe = {"fishing:fish_raw","farming:seed_wheat","flowers:seaweed"},
})

minetest.register_craft({
	type = "shapeless",
	output = "fishing:sushi",
	recipe = {"fishing:fish_raw","farming:seed_wheat","seaplants:kelpgreen"},
		
})

-----------------------------------------------------------------------------------------------
-- Roasted Shark
-----------------------------------------------------------------------------------------------
minetest.register_craft({
	type = "cooking",
	output = "fishing:shark_cooked",
	recipe = "fishing:shark",
	cooktime = 2,
})

-----------------------------------------------------------------------------------------------
-- Roasted Pike
-----------------------------------------------------------------------------------------------
minetest.register_craft({
	type = "cooking",
	output = "fishing:pike_cooked",
	recipe = "fishing:pike",
	cooktime = 2,
})
