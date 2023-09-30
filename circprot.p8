pico-8 cartridge // http://www.pico-8.com
version 32
__lua__
--protect the circle
--by miguel maltez

--todo:
-- . automatic rock spawn

function _init()
	init_game()
end

-->8
-- game
spawn_timer = 30

function init_game()
	plr = {
		x=63,y=63,r=3,
		cap=0, -- capacitor charge
		react=0.2, -- reactor power rate per frame
	}
	waves={}      -- shockwaves
	rocks={}      -- rocks
	_update = update_game
	_draw = draw_game
end

function update_game()
	update_player()
	update_shockwaves()
	update_rocks()
	-- check collisions waves & rocks
	for wave in all(waves) do
		for rock in all(rocks) do
			if is_colliding(wave,rock) then
				sfx(5)
				if wave.e <= 1 then
					dmg = wave.e
				else
					dmg = wave.e * rock.r / wave.r
				end
				rock.e -= dmg
				wave.e -= dmg
				if rock.e <= 0 then
					sfx(3)
					del(rocks, rock)
				end
			end
		end
	end
	-- rocks collided with player
	for rock in all(rocks) do
		if is_colliding(rock,plr) then
			sfx(4)
			del(rocks, rock)
			init_gameover(rock)
		elseif dist(rock,plr) > 256 then
			del(rocks, rock)
		end
	end
	-- rock spawn
	if btnp(❎) then
		sfx(2)
		create_rock()
	end
	spawn_timer -= 1
	if spawn_timer == 0 then
		if rnd() < 1/#rocks then
			sfx(2)
			create_rock()
		end
		spawn_timer = 30
	end
end

function draw_game()
	cls()
	-- draw player
	circ(plr.x,plr.y,plr.r,4)
	draw_shockwaves()
	draw_rocks()
	-- draw ship capacitor
	rect(0,123,102,127,1)
	rectfill(1,124,1+plr.cap,126,11)
end

-->8
-- shockwave

function create_shockwave(energy)
	lastwave = {
		x=plr.x, y=plr.y, r=plr.r,
		e=energy
	}
	add(waves,lastwave)
end

function update_shockwaves()
	for wave in all(waves) do
		wave.r += 0.2
		if wave.e <= 0 then
			del(waves,wave)
		end
	end
end

function draw_shockwaves()
	for wave in all(waves) do
		cor = 12
		if (wave.e < 50) cor=7
		if (wave.e < 25) cor=6
		if (wave.e < 10) cor=5
		circ(wave.x,wave.y,wave.r,cor)
	end
	print("waves:"..#waves,0,0,12)
	if lastwave then
		print("e:"..lastwave.e,64,0,12)
	end
end

-->8
-- rocks

function create_rock()
	local angle = rnd(1)
	rock = {
		x = 91*cos(angle) + plr.x,
		y = 91*sin(angle) + plr.y,
		r = flr(rnd(2))+1,
		vx=0, vy=0,
		e = 5
	}
	rock.e = rock.e*rock.r^2
	-- point rock to player
	local dx = plr.x-rock.x
	local dy = plr.y-rock.y
	local distance = dist(plr,rock)
	rock.vx = dx / distance
	rock.vy = dy / distance
	add(rocks,rock)
	lastrock = rock
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
	if lastrock then
		print("e:"..lastrock.e, 64,6,5)
	end
	print("rocks:"..#rocks,0,6,5)
end

-->8
-- collision

function dist(o1,o2)
	local dx = (o1.x - o2.x)/4
	local dy = (o1.y - o2.y)/4
	return 4*sqrt(dx*dx+dy*dy)
end

function is_colliding(o1, o2)
	-- collision between 2 circles
	return dist(o1,o2) < (o1.r + o2.r)
end
 

-->8
-- game over

function init_gameover(rock)
	lastrock = rock
	_update = update_gameover
	_draw = draw_gameover
end

function update_gameover()
	if (btn(❎)) init_game()
end

function draw_gameover()
	cls(8)
	print("game over",48,60,1)
end

-->8
-- player ship

function update_player()
	if (btn(⬅️)) plr.x -=1
	if (btn(➡️)) plr.x +=1
	if (btn(⬆️)) plr.y -=1
	if (btn(⬇️)) plr.y +=1

	if btnp(🅾️) then
		if plr.cap < 5 then
			sfx(6)
		else
			sfx(1)
		 create_shockwave(plr.cap)
	 	plr.cap = 0
	 end
	end
	
	plr.cap += plr.react
	if (plr.cap>100) plr.cap = 100
end

__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000111000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700555000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000ddd000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000666000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700777000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000ccc000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
000100001e00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00020000080501e0502b050350503a050390502d0501e05018050130500f0500d0500a05009050080500705007050060500605005050050500305003050010500005000050000000000000000000000000000000
00100000040500b050000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000500002963020640136200b61005610036100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001400001d5501b55007550045500155000500025001060007600086000660003600026000160000600296002e600006000000000000000000000000000000000000000000000000000000000000000000000000
001000003975039720000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000f00000037001600026000160000700003000060001600006000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0016000013700177001a7001e5002150023500137000f1001d0002000023000197001c7001f7001c700037000b7000c70008700087000570002700007000070000700007000070015700007001e000220001e700
__music__
00 41424344
00 0b424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 4b424344

