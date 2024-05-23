use proyecto_alonsomauricio;

/*
El primer Stored Procedure ordena una tabla mediante el campo, de forma ascendente o descendente.

Lo que se completa en los parámetros nombre de tabla, campos y críterio de ordenamiento (ASC o DESC) es a elección del usuario.  

EJEMPLOS:

use proyecto_alonsomauricio;

CALL OrdenarTabla('empresa', 'nombre_soc', 'ASC');
CALL OrdenarTabla('asesor', 'nombre_asesorcalcular_estadisticas_por_estado', 'DESC');
CALL OrdenarTabla('bancos', 'idbanco', 'DESC');

*/

DELIMITER //

DROP PROCEDURE IF EXISTS OrdenarTabla;
CREATE PROCEDURE OrdenarTabla(
    IN tabla_nombre VARCHAR(100),
    IN ordenar_por VARCHAR(100),
    IN orden VARCHAR(10)
)
BEGIN
    SET @query = CONCAT('SELECT * FROM ', tabla_nombre, ' ORDER BY ', ordenar_por, ' ', orden);
    PREPARE stmt FROM @query;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END //

DELIMITER ;


/*
El segundo Stored Procedure gestiona la tabla bancos, agregando o eliminando bancos.


EJEMPLO PARA AGREGAR UN BANCO:

use proyecto_alonsomauricio;
SET @resultado = '';

CALL GestionarBancos('insertar', 'Banca Almafuerte', NULL, @resultado);
SELECT @resultado;

-- se debe declarar la variable resultado antes de correr el CALL. La función tiene que llevar el parámetro ´insertar´
-- para diferenciar del ´eliminar´. Luego viene el nombre del banco. El campo NULL es porque no se toma un id ya cargado.

EJEMPLO PARA ELIMINAR UN BANCO

use proyecto_alonsomauricio;
SET @resultado = '';

CALL GestionarBancos('eliminar', NULL, 20, @resultado);
SELECT @resultado;

-- se debe declarar la variable resultado antes de correr el CALL. La función tiene llevar el parámetro ´eliminar´
-- para diferenciar del ´insertar´. Luego NULL, que sería el nombre del banco; no se necesita porqu ese busca con el id del banco a eliminar.
*/

DROP PROCEDURE IF EXISTS GestionarBancos;
DELIMITER //

CREATE PROCEDURE GestionarBancos(
    IN accion VARCHAR(10), -- Acción a realizar: 'insertar' o 'eliminar'
    IN nombre_banco VARCHAR(30), -- Nombre del banco a insertar
    IN id_banco INT, -- ID del banco a eliminar
    OUT mensaje VARCHAR(100) -- Mensaje de salida
)
BEGIN
    DECLARE banco_existente INT;

    IF accion = 'insertar' THEN
        -- Insertar un nuevo banco
        INSERT INTO bancos (nombre_banco) VALUES (nombre_banco);
        SET mensaje = CONCAT('Banco ', nombre_banco, ' insertado correctamente.');
    ELSEIF accion = 'eliminar' THEN
        -- Verificar si el banco existe
        SELECT COUNT(*) INTO banco_existente FROM bancos WHERE idBanco = id_banco;

        IF banco_existente > 0 THEN
            -- Eliminar el banco
            DELETE FROM bancos WHERE idBanco = id_banco;
            SET mensaje = CONCAT('Banco con ID ', id_banco, ' eliminado correctamente.');
        ELSE
            SET mensaje = CONCAT('No se encontró ningún banco con el ID ', id_banco, '. No se realizó ninguna acción.');
        END IF;
    ELSE
        SET mensaje = 'Acción no válida. Por favor, especifique "insertar" o "eliminar".';
    END IF;
END //

DELIMITER ;