

:- dynamic pos_obj/2, pos_actual/1, alive/1, nivel_vida/2, ataque/2, defensa/2, num_obj/1.
:- retractall(pos_obj(_, _)), retractall(pos_actual(_)), retractall(alive(_)), retractall(ataque(_,_)), retractall(defensa(_,_)), retractall(num_obj(_)).

% puedes coger objetos sin matar a los monstruos. arreglar.
% swap armas para tener una sola arma en un momento dado.

score(old_value,0).

pos_actual(arbol_de_la_vida).
nivel_vida(guerrero,100).
nivel_vida(troll,100).
nivel_vida(espiritu,100).
alive(troll).
alive(espiritu).
num_obj(1).
inventario(X,4).


ataque(guerrero,100).
defensa(guerrero,100).

pos_obj(troll,cueva).
pos_obj(llave,casa_abandonada).
pos_obj(cofre,camara_del_tesoro).
pos_obj(anillo_legendario,cofre).
pos_obj(espada,monte_pico).
pos_obj(espiritu,casa_abandonada).
pos_obj(pocion_vida,pueblo).
pos_obj(cuchillo_peq,guerrero).
pos_obj(antorcha,molino_viento).
%el hacha es dropeado por el espiritu de la casa abandonada.

camino(entrada_cueva,norte,cueva):- pos_obj(antorcha,guerrero).
camino(entrada_cueva,norte,cueva):-
       write('No es buena idea entrar en la cueva sin una fuente de iluminacion'),nl,
       write(',seria mejor buscar alguna.'),nl,fail.
camino(entrada_cueva,este,montanas_legendarias).
camino(entrada_cueva,oeste,pueblo).
camino(entrada_cueva,sur,casa_abandonada).
camino(casa_abandonada,este,monte_olimpo).
camino(casa_abandonada,sur,arbol_de_la_vida).
camino(casa_abandonada,oeste,molino_viento).
camino(casa_abandonada,norte,entrada_cueva).
camino(molino_viento,norte,pueblo).
camino(molino_viento,este,casa_abandonada).
camino(arbol_de_la_vida,norte,casa_abandonada).
camino(monte_olimpo,norte,rio_sin_fin).
camino(monte_olimpo,oeste,casa_abandonada).
camino(monte_olimpo,este,monte_pico).
camino(monte_pico,sur,monte_olimpo).
camino(rio_sin_fin,norte,entrada_palacio).
camino(rio_sin_fin,sur,monte_olimpo).
camino(pueblo,sur,molino_viento).
camino(pueblo,este,entrada_cueva).
camino(cueva,sur,entrada_cueva).
camino(montanas_legendarias,este,entrada_palacio).
camino(montanas_legendarias,oeste,entrada_cueva).

camino(entrada_palacio,norte,palacio).
camino(entrada_palacio,oeste,montanas_legendarias).
camino(entrada_palacio,sur,rio_sin_fin).
camino(palacio,este,camara_del_tesoro).
camino(camara_del_tesoro,norte,cofre):- pos_obj(llave,guerrero).
camino(camara_del_tesoro,norte,cofre):- write('El cofre esta cerrado'),nl,fail.

comprobar_coger:-
      pos_actual(X),
      pos_obj(Y,X),
      Y = espiritu,
      alive(Y),
      write('Mata al monstruo antes de poder coger los objetos'),nl.
      
