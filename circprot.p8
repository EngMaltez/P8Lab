pico-8 cartridge // http://www.pico-8.com
version 32
__lua__
--protect the circle
--by miguel maltez

--todo:
--. collision detection wave and rock
--. collision detection rock and player
--. delete rocks when out of range

function _init()
	plr = {x=63,y=63,r=5} -- player
	waves={}      -- shockwaves
	rocks={}      -- rocks
end

function _update()
	if (btn(⬅️)) plr.x -=1
	if (btn(➡️)) plr.x +=1
	if (btn(⬆️)) plr.y -=1
	if (btn(⬇️)) plr.y +=1
	
	if btnp(🅾️) then
		sfx(1)
	 create_shockwave()
	end
	if btnp(❎) then
		sfx(2)
		create_rock()
	end

	update_shockwaves()
	update_rocks()
	-- check collisions
	for wave in all(waves) do
		for rock in all(rocks) do
			if is_colliding(wave,rock) then
				sfx(3)
				del(rocks, rock)
			end
		end
	end
	
end

function _draw()
	cls()
	circ(plr.x,plr.y,plr.r,4)
	draw_shockwaves()
	draw_rocks()
	print("waves:"..#waves,0,0,12)
	print("rocks:"..#rocks,0,6,5)
end
-->8
-- shockwave

function create_shockwave()
	add(waves,
		{x=plr.x, y=plr.y, r=plr.r}
	)
end

function update_shockwaves()
	for wave in all(waves) do
		wave.r += 0.2
		if wave.r > 60 then
			del(waves,wave)
		end
	end
end

function draw_shockwaves()
	for wave in all(waves) do
		circ(wave.x,wave.y,wave.r,13)
	end
end

-->8
-- rocks

function create_rock()
	angle = rnd(1)
	rock = {
		x = cos(angle)*64,
		y = sin(angle)*64,
		r = flr(rnd(2))+1,
		vx=0, vy=0
	}
	dx = plr.x-rock.x
	dy = plr.y-rock.y
	distance = sqrt(dx*dx+dy*dy)
	rock.vx = dx / distance
	rock.vy = dy / distance
	add(rocks,rock)
end

function update_rocks()
	for rock in all(rocks) do
		rock.x += rock.vx
		rock.y += rock.vy
	end
end

function draw_rocks()
	for rock in all(rocks) do
		circ(rock.x,rock.y,rock.r,5)
	end
end

-->8
-- collision

function is_colliding(o1, o2)
	-- collision between 2 circles
	dx = o1.x - o2.x
	dy = o1.y - o2.y
	dist = sqrt(dx*dx+dy*dy)
	return dist < (o1.r + o2.r)
end
 
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00020000080501e0502b050350503a050390502d0501e05018050130500f0500d0500a05009050080500705007050060500605005050050500305003050010500005000050000000000000000000000000000000
00100000040500b050000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000500002963020640136200b61005610036100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
