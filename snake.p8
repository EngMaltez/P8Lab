pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
-- snake
-- by zetlam
-- spent: ⧗⧗⧗⧗ ⧗⧗
--
-- todo:
-- 1. collision with screen boundary

ticks = 0
move_beat=10
grid_size=8

dx,dy = 0,0
fruits={}
body={}

function _init()
	initialize_game()
end

function initialize_game()
	fruits = {}
	body={{
			x=flr(128/grid_size/2),
			y=flr(128/grid_size/2)
	}}
	for i=1,2 do
		grow_snake()
	end
	create_fruit()
	_draw = draw_game
	_update = update_game
end

function update_game()
	-- button presses
	if (btnp(⬅️)) dx,dy = -1,0
	if (btnp(➡️)) dx,dy = 1,0
	if (btnp(⬆️)) dx,dy = 0,-1
	if (btnp(⬇️)) dx,dy = 0,1
	-- update skake on beat
	ticks += 1
	if (ticks>=move_beat) then
		ticks=0
		if (dx!=0 or dy!=0) then
			move_snake(dx,dy)
			sfx(1)
			head = body[1]
			-- check ate fruit
			for fruit in all(fruits) do
				if fruit.x == head.x and fruit.y == head.y then
					grow_snake()
					del(fruits,fruit)
					create_fruit()
					sfx(2)
					if (#body%10==0) then
						move_beat -= 1 
					end
				end
			end
			-- check ate itself
			for i=2,#body do
				seg=body[i]
				if head.x == seg.x and head.y == seg.y then
					_draw = draw_gameover
					_update = update_gameover
					sfx(3)
				end
			end
		end
	end
end

function draw_game()
	cls(1)
	draw_snake()
	-- draw fruit
	for f in all(fruits) do
		draw_fruit(f.x,f.y)
	end
	-- print stats
	print("len: "..#body,0,0,10)
	print("cpu: "..
		flr(100*stat(1)).."%"
		,80,0,6)
end -- end _draw

function update_gameover()
	if (btnp(❎)) initialize_game()
end

function draw_gameover()
	cls(8)
	print("length: "..#body,44,50,0)
	print("game over",46,60,0)
end

-->8
-- snake

function move_snake(dx,dy)
	for i=#body,2,-1 do
		body[i].x = body[i-1].x
		body[i].y = body[i-1].y
	end
	body[1].x += dx
	body[1].y += dy
end

function grow_snake()
	last = #body
	body[last+1] = {
		x=body[last].x,
		y=body[last].y,
	}
end

function draw_snake()
	for i=1,#body do
		-- head is blue
		if i==1 then
			cor=12
		else
			cor=11
		end
		rect(
			body[i].x*grid_size,
			body[i].y*grid_size,
			(body[i].x+1)*grid_size-1,
			(body[i].y+1)*grid_size-1,
			cor
		)
	end
end
-->8
-- fruit

function create_fruit()
	fruit = {
		x=flr(rnd(128/grid_size)),
		y=flr(rnd(128/grid_size))}
	add(fruits, fruit)
end

function draw_fruit(x,y)
	rectfill(
		x*grid_size, y*grid_size,
		(x+1)*grid_size-1,
		(y+1)*grid_size-1,
		8)
end


__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
000100001400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000200001001019000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000900002242012410000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000800001164019650186300b62005610000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
