Coche ={velocidad =0,gasolina=false}

function Coche:new (o,v,g)
    o = o or {}
    setmetatable(o,self)
    self.__index=self
    self.velocidad=v or 0
    self.gasolina=g or false
    return o
end

function Coche:setVelocidad(v)
    self.velocidad=v
end

function Coche:setGasolina(b)
    self.gasolina=b
end

function Coche:getVelocidad()
    return self.velocidad 
end

function Coche:getGasolina()
    return self.gasolina 
end

c=Coche:new(nil,120,true)

print(c:getVelocidad())
c:setVelocidad(130)
print(c:getVelocidad())
print(c.velocidad)