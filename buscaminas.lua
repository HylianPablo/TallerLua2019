--IMPLEMENTACION DE BUSCAMINAS EN LUA

Tablero={filas=0,columnas=0,minas=0,matrix ={},oculta={}}

function Tablero:new (o,f,c,m)
    o = o or {}
    setmetatable(o,self)
    self.__index=self
    self.filas=f or 0
    self.columnas=c or 0
    self.minas=m or 0
    for i=1, f do
        self.matrix[i]={}
        self.oculta[i]={}
        for j=1, c do
            local var = math.random(1,10)
            if var%7==0 then
                var=1
            else
                var=0
            end
            self.matrix[i][j]=var
            self.oculta[i][j]=99
        end
    end
    return o
end

function Tablero:getLado()
    return self.filas
end

function Tablero:imprimeTablero()
    for i=1, self.filas do
        for j=1, self.columnas do
            io.write(tostring(self.matrix[i][j]).." ")
        end
        print("")
    end
end

function Tablero:imprimeTableroOculto()
    for c=1,self.columnas do
        if c==1 then
            io.write("   "..c)
        else
            io.write(" "..c)
        end
    end
    print(" ")
    print(" ")
    for i=1,self.filas do
        for j=1,self.columnas do
            if j==1 then
                io.write(i.."  ")
                if self.oculta[i][j]==99 then
                    io.write(tostring('#'.." "))
                else
                    io.write(tostring(self.oculta[i][j].." "))
                end
            else
                if self.oculta[i][j]==99 then
                    io.write(tostring('#'.." "))
                else
                    io.write(tostring(self.oculta[i][j].." "))
                end
            end
        end
        print("")
    end
end

function Tablero:mirarCoordenadas(coor)
    local a = coor[1]
    local b = coor[2]
    self.oculta[a][b]=self.matrix[a][b]
    if self.oculta[a][b]==0 then 
        self.oculta[a][b]=Tablero:mirarAlrededor(a,b)
    end
    Tablero:actualizarAlrededor(a,b)
end

function Tablero:actualizarAlrededor(a,b)
    if a~=1 and a~=Tablero:getLado() and b~=1 and b~=Tablero:getLado() then
        if self.matrix[a-1][b-1]~=1 then
            self.oculta[a-1][b-1]=Tablero:mirarAlrededor(a-1,b-1)
        end
        if self.matrix[a-1][b]~=1 then
            self.oculta[a-1][b]=Tablero:mirarAlrededor(a-1,b)
        end
        if self.matrix[a-1][b+1]~=1 then
            self.oculta[a-1][b+1]=Tablero:mirarAlrededor(a-1,b+1)
        end
        if self.matrix[a][b-1]~=1 then
            self.oculta[a][b-1]=Tablero:mirarAlrededor(a,b-1)
        end
        if self.matrix[a][b+1]~=1 then
            self.oculta[a][b+1]=Tablero:mirarAlrededor(a,b+1)
        end
        if self.matrix[a+1][b-1]~=1 then 
            self.oculta[a+1][b-1]=Tablero:mirarAlrededor(a+1,b-1)
        end
        if self.matrix[a+1][b]~=1 then
            self.oculta[a+1][b]=Tablero:mirarAlrededor(a+1,b)
        end
        if self.matrix[a+1][b+1]~=1 then
            self.oculta[a+1][b+1]=Tablero:mirarAlrededor(a+1,b+1)
        end
    end
end

function Tablero:mirarAlrededor(a,b)
    local contador = 0
    if a~=1 and a~=Tablero:getLado() and b~=1 and b~=Tablero:getLado() then
        if self.matrix[a-1][b-1]==1 then
            contador=contador+1
        end
        if self.matrix[a-1][b]==1 then
            contador=contador+1
        end
        if self.matrix[a-1][b+1]==1 then
            contador=contador+1
        end
        if self.matrix[a][b-1]==1 then
            contador=contador+1
        end
        if self.matrix[a][b+1]==1 then
            contador=contador+1
        end
        if self.matrix[a+1][b-1]==1 then
            contador=contador+1
        end
        if self.matrix[a+1][b]==1 then
            contador=contador+1
        end
        if self.matrix[a+1][b+1]==1 then
            contador=contador+1
        end
    end
    return contador
end

function Tablero:coordenadaEsMina(coor)
    local a =coor[1]
    local b=coor[2]
    if self.matrix[a][b]==1 then
        return true
    end
    return false
end

--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

partida = true

while partida do

    print("***BUSCAMINAS***")
    print("1-Principiante 9x9, 10 minas")
    print("2-Intermedio 16x16, 40 minas")
    print("3-Salir")

    print("")
    repeat
        print("Introduzca opción: ")
        modo =io.read("n")
    until modo==1 or modo==2 or modo==3 
    
    if modo == 1 then
        tab=Tablero:new(nil,9,9,10)
    elseif modo==2 then
        tab=Tablero:new(nil,16,16,40) 
    else  
        partida=false
    end

    if modo ~= 3 then
        turno =false
        tab:imprimeTableroOculto()
        print(" ")
        while not turno do 
            print("Introduzca coordenadas")
            print("")
            coordenadas={}
            for i=1,2 do
                coordenadas[i]=io.read("n")
                while coordenadas[i]<1 or coordenadas[i]>Tablero:getLado() do
                    print("Coordenada errónea. Por favor vuelva a introducir.")
                    coordenadas[i]=io.read("n")
                end
            end
            tab:mirarCoordenadas(coordenadas)
            turno=tab:coordenadaEsMina(coordenadas)
            tab:imprimeTableroOculto()
            print("")
        end
        print("")
        tab:imprimeTablero()
    end

    print("")
end
