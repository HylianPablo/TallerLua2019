--Pequeño videojuego basado en el famoso Space Invaders
--Grupo Universitario de Informática
--Universidad de Valladolid
--Program based on www.github.com/becauseimgray, special thanks to the original creator
--Versión bastante simplificada del programa original, pero que lo hace más sencillo de entender
--El programa tiene como fin enseñar LUA enfocado a videojuegos
--@HylianPablo

require("BoundingBox")


--Función que carga el juego
function love.load()

    --Añadidos
    font=love.graphics.setNewFont("fonts/LCD_Solid.ttf",60)
    default = love.graphics.setNewFont( "fonts/LCD_Solid.ttf", 10 )
	levelfont = love.graphics.setNewFont( "fonts/LCD_Solid.ttf", 50)
	initfont = love.graphics.setNewFont( "fonts/LCD_Solid.ttf", 50)
	bulletImg = love.graphics.newImage('images/bullet.png')
    background = love.graphics.newImage('images/8bitbg.jpg')
    initmusic= love.audio.newSource("sounds/gl.mp3","queue")
    battlemusic=love.audio.newSource("sounds/battle.mp3","queue")

    initmusic:setVolume(1)
    battlemusic:setVolume(0.3)


    --Variables del programa
    gameStart=false
    gameWon=false

    score=0
    level=1
    state="title"

    --Dimensiones de ventana
    winW=800
    winH=600

    --Creamos tablas de enemigo y jugador

    player={}
    player.image=love.graphics.newImage('images/8bitspacecraft.png')
    player.width, player.height = 32
    player.x= winW/2 - player.width
    player.y= winH - 50
    player.speed=600

    --Enemigos irán en grupo en el cielo
    enemies={}
     for j=0,2 do
        for i=0, 7 do
            enemy={}
            enemy.image=love.graphics.newImage('images/8bitalien.png')
            enemy.height= 32
            enemy.width = 32
            enemy.x = i * (enemy.width + 60) +100
            enemy.y = j * (enemy.height+100) +100
            enemy.speed=60
            table.insert(enemies,enemy)
            enemy.right=true  --Direccion en que se mueve
        end
    end
    --Colisiones o pared invisible del lado izquiero
    colIzq={}
    colIzq.x=-10
    colIzq.y=0
    colIzq.width=10
    colIzq.height=600
    colIzq.mode="fill"

    --Colisiones o pared invisible del lado derecho
    colDer={}
    colDer.x=winW+1
    colDer.y=0
    colDer.width=10
    colDer.height=600
    colDer.mode="fill"

    --Balas que disparará el personaje
    bullets={}

    --Referente a las balas y el personaje
    bOperative=true
    bCadenceMax=0.1
    bSpeed=100
    bCadence=bCadenceMax

end


