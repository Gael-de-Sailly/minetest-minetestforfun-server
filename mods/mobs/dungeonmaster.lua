
-- Dungeon Master by PilzAdam

-- Node which cannot be destroyed by DungeonMasters' fireballs
local excluded = {"nether:netherrack","default:obsidian_glass","default:obsidian", "default:obsidian_cooled", "default:bedrock", "doors:door_steel_b_1", "doors:door_steel_t_1", "doors:door_steel_b_2", "doors:door_steel_t_2","default:chest_locked"}

mobs:register_mob("mobs:dungeon_master", {
	-- animal, monster, npc, barbarian
	type = "monster",
	-- aggressive, shoots fireballs at player, deal 13 damages
	passive = false,
	damage = 13,
	attack_type = "shoot",
	shoot_interval = 2.5,
	arrow = "mobs:fireball",
	shoot_offset = 0,
	-- health & armor
	hp_min = 50,
	hp_max = 60,
	armor = 60,
	-- textures and model
	collisionbox = {-0.7, -0.01, -0.7, 0.7, 2.6, 0.7},
	visual = "mesh",
	mesh = "mobs_dungeon_master.x",
	textures = {
		{"mobs_dungeon_master.png"},
		{"mobs_dungeon_master_cobblestone.png"},
		{"mobs_dungeon_master_strangewhite.png"},
	},
	visual_size = {x=8, y=8},
	blood_texture = "mobs_blood.png",
	-- sounds
	makes_footstep_sound = true,
	sounds = {
		random = "mobs_dungeonmaster",
		attack = "mobs_fireball",
	},
	-- speed and jump
	walk_velocity = 1,
	run_velocity = 2,
	jump = false,
	view_range = 16,
	-- drops mese or diamond when dead
	drops = {
		{name = "default:mese_crystal_fragment",
		chance = 1, min = 1, max = 3,},
		{name = "default:diamond",
		chance = 5, min = 1, max = 3,},
		{name = "default:mese_crystal",
		chance = 2, min = 1, max = 3,},
		{name = "default:diamond_block",
		chance = 30, min = 1, max = 1,},
		{name = "maptools:gold_coin",
		chance = 15, min = 1, max = 2,},
		{name = "maptools:silver_coin",
		chance = 1, min = 2, max = 10,},
	},
	-- damaged by
	water_damage = 1,
	lava_damage = 1,
	light_damage = 0,
	-- model animation
	animation = {
		stand_start = 0,		stand_end = 19,
		walk_start = 20,		walk_end = 35,
		punch_start = 36,		punch_end = 48,
		speed_normal = 15,		speed_run = 15,
	},
})
-- spawn on stone between 20 and -1 light, 1 in 7000 chance, 1 dungeon master in area starting at -100 and below
mobs:register_spawn("mobs:dungeon_master", {"default:stone, nether:netherrack"}, 20, -1, 7000, 1, -100)
-- register spawn egg
mobs:register_egg("mobs:dungeon_master", "Dungeon Master", "fire_basic_flame.png", 1)

-- fireball (weapon)
mobs:register_arrow("mobs:fireball", {
	visual = "sprite",
	visual_size = {x=1, y=1},
	textures = {"mobs_fireball.png"},
	velocity = 6,

	-- direct hit, no fire... just plenty of pain
	hit_player = function(self, player)
		player:punch(self.object, 1.0,  {
			full_punch_interval=1.0,
			damage_groups = {fleshy=13},
		}, 0)
	end,

	hit_mob = function(self, player)
		player:punch(self.object, 1.0,  {
			full_punch_interval=1.0,
			damage_groups = {fleshy=8},
		}, 0)
	end,

	-- node hit, bursts into flame (cannot blast through obsidian or protection redo mod items)
	hit_node = function(self, pos, node)
	local pos = vector.round(pos)
	local radius = 1
	local vm = VoxelManip()
	local minp, maxp = vm:read_from_map(vector.subtract(pos, radius), vector.add(pos, radius))
	local a = VoxelArea:new({MinEdge = minp, MaxEdge = maxp})
	local data = vm:get_data()
	local p = {}
	local c_air = minetest.get_content_id("air")
	local c_ignore = minetest.get_content_id("ignore")
	local c_obsidian = minetest.get_content_id("default:obsidian")
	local c_brick = minetest.get_content_id("default:obsidianbrick")

	for z = -radius, radius do
	for y = -radius, radius do
	local vi = a:index(pos.x + (-radius), pos.y + y, pos.z + z)
	for x = -radius, radius do
		p.x = pos.x + x
		p.y = pos.y + y
		p.z = pos.z + z
		if data[vi] ~= c_air and data[vi] ~= c_ignore and data[vi] ~= c_obsidian and data[vi] ~= c_brick then
			local n = minetest.get_node(p).name
			-- do NOT destroy protection nodes but DO destroy nodes in protected area
			if not n:find("protector:") then -- and not minetest.is_protected(p, "") then
				local excluding = minetest.get_item_group(n, "unbreakable") == 1
					or n:split(":")[1] == "nether"
					or next(areas:getAreasAtPos(p)) ~= nil
				for _,i in ipairs(excluded) do
					if i == n then excluding = true end
				end
				--if p.y < -19600 and including and n:split(":")[1] == "nether" then
				if excluding then
					return
				end
				if n == "default:chest" then
					meta = minetest.get_meta(p)
					inv  = meta:get_inventory()
					for i = 1,32 do
						m_stack = inv:get_stack("main",i)
						obj = minetest.add_item(pos,m_stack)
						if obj then
							obj:setvelocity({x=math.random(-2,1), y=7, z=math.random(-2,1)})
						end
					end
				end
				if minetest.registered_nodes[n].groups.flammable or math.random(1, 100) <= 30 then
					minetest.set_node(p, {name="fire:basic_flame"})
				else
					minetest.remove_node(p)
				end
				if n == "doors:door_wood_b_1" then
					minetest.remove_node({x=p.x,y=p.y+1,z=p.z})
				elseif n == "doors:door_wood_t_1" then
					minetest.remove_node({x=p.x,y=p.y-1,z=p.z})
				end
			end
		end
		vi = vi + 1
	end
	end
	end
	end
})