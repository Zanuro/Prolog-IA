

:- dynamic pos_obj/2, pos_actual/1, alive/1, nivel_vida/2.
:- retractall(at(_, _)), retractall(i_am_at(_)), retractall(alive(_)).

pos_actual(entrada_cueva).
pos_actual(cueva).
pos_actual(casa_abandonada).
pos_actual(entrada_palacio).
pos_actual(monte_olimpo).
pos_actual(palacio).

look_around(sitio).
drops(espiritu,hacha).

nivel_vida(guerrero,X).
nivel_vida(troll,X).
ataque(guerrero,X).
defensa(guerrero,X).
alive(troll).
alive(espiritu).
pos_obj(troll,cueva).
pos_obj(llave,casa_abandonada).
pos_obj(cofre,palacio).
pos_obj(espada,hoyo).
pos_obj(espiritu,casa_abandonada).

atacar :-
        pos_actual(cueva),
        pos_obj(cuchillo_peq,pers),
        alive(troll),
        ataque(guerrero,X+10),
        write('Intentas matarlo pero necesitarias un arma'),nl,
        write('mas potente.Sin embargo le has quitado vida'),nl,
        write('y te has vuelto mas fuerte!'),nl,
        write('+10 Ataque'),nl,!.
atacar :-
        pos_actual(casa_abandonada),
        pos_obj(cuchillo_peq,pers),
        retract(alive(espiritu)),
        ataque(guerrero,X+50),

        write('Lograste matar al espiritu malvado de la casa'),nl,
        write('Conseguiste una mejora en tu ataque: +50 Ataque'),nl,
        write('El espiritu tambien ha dropeado algo:.....'),nl,
        write('Conseguiste un hacha!'),nl,
        look_around(casa_abandonada),
        write('Mirando por el alrededor de la casa conseguiste una llave!'),nl,!.

huir :-
        pos_actual(cueva),
        alive(troll),
        ataque(guerrero,X-20),
        write('Intentas huir del troll'),nl,
        write('Sin embargo al intentar huir se ha disminuido tu ataque..'),nl,
        write('Perdiste 20 puntos de ataque'),nl,!.

atacar :-
       write('No hay ningun enemigo alrededor para atacar').


norte :- move(norte).
sur :- move(sur).
este :- move(este).
oeste :- move(oeste).

end_game :-
        nivel_vida(guerrero,0),
        pos_actual(X),
        write('Has muerto en la '),write(X),nl,!.

start_game :-
        nivel_vida(guerrero,100),
        comandos,
        look.
comandos :-
    nl,
    write('Comandos disponibles:'),nl,
    write('start_game -->comenzar'),nl,
    write('comandos -->ver comandos del juego'),nl,
    write('norte | sur | este | oeste --> para moverse'),nl,
    write('atacar --> para atacar '),nl,
    write('look --> para mirar en tu alrededor'),nl,
    write('huir --> para huir'),nl,
    write('finish --> para salir del juego'),nl.

move(X):-
    pos_actual(Y),
    camino(Y,X,Z),
    look_around(Y), !.

move(_):- write('No se puede mover por aqui').


texto(entrada_cueva):-
      write('Has llegado a una de las partes mas terorificas del mundo'),nl,
      write('Puedes ir hacia atras para llegar de nuevo a las llanuras'),nl,
      write('o hacia el norte para comenzar una aventura mas'),nl,
      write('hacia el este es el pueblo y hacia el oeste las'),nl,
      write('montañas legendarias.Elige tu camino'),nl.
texto(cueva):-
      write('Bien.Eres una persona valiente.Delante te esperaran muchos'),nl,
      write('desafios que te podran hacer temblar.Sigue delante para desafiar'),nl,
      write('al legendario troll o gira a la derecha/izquierda para coger otros caminos'),nl,
      write('donde te esperaran otras sorpresas.Hacia atras es la opcion menos valiente.'),nl.



















