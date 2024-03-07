local circleX, circleY, circleRadius = 500, 300, 50

local obstacleX, obstacleY, obstacleRadius = 300, 300, 50
local score = 0
local gameOver = false

function love.load()
    love.graphics.setBackgroundColor(0, 0, 0)
end

function love.draw()
    love.graphics.setColor(255, 0, 0)
    love.graphics.circle("fill", circleX, circleY, circleRadius)

    love.graphics.setColor(255, 255, 255)
    love.graphics.circle("fill", obstacleX, obstacleY, obstacleRadius)

    love.graphics.setColor(255, 255, 255)
    love.graphics.print("Score: " .. score, 10, 10)

    if gameOver then
        love.graphics.setColor(255, 255, 255)
        love.graphics.printf("Game Over", 0, love.graphics.getHeight() / 2 - 20, love.graphics.getWidth(), "center")
        love.graphics.printf("Press 'R' to Restart", 0, love.graphics.getHeight() / 2 + 20, love.graphics.getWidth(), "center")
    end
end

function love.mousepressed(x, y, button, istouch, presses)
    if not gameOver then
        local distance = math.sqrt((x - circleX)^2 + (y - circleY)^2)
        if distance <= circleRadius then
            score = score + 1
            circleX = love.math.random(circleRadius, love.graphics.getWidth() - circleRadius)
            circleY = love.math.random(circleRadius, love.graphics.getHeight() - circleRadius)
            
            obstacleX = love.math.random(obstacleRadius, love.graphics.getWidth() - obstacleRadius)
            obstacleY = love.math.random(obstacleRadius, love.graphics.getHeight() - obstacleRadius)
        end

        local obstacleDistance = math.sqrt((x - obstacleX)^2 + (y - obstacleY)^2)
        if obstacleDistance <= obstacleRadius then
            gameOver = true
        end
    end
end

function love.keypressed(key)
    if gameOver and key == "r" then
        score = 0
        circleX = love.math.random(circleRadius, love.graphics.getWidth() - circleRadius)
        circleY = love.math.random(circleRadius, love.graphics.getHeight() - circleRadius)
        gameOver = false
    end
end
