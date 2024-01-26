-- entities

function add_blue(data)
 -- data: x, y, name, class (4),
	-- vit, pwr, def, dex (8),
	-- lck, level, exp, wep (12)
	
	local class = classes[data[4]]
	local mount = 0
	if class == 9 or class == 10 then mount = 1 end
	
	add(blue_units, {
	xpos = data[1],
	ypos = data[2],
	name = data[3],
	sprite = class.sprite,
	class = data[4],
	hp = data[5], maxhp = data[5], sta = 0, moved = 0,
	pwr = data[6], def = data[7], dex = data[8], lck = data[9],
	mov = class.move, mounted = mount,
	movepath = {}, movedir = -1, sflip = false,
	lv = data[10], exp = data[11], wep = data[12]
	})
end

function add_red(data)
 -- data: x, y, name, class (4),
	-- vit, pwr, def, dex (8),
	-- lck, level, wep (11)
	
	local class = classes[data[4]]
	local mount = 0
	if class == 9 or class == 10 then mount = 1 end
	
	add(red_units, {
	xpos = data[1],
	ypos = data[2],
	name = data[3],
	sprite = class.sprite,
	class = data[4],
	hp = data[5], maxhp = data[5], sta = 0, moved = 0,
	pwr = data[6], def = data[7], dex = data[8], lck = data[9],
	mov = class.move, mounted = mount,
	movepath = {}, movedir = -1, sflip = false,
	lv = data[10], wep = data[11]
	})
end



function update_units()
 
	for unit in all(blue_units) do
	 if #unit.movepath > 0 or unit.movedir >= 0 then
		 
			if unit.movedir == -1 then
			 unit.movedir = unit.movepath[1]
				deli(unit.movepath, 1)
				
			else
			 if unit.movedir == 0 then unit.x += 1 unit.sflip = false
			 elseif unit.movedir == 1 then unit.y -= 1
			 elseif unit.movedir == 2 then unit.x -= 1 unit.sflip = true
			 elseif unit.movedir == 3 then unit.y += 1
				end
				if unit.x % 8 + unit.y % 8 == 0 then
				 unit.movedir = -1
					if #unit.movepath <= 0 then unit.sflip = false end
				end
			 
			end
		end
	end
	
end

function draw_units()
 
	-- get frame
 local fr = t % 72 -- 30, 6, 30, 6
	if fr <= 29 then fr = 0
	elseif fr >= 36 and fr <= 66 then fr = 2
	else fr = 1
	end
	
	-- colour half-circle
	for unit in all(blue_units) do sspr(0, 16, 8, 2, unit.x, unit.y + 7) end
	for unit in all(red_units) do sspr(0, 18, 8, 2, unit.x, unit.y + 7) end
 
	for unit in all(blue_units) do
	 if unit.moved == 1 then
		 pal(11, 1) -- mid blue to dark blue
		 pal(4, 2) -- dark brown to dark red
		 pal(6, 5) -- light gray to mid gray
		 pal(7, 5) -- white to mid gray
		 pal(9, 4) -- orange to dark brown
		 pal(15, 5) -- peach to mid gray
		end
	 
	 local offy = sin((unit.x % 8 + unit.y % 8) / 16) * 2 -- y offset when moving
	 local s = unit.sprite
		if #unit.movepath <= 0 and unit.movedir == -1 then s += fr end
		spr(s, unit.x, unit.y + offy, 1, 1, unit.sflip)
		
		if unit.moved == 1 then
		 pal(11, 11) -- mid blue reset
		 pal(4, 4) -- dark brown reset
		 pal(6, 6) -- light gray reset
		 pal(7, 7) -- white reset
		 pal(9, 9) -- orange reset
		 pal(15, 15) -- peach reset
		end
	end
	
	pal(11, 8) -- mid blue to light red
	pal(1, 2) -- dark blue to dark red
	
	for unit in all(red_units) do
	 if unit.moved == 1 then
		 pal(11, 4) -- mid blue to dark brown
		 pal(4, 2) -- dark brown to dark red
		 pal(6, 5) -- light gray to mid gray
		 pal(7, 5) -- white to mid gray
		 pal(9, 4) -- orange to dark brown
		 pal(15, 5) -- peach to mid gray
		end
	
	 local offy = sin((unit.x % 8 + unit.y % 8) / 16) * 2 -- y offset when moving
	 local s = unit.sprite
		if #unit.movepath <= 0 and unit.movedir == -1 then s += fr end
		spr(s, unit.x, unit.y + offy, 1, 1, unit.sflip)
		
		if unit.moved == 1 then
		 pal(11, 8) -- mid blue to light red
		 pal(4, 4) -- dark brown reset
		 pal(6, 6) -- light gray reset
		 pal(7, 7) -- white reset
		 pal(9, 9) -- orange reset
		 pal(15, 15) -- peach reset
		end
	end
	
	pal(11, 11) -- mid blue reset
	pal(1, 1) -- dark blue reset
	
end



function draw_popups()
 for p in all(popups) do
	 if p.life > 0 then
		 p.life -= 1
			
			p.y += p.vsp
			p.vsp += 0.07
			if p.y >= p.max_y then p.y = p.max_y p.vsp = 0 end
			
			printb(p.val, p.x, p.y, 9, 0)
	 
		else del(popups, p)
		end
	end
end