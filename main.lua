
--------------------------------------------------
--		ENEMYSPEAK.COM	 © Kevin Faherty 2013	--
--												--
--------------------------------------------------














function CheckInputEvents()  									-- Event Queue
	love.event.pump()
	for e,a,b,c,d in love.event.poll() do 
		if e == "quit" then										-- Handle 'Quit' Event
			if not love.quit or not love.quit() then
				if love.audio then
					love.audio.stop()
				end
				return
			end
		end
		love.handlers[e](a,b,c,d)
	end
end

build_number = 100

max_fps = 120
max_dt = 1/max_fps
framelimiter = false

function love.run()
	love.load(arg)												-- This function is called exactly once at the beginning of the game.
	
	local dt = 0												-- Init local dt
	
	while true do												-- While loop (Game Loop)
		local frametimestart = love.timer.getMicroTime()		-- Returns time with microsecond precision
		
		love.event.pump()										-- Pump events into the event queue.
		for e,a,b,c,d in love.event.poll() do					-- Returns an iterator for messages in the event queue.
			if e == "quit" then
				if not love.quit or not love.quit() then
					if love.audio then
						love.audio.stop()
					end
					return
				end
			end
			love.handlers[e](a,b,c,d)
		end

		love.timer.step()				-- Measures the time between two frames.
		dt = love.timer.getDelta()		-- Returns the time between the last two frames.
		
		love.update(dt)					-- Callback function used to update the state of the game every frame. dt = Time since the last update in seconds.
		
		love.graphics.clear()		-- Clears the screen to background color.
	
		love.draw()						-- Draws objects on screen.	
		love.graphics.present()			-- Displays the results of drawing operations on the screen.
		
		local framedelta = love.timer.getMicroTime() - frametimestart 	-- Time between event handling and rendering completion
		local sleeptime = max_dt - framedelta							-- Finds the extra time between processing and the maximum
		if framelimiter and sleeptime >= 0.01 then						-- Sleeps program until next frame
			sleeptime = math.floor(sleeptime*1000)/1000					-- Fix decimal points
			love.timer.sleep(sleeptime)									-- Sleeps the program for the specified amount of time.
		else
			love.timer.sleep(0.001)
		end
	end
end

function love.load()
	love.graphics.setBackgroundColor(57,57,57)
	
	love.mouse.setVisible( false )
	
-- 	External Files
					require 'lib.middleclass'
	Stateful = 		require 'lib.stateful.stateful'
	
	require 'obj.gamestate'

	require 'lua.title'	
	require 'lua.intro'
	require 'lua.one'
	require 'lua.two'
	require 'lua.outro'	
		
	gamestate = Gamestate:new()
	gamestate:gotoState('Title')	
end

function love.update(dt)
	gamestate:update(dt)
end

function love.draw()
	gamestate:draw()
end

function love.focus(f)
	gamestate:focus(f)
end

function love.joystickpressed(joystick, button)
	gamestate:joystickpressed(joystick, button)
end

function love.joystickreleased(joystick, button)
	gamestate:joystickreleased(joystick, button)
end

function love.keypressed(key, unicode)
	gamestate:keypressed(key, unicode)
end

function love.keyreleased(key)
	gamestate:keyreleased(key)
end

function love.mousepressed(x, y, button)
	gamestate:mousepressed(x, y, button)
end

function love.mousereleased(x, y, button)
	gamestate:mousereleased(x, y, button)
end

function love.quit()
	gamestate:quit()
end
