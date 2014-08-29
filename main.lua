-----------------
--this shit build on magic numbers so dont change size, width,height,and other positionvariables 
----------------
size = 64 
width = 30
height = 30
tileHalfHeight = size * math.sqrt(2) / 4;
tileHalfWidth = size * math.sqrt(2) / 2;
magicYoffset = -360 
love.window.setTitle( "DDtriangles" )
helpmode = true
mutemode = false
click = love.audio.newSource("click.wav", "static")

function iso2screen(isoX,isoY)
    screenX = (isoX - isoY) * tileHalfWidth + love.graphics.getWidth()/2;
    screenY = (isoX + isoY) * tileHalfHeight + magicYoffset;
    return screenX, screenY
end
function screen2iso(screenX,screenY)
    adjScreenX = screenX - love.graphics.getWidth()/2
    adjScreenY = screenY - magicYoffset
    isoX = ((adjScreenY / tileHalfHeight) + (adjScreenX / tileHalfWidth)) / 2 ;
    isoY = ((adjScreenY / tileHalfHeight) - (adjScreenX / tileHalfWidth)) / 2;
    if (math.ceil(isoX) - isoX) <= 0.5 then  isoSide = 'b'
    else isoSide = 'a' end
    return math.ceil(isoX), math.ceil(isoY), isoSide
end
function love.update(dt)
    if love.mouse.isDown("l") then
        if not mutemode then love.audio.play(click) end
        ix,iy,is = screen2iso(love.mouse.getPosition())
        A[ix][iy][is].color = {math.random(0x22,0xff),math.random(0x22,0xff),math.random(0x22,0xff)}
    end
    if love.mouse.isDown("r") then
        if not mutemode then love.audio.play(click) end
        ix,iy,is = screen2iso(love.mouse.getPosition())
        local gray = math.random(0x22,0x33)
        A[ix][iy][is].color = {gray,gray,gray}
    end
end
function love.load()
    A={}
    for i=1, width do 
        A[i]={}
        for j=1, height do 
            x, y = i*size, j*size
            A[i][j]={}
            local gray = math.random(0x22,0x33)
            A[i][j].a = {
                color = {gray, gray, gray},
                color2 = {math.random(0x22,0x33),math.random(0x22,0x33),math.random(0x22,0x33)},
                position = {x, y, x + size, y + size, x, y + size},
            }
            local gray = math.random(0x22,0x33)
            A[i][j].b = {
                color = {gray, gray, gray},
                color2 = {math.random(0x22,0x33),math.random(0x22,0x33),math.random(0x22,0x33)},
                position = {x+size, y, x+size, y+size, x, y}
            }
        end
    end
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
    if key == "r" then
        love.load()
    end
    if key == "h" then
        if helpmode then helpmode = false else helpmode = true end
    end
    if key == "m" then
        if mutemode then mutemode = false else mutemode = true end
    end
end

function love.draw()
    love.graphics.push()
    love.graphics.scale( 1, 0.5 )
    --love.graphics.translate(love.graphics.getWidth()/2, love.graphics.getHeight()/2)
    love.graphics.translate(love.graphics.getWidth()/2, -810)
    love.graphics.rotate(math.pi / 4)
    for i=1, width do 
        for j=1, height do 
            love.graphics.setColor(A[i][j].a.color)
            love.graphics.polygon( 'fill', A[i][j].a.position )
            love.graphics.setColor(A[i][j].b.color)
            love.graphics.polygon( 'fill', A[i][j].b.position )
            --love.graphics.setColor(255,255,255)
            --love.graphics.print(i..":"..j, A[i][j].a.position[1],A[i][j].a.position[2])
        end
    end
    love.graphics.pop()
    love.graphics.setColor(255,55,55)
    --ox,oy = iso2screen(0,0)
    --love.graphics.circle('fill',ox,oy,1)
    --local x, y, s = screen2iso(love.mouse.getPosition())
    --local mx, my = love.mouse.getPosition()
    --love.graphics.print(x..":"..y.."("..s..")", 10, 10)
    --love.graphics.print(mx..":"..my, 10, 30)
    if helpmode then
        love.graphics.print("Just click and right-click on triangles", 10, 10)
        love.graphics.print("Press R to reset", 10, 30)
        love.graphics.print("Press M to mute/unmute", 10, 50)
        love.graphics.print("Press H to hide/show help", 10, 70)
    end
end