function love.update(dt)    --dt==deltatime
    if state=="title" then
        love.audio.play(initmusic)
        if love.keyboard.isDown("return") then  --return == enter 
            state="play"
            gameStart=true
        end
    else
        love.audio.stop(initmusic)
        love.audio.play(battlemusic)
        bCadence=bCadence-dt
        if bCadence<0 then bOperative=true end

        --Movimiento y restricciones del jugador
        if love.keyboard.isDown("left") and player.x>=0 then player.x=player.x-player.speed*dt; end
        if love.keyboard.isDown("right") and player.x +player.width <= winW then player.x =player.x+player.speed*dt; end

        --Disparo de balas
        if love.keyboard.isDown("space") and bOperative then
        newBullet={x=player.x+(player.image:getWidth()/2),y=player.y,img=bulletImg}
        table.insert(bullets,newBullet)
        bOperative=false
        bCadence=bCadenceMax
        end
        
    --Movimiento, límites e interacciones de los enemigos
        
        --Inicio de enemigos y constancia
        for i,v in ipairs(enemies) do
            if v.x < colDer.x + colDer.width and colDer.x < v.x + v.width and v.y < colDer.y + colDer.height and colDer.y < v.y + v.height then
                --v.x >winW then    VERSION MAS ENTENDIBLE
                enemy.right=false
            end
            if v.x < colIzq.x + colIzq.width and colIzq.x < v.x + v.width and v.y < colIzq.y + colIzq.height and colIzq.y < v.y + v.height then
                --v.x < 0 then  VERSION MAS ENTENDIBLE
                enemy.right=true
            end

            --true ==> derecha
            --false ==> izquierda

            if enemy.right then v.x=v.x+enemy.speed*dt end
            if enemy.right == false then v.x=v.x-enemy.speed*dt end
        end

        --Constancia en el movimiento de las balas
        for i, bullet in ipairs(bullets) do
            bullet.y=bullet.y-(bSpeed*dt) --revisar por que es negativo
            if bullet.y<0 then
                table.remove(bullets,i)
            end
        end

        --Colisiones de las balas
        for i,enemy in ipairs(enemies) do
            for j,bullet in ipairs(bullets) do
                if CheckCollision(enemy.x,enemy.y,enemy.image:getWidth(),enemy.image:getHeight(),bullet.x,bullet.y,bulletImg:getWidth(),bulletImg:getHeight()) then
                    table.remove(bullets,j)
                    table.remove(enemies,i)
                    score=score+1 -- Recordad que no existe ++
                end
            end
        end
        
        --Comprobación de que no hay enemigos y aumento de nivel -- Finaliza el juego y se reinicia
        if not next(enemies) then
            love.audio.stop(battlemusic)
            love.audio.play(initmusic)
            level=level+1
            bSpeed=level+60 --revisar

            for i,bullet in ipairs(bullets) do
                table.remove(bullets)
                bOperative=false
                bCadence=bCadenceMax
            end

            for j=0,2 do
                for i=0,7 do
                    enemy={}
                    enemy.image=love.graphics.newImage('images/8bitalien.png')
                    enemy.width=32
                    enemy.height=32
                    enemy.x=i*(enemy.width+60)+100
                    enemy.y=j*(enemy.height+100)+100
                    enemy.speed=bSpeed+5
                    table.insert(enemies,enemy)
                    enemy.right=true
                end
            end
        end
    end




    function love.draw()
        if state == "title" then
            love.graphics.draw(background)
            love.graphics.setFont(initfont)
            love.graphics.setColor(255,0,0)
            love.graphics.print("Press enter to play",10,winH/2+200)
            love.graphics.setColor(255,255,255) --Reseteamos el color de teñido para que no afecte al fondo
        else
            --Configuración
            love.graphics.setFont(font)
            love.graphics.setColor(255,255,255,255)

            --Jugador y fondo
            love.graphics.draw(background)
            love.graphics.draw(player.image,player.x,player.y)

            --Bloques de colisión lateral
            love.graphics.rectangle(colDer.mode,colDer.x,colDer.y,colDer.width,colDer.height)
            love.graphics.rectangle(colIzq.mode,colIzq.x,colIzq.y,colIzq.width,colIzq.height)

            --Balas
            for i,bullet in ipairs(bullets) do
                love.graphics.draw(bulletImg,bullet.x,bullet.y)
            end

            --Enemigos
            for i,v in ipairs(enemies) do
                love.graphics.draw(enemy.image,v.x,v.y,0,v.width/32,v.height/32)  --El cero es la rotación de la imagen  https://love2d.org/wiki/love.graphics.draw
            end

            --Puntuacion y otros
            love.graphics.print("Score: "..score,10,5)
            love.graphics.setFont(levelfont)
            love.graphics.setColor(255,0,0)
            love.graphics.print("Level: "..level,winW/1.5,5)
        end

        if gameStart==true and level==2 then
            bOperative=false
            for bullet in pairs(bullets) do
                bullets[bullet]=nil
            end

            gameWon=true
            love.graphics.setColor(0,0,255)
            love.graphics.print("YOU WIN!",250,winH/2)
            love.graphics.print("Press enter to restart",10,winH/2+100)
            enemy.speed=180
            if love.keyboard.isDown("return") then 
                love.event.quit("restart")
            end
        end
    end
end