;;
;;Variables
globals [food-supply breed-time]
turtles-own [need age exhaustion satisfaction]
breed [men man]
breed [women woman]
directed-link-breed [parenthood parent]
undirected-link-breed [alliance ally]

;;Buttons
to Preparar
  clear-all
  setup-turtles
  reset-ticks
  setup-patches
  set food-supply 0
end

to setup-patches
  ask patches[
    set pcolor green
    ]
end
to setup-turtles
  create-men 1
  ask men [set color blue set shape "person" set xcor -1 set age 25]
  create-women 1
  ask women [set color pink set shape "person" set age 20 create-alliance-with men]
  ask turtles [
   ifelse mostrar-edad
    [set label age]
    [set label ""]
  ]
end

to avanzar-uno
  tick
  ask turtles [set need need + 1]
  work
  consume
  grow-old
  reproduce
  decease
end
to Correr
  tick
  ask turtles [set need need + necesidad-anual]
  work
  consume
  grow-old
  reproduce
  decease
end

;;Procedures

to work
  ask turtles [
    if age >= inserción-laboral and age <= retiro and food-supply <= 0 [
    set food-supply food-supply + (((sum [need] of turtles) * precios))
    set exhaustion exhaustion + (sum [need] of turtles)
    set satisfaction satisfaction - (sum [need] of turtles)
    ]]
end

to consume
  ask turtles [
   if food-supply > 0 and need > 0 [
     set food-supply food-supply - need
     if exhaustion > 0 [set exhaustion exhaustion - need]
     if satisfaction < 0 [set satisfaction satisfaction + need]
     set need need - need]
  ]
end

to grow-old
 ask turtles [
  set age age + 1
  ifelse mostrar-edad
    [set label age]
    [set label ""]
 ]
end

to place-in-empty
    move-to one-of (patches with [not any? turtles-here])
end

to reproduce
  set breed-time breed-time + 1
  if breed-time >= hijo-cada-tantos-años [
    set breed-time 0
    ask woman 1
    [if any? alliance and count turtles < máximo-hijos + 2 [
      let chance random 2
      if chance = 0 [hatch-men 1[set shape "person" set color blue set age 0 place-in-empty]]
      if chance = 1 [hatch-women 1 [set shape "person" set color pink set age 0 place-in-empty]]
      ]]]
end

to decease
  ask turtles [
    if need = (necesidad-anual * 2) [die]
    if age = esperanza-de-vida [die]]
end
@#$#@#$#@
GRAPHICS-WINDOW
243
22
526
326
10
10
13.0
1
10
1
1
1
0
1
1
1
-10
10
-10
10
1
1
1
ticks
30.0

BUTTON
28
23
95
56
NIL
Correr
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
0

BUTTON
121
24
201
57
NIL
Preparar
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SWITCH
673
11
804
44
mostrar-edad
mostrar-edad
0
1
-1000

BUTTON
29
72
132
105
NIL
Avanzar-uno
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
0

MONITOR
526
22
675
67
Años desde el último hijo
breed-time
17
1
11

PLOT
0
353
200
503
Gráfico 1-1
Años
Cantidad
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"Consumidores" 1.0 0 -2674135 true "" "plot count turtles"
"Productores" 1.0 0 -16449023 true "" "plot count turtles with [age >= 15]"
"% C/T" 1.0 0 -13840069 true "" "plot count turtles / count turtles with [age >= 15]"

SLIDER
30
118
202
151
máximo-hijos
máximo-hijos
0
100
12
1
1
NIL
HORIZONTAL

MONITOR
526
70
605
115
Reserva
food-supply
17
1
11

PLOT
630
353
830
503
Gráfico 2-3
Time
NIL
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"Fatiga" 1.0 0 -2674135 true "" "plot [exhaustion] of man 0"
"Satisfacción" 1.0 0 -13840069 true "" "plot [satisfaction] of man 0"
"Reserva" 1.0 0 -1184463 true "" "plot food-supply"

SLIDER
30
159
202
192
esperanza-de-vida
esperanza-de-vida
0
100
80
1
1
NIL
HORIZONTAL

SLIDER
30
200
217
233
hijo-cada-tantos-años
hijo-cada-tantos-años
0
50
3
1
1
NIL
HORIZONTAL

SLIDER
532
144
704
177
inserción-laboral
inserción-laboral
0
100
15
1
1
NIL
HORIZONTAL

SLIDER
532
184
704
217
Retiro
Retiro
0
100
70
1
1
NIL
HORIZONTAL

PLOT
200
353
400
503
Proporción C/T
Time
Relación consumidor-trabajador
0.0
10.0
0.0
1.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "plot count turtles / count turtles with [age >= 15]"

SLIDER
532
225
704
258
precios
precios
0.01
10
1.6
0.01
1
NIL
HORIZONTAL

SLIDER
30
241
202
274
necesidad-anual
necesidad-anual
0
10
1
0.01
1
NIL
HORIZONTAL

PLOT
418
353
618
503
Necesidades
NIL
NIL
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"Padre" 1.0 0 -16777216 true "" "plot [need] of man 0"
"Familia" 1.0 0 -7500403 true "" "plot sum [need] of turtles"

@#$#@#$#@
# ¿Qué es?

