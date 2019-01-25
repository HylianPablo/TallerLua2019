-- Función que detecta colisiones.
-- Devuelve true si se superponen dos elementos y false en caso contrario
-- x1,y1 son las coordenadas del primer elemento, mientras que w1,h1 son la anchura y la altura
-- x2,y2,w2 & h2 son las correspondientes al segundo elemento
-- Credit: https://www.github.com/becauseimgray/Invaders
function CheckCollision(x1,y1,w1,h1, x2,y2,w2,h2)
  return x1 < x2+w2 and
         x2 < x1+w1 and
         y1 < y2+h2 and
         y2 < y1+h1
end