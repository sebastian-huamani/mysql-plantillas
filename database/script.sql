create table Contactos(
    id int auto_increment not null , 
    nombre varchar(60) not null,
    apellido varchar(60) not null,
    direccion varchar(255) not null,
    telefono varchar(9) not null,
    correo varchar(255) not null,
    fecha_nacimiento date default null,
    familia tinyint default null,
    unique key telefono_unique(telefono),
    unique key correo_unique(correo),
    index(apellido(20)),
    index(direccion(30)),
    index(telefono),
    index(correo(20)),
    index(fecha_nacimiento),
    index(familia),
    primary key(id)
);

create table reuniones(
    id int auto_increment not null,
    fecha_hora datetime not null,
    lugar varchar(60) not null,
    contacto_id int not null,
    primary key(id),
    constraint fk_reunion_contacto foreign key(contacto_id) references Contactos(id)
);

create table test (id int , primary key(id)); 

alter table Contactos add FULLTEXT(nombre, apellido, direccion);


-- insercciones:
insert into Contactos(nombre, apellido,direccion, telefono, correo, fecha_nacimiento , familia) values('canela','Tassara','tarata 289','941122784','canela@gmaial.com','2000-01-08',4),
('oregano','Gonzales','La republica 1542','914455782','oregano@gmaial.com','2000-02-16',2),
('pimienta','Rival','Las flores 985','963366523','pimienta@gmaial.com','2001-03-22',5),
('salsa','Orden','Los jertrudis 953','984455125','salsa@gmaial.com','2001-03-22',5);

insert into Reuniones(fecha_hora, lugar, contacto_id) values
('2021-01-08 11:30','sala Nº 1', 1),
('2021-01-09 12:30','sala Nº 1', 2),
('2021-01-08 11:30','sala Nº 1', 3),
('2021-01-08 16:30','sala Nº 3', 3),
('2021-01-08 16:30','sala Nº 3', 4),
('2021-01-08 16:30','sala Nº 3', 1);


-- PROCEDURES

DELIMITER $$
drop procedure if exists contar_usuarios$$
create procedure contar_usuarios(IN nombre varchar(50), OUT total int unsigned)
begin
    set total = (
        select count(*) 
        from Contactos 
        where Contactos.nombre = nombre);
end
$$

CALL contar_usuarios('canela', @total);
select @total;

-- FUNCIONES
-- registrar nuevo usuario

DELIMITER $$
drop function if exists nuevo_usuario$$
create function nuevo_usuario( 
    nombre varchar(60) ,
    apellido varchar(60) ,
    direccion varchar(255) ,
    telefono varchar(9) ,
    correo varchar(255) ,
    fecha_nacimiento date ,
    familia tinyint )
    returns varchar(10)

begin 
    declare respuesta varchar(10);
    set respuesta = "recibido"; 

    insert into Contactos(nombre, apellido,direccion, telefono, correo, fecha_nacimiento , familia) values(nombre,apellido,direccion,telefono,correo,fecha_nacimiento,familia);

    return respuesta;
end
$$
     
select nuevo_usuario('jorge','Salsedo','jr. pilares 953','945522145','jorge@gmaial.com','2001-03-22',3);

-- eliminar usuario

DELIMITER $$
drop function if exists eliminar_usuario$$
create function eliminar_usuario(nombre varchar(60))
    returns varchar(30) 
begin
    declare respuesta varchar(30);
    declare total int unsigned;

    set total= (
        select count(*) 
        from Contactos 
        where Contactos.nombre = nombre);
    
    if total < 2 then
        delete from Contactos where Contactos.nombre = nombre;
        set respuesta = "realizado";
        return respuesta;
    end if;

    if total > 1 then
        set respuesta = "nombre repetido";
        return respuesta;
    end if;
end
$$

select eliminar_usuario('jorge');
-- MANEJO DE ERRORES

DELIMITER $$
drop procedure if exists handle$$
create or replace procedure handler()
begin
    DECLARE continue HANDLER FOR SQLSTATE '23000' SET @x = 1;
    SET @x = 1;
    INSERT INTO test VALUES (1);
    SET @x = 2;
    INSERT INTO test VALUES (1);
    SET @x = 3;
end $$

CALL handler();
SELECT @x; 

-- transacciones
DELIMITER $$
drop procedure if exists transaccion_mysql$$
create procedure transaccion_mysql()
begin
    declare respuesta varchar(30);
    declare exit HANDLER FOR SQLEXCEPTION, SQLWARNING
    begin
        set respuesta = "error";
        rollback;
    end;

    start transaction;
        insert into Contactos(nombre, apellido,direccion, telefono, correo, fecha_nacimiento , familia) values('jorge','Salsedo','jr. pilares 953','945522145','jorge@gmaial.com','2001-03-22',3);
    commit;
end
$$

CALL transaccion_mysql();


-- CURSORES 
DELIMITER $$
drop trigger if exists trigger_update_familia_before$$
create trigger trigger_update_familia_before
before update
on Contactos for each row
begin   
    if new.familia < 0 then
        set new.familia = 0;
    elseif new.familia > 6 then 
        set new.familia = 6;
    end if;
end
$$

DELIMITER $$
drop trigger if exists trigger_insert_familia_before$$
create trigger trigger_insert_familia_before
before insert
on Contactos for each row
begin   
    if new.familia < 0 then
        set new.familia = 0;
    elseif new.familia > 6 then 
        set new.familia = 6;
    end if;
end
$$


insert into Contactos(nombre, apellido,direccion, telefono, correo, fecha_nacimiento , familia) values('Jimena','Oraculo','calle sombra 1535','995624584','jimena@gmaial.com','2002-02-08',-1);