swap_armas(X):-
     X = hacha,
     pos_obj(cuchillo_peq,guerrero),
     retract(pos_obj(cuchillo_peq,guerrero)),
     pos_actual(Z),
     assert(pos_obj(cuchillo_peq,Z)),
     retract(num_obj(F)),
     A is F,
     B is A-1,
     assert(num_obj(B)),
     write('Se ha intercambiado cuchillo peq con '),write(X),nl,!;
     X = cuchillo_peq,
     pos_obj(hacha,guerrero),
     retract(pos_obj(hacha,guerrero)),
     pos_actual(Z),
     assert(pos_obj(cuchillo_peq,Z)),
     retract(num_obj(F)),
     A is F,
     B is A-1,
     assert(num_obj(B)),
     write('Se ha intercambiado hacha con '),write(X),nl,!;
     X = hacha,
     pos_obj(espada,guerrero),
     retract(pos_obj(espada,guerrero)),
     pos_actual(Z),
     assert(pos_obj(cuchillo_peq,Z)),
     retract(num_obj(F)),
     A is F,
     B is A-1,
     assert(num_obj(B)),
     write('Se ha intercambiado espada con '),write(X),nl,!;
     X = espada,
     pos_obj(hacha,guerrero),
     retract(pos_obj(hacha,guerrero)),
     pos_actual(Z),
     assert(pos_obj(cuchillo_peq,Z)),
     retract(num_obj(F)),
     A is F,
     B is A-1,
     assert(num_obj(B)),
     write('Se ha intercambiado hacha con '),write(X),nl,!;
     X = cuchillo_peq,
     pos_obj(espada,guerrero),
     retract(pos_obj(espada,guerrero)),
     pos_actual(Z),
     assert(pos_obj(cuchillo_peq,Z)),
     retract(num_obj(F)),
     A is F,
     B is A-1,
     assert(num_obj(B)),
     write('Se ha intercambiado espada con '),write(X),nl,!;
     X = espada,
     pos_obj(cuchillo_peq,guerrero),
     retract(pos_obj(cuchillo_peq,guerrero)),
     pos_actual(Z),
     assert(pos_obj(cuchillo_peq,Z)),
     retract(num_obj(F)),
     A is F,
     B is A-1,
     assert(num_obj(B)),
     write('Se ha intercambiado cuchillo_peq con '),write(X),nl,!.

coger(X):-
     swap_armas(X);
     retract(num_obj(F)),
     A is F,
     inventario(A,4),
     A < 4,
     pos_actual(Y),
     pos_obj(X,Y),
     retract(pos_obj(X,Y)),
     assert(pos_obj(X,guerrero)),
     write('Has cogido '),write(X),nl,nl,
     G is F+1,assert(num_obj(G)),
     G < 4,
     H is 4-G,
     write('Te quedan '),write(H),write(' espacios'),write(' en el inventario.'),nl,nl,!;
     retract(num_obj(F)),A is F,
     inventario(A,4),
     A=4,
     assert(num_obj(F)),
     write('El inventario esta lleno'),nl,
     write('Dropea algo!'),nl,!.

 coger(_):-
     write('No hay nada que coger!'),nl.

drop(X):-
     retract(num_obj(F)),
     G is F,
     G > 0,
     pos_obj(X,guerrero),
     pos_actual(Y),
     retract(pos_obj(X,guerrero)),
     assert(pos_obj(X,Y)),
     write('Se ha dropeado '),write(X),nl,
     H is G-1,
     K is 4-H,
     write('Te quedan '),write(K),write(' espacios'),write(' en el inventario.'),nl,nl,
     assert(num_obj(H)),nl,!;
     write('No hay nada que dropear!'),nl.
drop(_):-
     write('No hay nada que dropear!'),nl.
     
drops(X,Y):-
      pos_actual(Z),
      assert(pos_obj(Y,Z)),
      write(X),write(' ha dropeado '),write(Y),nl,!.

 drops(_):-
      write('No ha dropeado nada'),nl.
      
