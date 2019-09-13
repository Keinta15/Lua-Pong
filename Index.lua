System.setCpuSpeed(444)

--\* Initiating Sound Device */
Sound.init()

--\* Colors */
white = Color.new(255, 255, 255)

--\* Loading Images */
paddle = Graphics.loadImage("app0:/resources/paddle.png")
ball = Graphics.loadImage("app0:/resources/ball.png")
bg = Graphics.loadImage("app0:/resources/wallpaper.png")

--\* Loading audio files */
beep = Sound.openOgg("app0:/resources/beep.ogg")
hbeep={hbeep,beep}
peep = Sound.openOgg("app0:/resources/peep.ogg")
hpeep={hpeep,hpeep}

--\* Defining */
p1paddle = 0
p2paddle = 0
ballx = 478
bally = 281
dx = 6
dy = 6
top = 0
bottom = 544
right = 960
left = 0
p1score = 0
p2score = 0

--\* Short button names */
cross = SCE_CTRL_CROSS
square = SCE_CTRL_SQUARE
circle = SCE_CTRL_CIRCLE
triangle = SCE_CTRL_TRIANGLE
start = SCE_CTRL_START
select = SCE_CTRL_SELECT
rtrigger = SCE_CTRL_RTRIGGER
ltrigger = SCE_CTRL_LTRIGGER
up = SCE_CTRL_UP
down = SCE_CTRL_DOWN
left = SCE_CTRL_LEFT
right = SCE_CTRL_RIGHT

--\* Adding game Function */
function game()

	ballx = 478
	bally = 281
	starty = math.random(0,1)
	startx = math.random(0,1)
	
	if startx == 0 then
		dx = -5
	else
		dx = 5
	end

	if starty == 0 then
		dy = -5
	else
		dy = 5
	end
end

--\* Adding wall collision function to play sound */
function wallCollision()
	for s=1,2 do
		if hbeep[s]==nil then
			hbeep[s] = Sound.openOgg("app0:/resources/beep.ogg")
			Sound.play(hbeep[s],NOLOOP)
			break
		end
	end
end

--\* Adding score collision function to play sound */
function scoreCollision()
	for s=1,2 do
		if hpeep[s]==nil then
			hpeep[s] = Sound.openOgg("app0:/resources/peep.ogg")
			Sound.play(hpeep[s],NOLOOP)
			break
		end
	end
end

-- \* Main Loop */
while true do
	pad = Controls.read()

        ballcenterx = ballx + 8
	ballcentery = bally + 8
	balltop = bally
	ballbottom = bally + 16
	ballleft = ballx
	ballright = ballx + 16

	--\*Starting drawing phase*/
	Graphics.initBlend()
	Screen.clear()

	--\* Displaying background */
	Graphics.drawImage(0, 0, bg)

	--\* Displaying other things */
	Graphics.drawImage(ballx, bally, ball)
	Graphics.drawImage(30, p1paddle, paddle)
	Graphics.drawImage(900, p2paddle, paddle)
        Graphics.debugPrint(7, 7, "P1 Score: " ..p1score, white)
	Graphics.debugPrint(810, 7, "P2 Score: " ..p2score, white)
 
	for i=1,2 do
		if hbeep[i] and not Sound.isPlaying(hbeep[i]) then
			Sound.close(hbeep[i])
			hbeep[i]=nil
		end
	end

	for i=1,2 do
		if hpeep[i] and not Sound.isPlaying(hpeep[i]) then
			Sound.close(hpeep[i])
			hpeep[i]=nil
		end
	end
        
        --\* Ball Collisions with walls */
	ballx = ballx + dx
	bally = bally + dy
	if balltop <= top then
		dy = dy * -1,9
		bally = bally + 9
		wallCollision()
	end
	if ballbottom >= bottom then
		dy = dy * -1,9
		bally = bally - 9
		wallCollision()
	end
	if ballleft <= 0 then
		p2score = p2score + 1
		scoreCollision()
		game()
	end
	if ballright >= 960 then
		p1score = p1score + 1
		scoreCollision()
		game()
	end
	

	--\* Control Checking for paddle movements */
	if Controls.check(pad, triangle) then
		p2paddle = p2paddle - 6
		if p2paddle <= 0 then
			p2paddle = 0
		end
	end
	if Controls.check(pad, cross) then
		p2paddle = p2paddle + 6
		if p2paddle >= 482 then
			p2paddle = 482
		end
	end
	if Controls.check(pad, up) then
		p1paddle = p1paddle - 6
		if p1paddle <= 0 then
			p1paddle = 0
		end
	end
	if Controls.check(pad, down) then
		p1paddle = p1paddle + 6
		if p1paddle >= 482 then
			p1paddle = 482
		end
	end
	
	--\* Ball Collisions with paddles */
	if ballleft <= 44 and ballleft >= 42 and ballcentery >= p1paddle and ballcentery <= p1paddle + 62 then
		dx = dx * -1,9
		ballx = ballx + 9
		wallCollision()
	end
	if ballright >= 908 and ballright <=910 and ballcentery >= p2paddle and ballcentery <= p2paddle + 62 then
		dx = dx * -1,9
		ballx = ballx - 9
		wallCollision()
	end

	--\* Controls to exit game */
	if Controls.check(pad, start) then
		Graphics.freeImage(bg)
		Sound.close(beep)
		Sound.close(peep)	
		Sound.term()
		Graphics.term()		
	        System.exit()
	end
	
   --\* Terminating drawing phase */
    Screen.flip()
    Graphics.termBlend()
end