Es un modelo basado en agentes basado en los estudios sobre el campesinado ruso durante los años '20 del siglo XX de Aleksandr Vasílievich Chayánov y la Escuela de Organización y Producción.
En "La Organizacion de La Unidad Economica Campesina" el autor plantea que "la composición y el tamaño de la familia determinan íntegramente el monto de fuerza de trabajo, su composición y el grado de actividad". A lo largo del texto demuestra estadísticamente ese postulado.
El objetivo de este modelo es simular el desarrollo de una unidad doméstica tal como lo explica Chayánov, poniendo en funcionamiento variables semejantes.


# ¿Cómo funciona?
Este modelo comienza con un matrimonio de un hombre y una mujer, con 25 y 20 años respectivamente, quiénes son productores y a la vez consumidores de sus bienes de subsistencia. A medida que pasa el tiempo (siendo 1 tick = 1 año) van naciendo hijos, factor que fuerza a los adultos a trabajar más.


# ¿Cómo usarlo?
## Botones
1) Preparar: Dispone las variables y los agentes en el punto de inicio
2) Avanzar-uno: Itera el sistema 1 vez, es decir, avanza un año en el desarrollo
3) Correr: Da inicio a la simulación por un tiempo indeterminado. Suele terminar al morir uno de los padres

## Valores
### DE LOS AGENTES
1) Edad: Años vividos por un agente
2) Necesidad: Cantidad de unidades de recursos que va a consumir un agente por año, si no se satisface, el agente muere
3) Fatiga: Cantidad de desgaste físico insumido por el trabajo (Mínimo = 0)
4) Satisfacción: Medida del bienestar del agente (Máximo = 0)

### GLOBALES
1) Reserva: Recursos disponibles producidos y consumidos por la familia
2) Años desde el último hijo: Intervalo entre el año presente y el año de nacimiento del último hijo, marca el momento en el que nacerá el próximo de acuerdo a la variable (3)

# Deslizadores (Variables)
1) Máximo-hijos: Cantidad de hijos en la que dejarán de nacer más
2) Esperanza-de-vida: Edad a la que fallece un agente
3) hijo-cada-tantos-años: Intervalo de tiempo en el que nace un nuevo hijo (En el modelo original de Chayánov este valor es de 3 (Chayánov, Cap. 1, p. 59))
4) Necesidad-anual: Cantidad de recursos que consume un agente
5) inserción-laboral: Edad a la que empieza a trabajar una persona (En el modelo original de Chayánov este valor es de 15 (Chayánov, Cap. 1, p. 55))
6) Retiro: Edad a la que una persona deja de trabajar
7) Precios: Multiplicador. Cantidad de producto (reserva) producida por unidad de trabajo (Fatiga).

# Gráficos
1-1) Cantidad de consumidores, trabajadores y la proporción entre unos y otros
Proporción C/T: Ampliación del 1-1. Solo muestra la proporción entre consumidores y trabajadores
2-3) Toma los valores del padre de familia. Mide la cantidad de trabajo que realida (fatiga) y su satisfacción, superpuestas ambas a las oscilaciones en la reserva de recursos
Necesidades: Mide la necesidad del padre de familia superpuesta a la de toda la familia en conjunto

# Cosas a observar

A lo que debeponérsele más atención es a los valores cuantitativos expresados en los gráficos. Puede verse una correspondencia entre el trabajo realizado por el padre (que es igual al de la madre) y la proporción del cuadro C/T. En el período de crecimiento estos valores empiezan a cambiar exponencialmente, pero al acercarse a la vejez, cuando todos los hijos llegan a la edad en que trabajan, los valores tienden a estabilizarse.


# Cosas a probar

Modificar las variables puede mostrarnos cómo se comportarían los agentes en casos extremos y, al hacerlo, puede ilustrar ciertas tendencias que pasan desapercibidas en contextos normales.
Si prolongamos la vida y el período en el cual trabajan los individuos en una gran cantidad, podemos ver que en su segundo ciclo de vida, la necesidad y satisfacción del padre llegan a 0, es decir, al punto muerto en el cual el agente ya no necesita esforzarse demasiado para mantenerse a sí mismo y a su familia, por lo cual deja de producir. Esto no es visible en un período normal de vida, dado que la fatiga e insatisfacción acumuladas durante los años en los que tuvo que mantener a sus hijos no llegan a disolverse antes del fin de la vida de los padres.
Asimismo, es posible notar la regla explicada por Chayánov según la cual a menor precio, mayor productividad por parte de los trabajadores, dado que los agentes aquí no buscan elevar sus reservas, sino que éstas lleguen a cubrir las necesidades de la familia.

# Notas

Todos los productores producen y consumen la misma cantidad (1) de rexursos, en lugar de los valores propuestos por Chayánov.

# Créditos y referencias

Leopoldo Bebchuk, Facultad de Filosofía y Letras, Universidad de Buenos Aires. 26/06/2016

Bibliografía:
-Chayánov, Alexander V. La organización de la unidad económica campesina. Ediciones Nueva Visión, Buenos Aires, 1985
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270

@#$#@#$#@
NetLogo 5.1.0
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180

@#$#@#$#@
0
@#$#@#$#@