atacar :-
        pos_actual(cueva),
        pos_obj(troll,cueva),
        pos_obj(cuchillo_peq,guerrero),
        alive(troll),
        retract(ataque(guerrero,X)),
        Z is X+20,
        assert(ataque(guerrero,Z)),
        retract(defensa(guerrero,X)),
        Y is X-20,
        assert(defensa(guerrero,Y)),
        retract(nivel_vida(guerrero,X)),
        H is X-20,
        assert(nivel_vida(guerrero,H)),
        retract(nivel_vida(troll,X)),
        W is X-40,
        assert(nivel_vida(troll,W)),
        retract(score(old_score,X)),
        U is X+100,
        assert(score(old_score,U)),
        write('Intentas matarlo pero necesitarias un arma'),nl,
        write('mas potente.Sin embargo le has quitado vida'),nl,
        write('y te has vuelto mas fuerte!'),nl,
        write('+20 Ataque'),
        write('Pero el monstruo tambien te ha herido!'),
        write('Tu defensa y tu nivel de vida ha bajado!'),
        write('-20 DEF -20 VIDA'),
        ver_objeto(cueva),nl,!.

atacar :-
        pos_actual(cueva),
        pos_obj(troll,cueva),
        pos_obj(hacha,guerrero),
        alive(troll),
        retract(ataque(guerrero,X)),
        Z is X-30,
        assert(ataque(guerrero,Z)),
        retract(defensa(guerrero,X)),
        Y is X-10,
        assert(defensa(guerrero,Y)),
        retract(nivel_vida(guerrero,X)),
        H is X-10,
        assert(nivel_vida(guerrero,H)),
        retract(nivel_vida(troll,X)),
        W is X-70,
        assert(nivel_vida(troll,W)),
        write('Intentas matarlo pero necesitarias un arma'),nl,
        write('mas potente.Sin embargo le has quitado vida'),nl,
        write('y te has vuelto mas fuerte!'),nl,
        write('+30 Ataque'),
        write('Pero el monstruo tambien te ha herido!'),
        write('Tu defensa y tu nivel de vida ha bajado!'),
        write('-10 DEF -10 VIDA'),
        ver_objeto(cueva),nl,!.
atacar :-
        pos_actual(cueva),
        pos_obj(troll,cueva),
        pos_obj(espada,guerrero),
        alive(troll),
        retract(ataque(guerrero,X)),
        Z is X+50,
        assert(ataque(guerrero,Z)),
        retract(defensa(guerrero,X)),
        Y is X-5,
        assert(defensa(guerrero,Y)),
        retract(nivel_vida(guerrero,X)),
        H is X-10,
        assert(nivel_vida(guerrero,H)),
        retract(nivel_vida(troll,X)),
        W is X-100,
        assert(nivel_vida(troll,W)),
        retract(alive(troll)),
        retract(pos_obj(troll,cueva)),
        write('Has logrado matar al legendario troll.'),nl,
        write('Ha logrado quitarte un poco de vida pero'),nl,
        write('te has vuelto mas fuerte!'),nl,
        write('+50 Ataque'),
        write('Tu defensa y tu nivel de vida ha bajado!'),
        write('-5 DEF -10 VIDA'),
        ver_objeto(cueva),nl,!.
        
atacar :-
        pos_actual(casa_abandonada),
        pos_obj(espiritu,casa_abandonada),
        pos_obj(cuchillo_peq,guerrero),
        alive(espiritu),
        retract(ataque(guerrero,X)),
        Z is X+30,
        assert(ataque(guerrero,Z)),
        retract(defensa(guerrero,X)),
        Y is X-10,
        assert(defensa(guerrero,Y)),
        retract(nivel_vida(guerrero,X)),
        H is X-20,
        assert(nivel_vida(guerrero,H)),
        retract(nivel_vida(espiritu,X)),
        W is X-100,
        assert(nivel_vida(espiritu,W)),
        retract(alive(espiritu)),
        retract(pos_obj(espiritu,casa_abandonada)),
        write('Lograste matar al espiritu malvado de la casa'),nl,
        write('Conseguiste una mejora en tu ataque: +30 Ataque'),nl,
        write('El espiritu ha logrado quitarte un poco de vida y'),nl,
        write('tu defensa ha bajado.'),nl,
        write('-10 DEF -20 VIDA'),nl,nl,
        write('El espiritu tambien ha dropeado algo:.....'),nl,
        drops(espiritu,hacha),nl,
        ver_objeto(casa_abandonada),nl,!.

