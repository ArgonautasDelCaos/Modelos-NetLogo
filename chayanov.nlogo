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
