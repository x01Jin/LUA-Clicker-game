local circleX, circleY, circleRadius = 500, 300, 50
local obstacleX, obstacleY, obstacleRadius = 300, 300, 50
local score = 0
local gameOver = false
local timer = 10
local clickCount = 0
local threshold = 15
local gameState = "start"

function love.load()
    love.graphics.setBackgroundColor(0, 0, 0)
end

function love.update(dt)
    if gameState == "play" then
        timer = timer - dt
        if timer <= 0 then
            if clickCount < threshold then
                gameOver = true
                gameState = "gameover"
            else
                timer = 10
                clickCount = 0
            end
        end
    end
end

function love.draw()
    if gameState == "start" then
        love.graphics.setColor(255, 255, 255)
        love.graphics.printf("Welcome to the Clicker Game!\n\nClick the red circle to score points.\nAvoid clicking on the white circle.\nReach 15 clicks within 10 seconds to continue playing.\n\nClick anywhere to start.", 0, love.graphics.getHeight() / 2 - 100, love.graphics.getWidth(), "center")
    elseif gameState == "play" then
        love.graphics.setColor(255, 0, 0)
        love.graphics.circle("fill", circleX, circleY, circleRadius)

        love.graphics.setColor(255, 255, 255)
        love.graphics.circle("fill", obstacleX, obstacleY, obstacleRadius)

        love.graphics.setColor(255, 255, 255)
        love.graphics.print("Score: " .. score, 10, 10)
        love.graphics.print("Time: " .. math.ceil(timer), 10, 30)
    elseif gameState == "gameover" then
        love.graphics.setColor(255, 255, 255)
        love.graphics.printf("Game Over", 0, love.graphics.getHeight() / 2 - 20, love.graphics.getWidth(), "center")
        love.graphics.printf("Your Score: " .. score, 0, love.graphics.getHeight() / 2, love.graphics.getWidth(), "center")
        love.graphics.printf("Click anywhere to Restart", 0, love.graphics.getHeight() / 2 + 40, love.graphics.getWidth(), "center")
    end
end

function love.mousepressed(x, y, button, istouch, presses)
    if gameState == "start" then
        gameState = "play"
    elseif gameState == "play" then
        if not gameOver then
            local distanceToCircle = math.sqrt((x - circleX)^2 + (y - circleY)^2)
            local distanceToObstacle = math.sqrt((x - obstacleX)^2 + (y - obstacleY)^2)
            if distanceToCircle <= circleRadius then
                score = score + 1
                circleX, circleY = love.getRandomPosition(circleRadius, obstacleX, obstacleY, obstacleRadius)
                clickCount = clickCount + 1
                if clickCount >= threshold then
                    timer = 10
                    clickCount = 0
                end
                obstacleX, obstacleY = love.getRandomPosition(obstacleRadius, circleX, circleY, circleRadius)
            elseif distanceToObstacle <= obstacleRadius then
                gameOver = true
                gameState = "gameover"
            end
        end
    elseif gameState == "gameover" and button == 1 then
        score = 0
        circleX = love.math.random(circleRadius, love.graphics.getWidth() - circleRadius)
        circleY = love.math.random(circleRadius, love.graphics.getHeight() - circleRadius)
        timer = 10
        clickCount = 0
        gameOver = false
        gameState = "start"
    end
end

function love.getRandomPosition(radius, avoidX, avoidY, avoidRadius)
    local x, y
    repeat
        x = love.math.random(radius, love.graphics.getWidth() - radius)
        y = love.math.random(radius, love.graphics.getHeight() - radius)
    until not love.isCollision(x, y, radius, avoidX, avoidY, avoidRadius)
    return x, y
end

function love.isCollision(x1, y1, r1, x2, y2, r2)
    local dx = x2 - x1
    local dy = y2 - y1
    local distance = math.sqrt(dx * dx + dy * dy)
    return distance < r1 + r2
end