atacar :-
        pos_actual(casa_abandonada),
        pos_obj(espiritu,casa_abandonada),
        pos_obj(espada,guerrero),
        alive(espiritu),
        retract(ataque(guerrero,X)),
        Z is X+50,
        assert(ataque(guerrero,Z)),
        retract(defensa(guerrero,X)),
        Y is X-5,
        assert(defensa(guerrero,Y)),
        retract(nivel_vida(guerrero,X)),
        H is X-10,
        assert(nivel_vida(guerrero,H)),
        retract(nivel_vida(espiritu,X)),
        W is X-100,
        assert(nivel_vida(espiritu,W)),
        retract(alive(espiritu)),
        retract(pos_obj(espiritu,casa_abandonada)),
        write('Lograste matar al espiritu malvado de la casa'),nl,
        write('Conseguiste una mejora en tu ataque: +50 Ataque'),nl,
        write('El espiritu ha logrado quitarte un poco de vida y'),nl,
        write('tu defensa ha bajado.'),nl,
        write('-5 DEF -10 VIDA'),nl,
        write('El espiritu tambien ha dropeado algo:.....'),nl,
        drops(espiritu,hacha),
        ver_objeto(casa_abandonada),nl,!.
        
huir :-
        pos_actual(cueva),
        pos_obj(troll,cueva),
        alive(troll),
        retract(ataque(guerrero,X)),
        Z is X-20,
        assert(ataque(guerrero,Z)),
        retract(defensa(guerrero,X)),
        Y is X-10,
        assert(defensa(guerrero,Y)),
        retract(nivel_vida(guerrero,X)),
        H is X-15,
        assert(nivel_vida(guerrero,H)),
        write('Intentas huir del troll'),nl,
        write('Sin embargo al intentar huir se ha disminuido tu ataque,defensa y vida..'),nl,
        write('Perdiste 20 puntos de ataque'),nl,
        write('Perdiste 10 puntos de defensa'),nl,
        write('Perdiste 15 puntos de vida'),nl,!.
        
huir :-
        pos_actual(casa_abandonada),
        pos_obj(espiritu,casa_abandonada),
        alive(espiritu),
        retract(ataque(guerrero,X)),
        Z is X-10,
        assert(ataque(guerrero,Z)),
        retract(defensa(guerrero,X)),
        Y is X-5,
        assert(defensa(guerrero,Y)),
        retract(nivel_vida(guerrero,X)),
        H is X-10,
        assert(nivel_vida(guerrero,H)),
        write('Intentas huir del espiritu'),nl,
        write('Sin embargo al intentar huir se ha disminuido tu ataque,defensa y vida..'),nl,
        write('Perdiste 10 puntos de ataque'),nl,
        write('Perdiste 5 puntos de defensa'),nl,
        write('Perdiste 10 puntos de vida'),nl,!.

atacar :-
       write('No hay ningun enemigo alrededor para atacar'),nl.

huir :-
     write('No hay ningun enemigo del que huir'),nl.
     
pocion :-
     pos_obj(pocion_vida,guerrero),
     write('Se ha utilizado la pocion de vida'),nl,
     retract(nivel_vida(guerrero,X)),
     Y is X+50,
     assert(nivel_vida(guerrero,Y)),nl,
     retract(pos_obj(pocion_vida,guerrero)),!.

pocion :-
       write('No lleva encima una pocion de vida'),nl.

atq :-
    ataque(guerrero,X),
    write('Su nivel de ataque es: '),write(X),nl.
    
def :-
    defensa(guerrero,X),
    write('Su nivel de defensa es: '),write(X),nl.

vida :-
    nivel_vida(guerrero,X),
    write('Su nivel de vida es: '),write(X),nl.

inv :-
     write('Tienes en el inventario: '),nl,
     pos_obj(X,guerrero),
     write(X),nl.

norte :- move(norte).
sur :- move(sur).
este :- move(este).
oeste :- move(oeste).

move(X):-
    pos_actual(Y),
    camino(Y,X,Z),
    retract(pos_actual(Y)),
    assert(pos_actual(Z)),
    ver_entorno, !.

move(_):- write('No se puede mover por aqui'),nl.

ver_entorno:-
      pos_actual(X),
      texto(X),nl,
      ver_objeto(X),nl.

ver_objeto(X):-
      pos_obj(Y,X),
      write('Hay un '),write(Y), write( ' por aqui.'),nl,
      fail,!.

ver_objeto(_):- write('No hay ningun objeto interesante en esta vecinidad'),nl.

end_game :-
        retract(nivel_vida(guerrero,X)),
        assert(nivel_vida(guerrero,0)),
        pos_actual(X),
        write('Has muerto en '),write(X),nl,!.
        
comandos :-
    nl,
    write('Comandos disponibles:'),nl,
    write('start_game --> comenzar'),nl,
    write('comandos --> ver comandos del juego'),nl,
    write('norte | sur | este | oeste --> para moverse'),nl,
    write('atacar --> para atacar '),nl,
    write('ver_entorno --> para mirar en tu alrededor'),nl,
    write('huir --> para huir'),nl,
    write('atq --> para ver nivel de ataque'),nl,
    write('def --> para ver nivel de defensa'),nl,
    write('vida --> para ver nivel de vida'),nl,
    write('coger(X) --> para coger el objeto X'),nl,
    write('drop(X) --> para dropear el item X'),nl,
    write('pocion --> para utilizar pocion vida'),nl,
    write('inv --> ver inventario'),nl,
    write('end_game --> para salir del juego'),nl.
    
start_game :-
        retract(num_obj(F)),G is F,
        inventario(G,4),nl,
        assert(num_obj(F)),
        comandos,nl,
        ver_entorno.

texto(entrada_cueva):-
      write('Has llegado a una de las partes mas terorificas del mundo,'),nl,
      write('la entrada de la Cueva del Fuego.'),nl,
      write('Puedes ir hacia atras para llegar de nuevo a la casa abandonada'),nl,
      write('o hacia el norte para comenzar una aventura mas dentro de la cueva'),nl,
      write('hacia el este es el pueblo y hacia el oeste las'),nl,
      write('montañas legendarias.Elige tu camino'),nl.
      
texto(cueva):-
      write('Bien.Eres una persona valiente.Delante te esperaran muchos'),nl,
      write('desafios que te podran hacer temblar.Sigue delante para desafiar'),nl,
      write('al legendario troll o gira a la derecha/izquierda para coger otros caminos'),nl,
      write('donde te esperaran otras sorpresas.Hacia atras es la opcion menos valiente.'),nl.
      
texto(entrada_palacio):-
      write('Delante se ve un imponente palacio del siglo IV.Hay unos guardias que parecen'),nl,
      write('no prestar atencion a su entorno.La historia cuenta de que aqui se encuentra'),nl,
      write('un tesoro unico en todo el reino.Si decides seguir el camino hacia delante'),nl,
      write('podras explorar este impresionante edificio.Si no puedes volver hacia atras'),nl,
      write('Hacia el oeste se ven las montañas legendarias y hacia el este el bosque'),nl,
      write('de la oscuridad.Elige tu camino.'),nl.
      
texto(palacio):-
      write('Logras entrar en ese magnifico edificio.Has hecho bien.Se dice que en la parte'),nl,
      write('este del edificio se encuentra la camara del tesoro.Puedes ir a otros lados para'),nl,
      write('explorar pero ande con cuidado porque los peligros estan a todo paso.'),nl.
      
texto(camara_del_tesoro):-
      pos_obj(llave,guerrero),
      write('Has encontrado la camara del tesoro!.Delante ves el cofre legendario del Rey David'),nl,
      write('El Magnifico.No parece que haya otros caminos a otras habitaciones.'),nl,
      pos_obj(anillo_legendario,cofre),nl,
      retract(pos_obj(llave,guerrero)),
      retract(pos_obj(anillo_legendario,cofre)),
      retract(pos_obj(cofre,camara_del_tesoro)),
      write('Has obtenido el anillo legendario del Rey David !'),nl.
 
texto(camara_del_tesoro):-
      write('Has encontrado la camara del tesoro!.Delante ves el cofre legendario del Rey David'),nl,
      write('El Magnifico.No parece que haya otros caminos a otras habitaciones.'),nl,nl,
      pos_obj(llave,X), X \= guerrero,
      write('No tienes la llave para abrir el cofre'),nl.
      
texto(rio_sin_fin):-
      write('Has llegado al rio.Parece muy profundo.Puedes intentar cruzarlo nadando aunque'),nl,
      write('se dice que muchos guerreros no lo han sobrevivido.Es tu eleccion.Procede hacia el'),nl,
      write('norte para llegar al palacio.Hacia atras vuelves al Monte Olimpo.Mirando a tu '),nl,
      write('derecha o izquierda solo se ve llanura'),nl.
      
texto(monte_olimpo):-
      write('Has llegado a la base del monte.Parece que hay una ruta hacia el este que te lleva'),nl,
      write('al pico.Puedes decidir seguir esa ruta o seguir hacia el norte para llegar al rio sin fin'),nl,
      write('Hacia el oeste se puede ver una casa abandonada, no habitada.Hacia el sur lo unico que se ve'),nl,
      write('es mas llanura.'),nl.
      
texto(arbol_de_la_vida):-
      write('Este es punto de inicio de tu aventura.Este magnifico arbol lleva aqui 300 años creciendo'),nl,
      write(',hacia el norte se puede ver la casa abandonada que no parece habitada.Este es el unico camino'),nl,
      write('que se puede coger.'),nl.

texto(casa_abandonada):-
     write('Has llegado a la casa abandonada de la familia Thompson.Estos abandonaron la casa hace mas de'),nl,
     write('de un siglo por motivos de la muerte tragica de uno de los miembros.Desde entonces un espiritu'),nl,
     write('maligno anda por la casa.Puedes ir hacia el oeste para entrar en la casa.Si sigues hacia delante'),nl,
     write('a la cueva.Hacia el este se ve el Monte Olimpo.Hacia el oeste se ve el viejo molino de viento.Tambien puedes volver'),nl,
     write('hacia atras para llegar al arbol de la vida'),nl.
     
texto(pueblo):-
     write('Este pueblo de aproximadamente 300 habitantes esta cerca de una legendaria cueva.Hay un camino hacia el'),nl,
     write('este que te lleva a ella.Hacia el sur se puede ver el viejo molino de viento.No hay otros caminos'),nl.
     
texto(molino_viento):-
     write('Has llegado al viejo molino de viento.Este se sigue utilizando por los habitantes del pueblo que esta justo'),nl,
     write('al norte.Puedes ir de nuevo hacia el este para llegar a la casa abandonada.No hay otros caminos posibles'),nl.

texto(montanas_legendarias):-
     write('Has logrado llegar a la base de estas montañas legendarias.Estas estan justo entre la cueva y el palacio.'),nl,
     write('puedes seguir adelante para explorarlos.Hay un camino hacia el este que te lleva al palacio y uno hacia el oeste'),nl,
     write('que te lleva a la cueva.'),nl.

texto(monte_pico):-
     write('Has llegado al pico de la montaña despues de un largo camino.De aqui puedes ver todo a tu alrededor.Puedes volver'),nl,
     write('hacia atras para llegar a la base de la montaña.Otros caminos no son posibles'),nl.



