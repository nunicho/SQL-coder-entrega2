USE proyecto_alonsomauricio;

-- Crear tablas de bitácora
DROP TABLE IF EXISTS bitacora_empresa;
CREATE TABLE bitacora_empresa (
    idLog INT AUTO_INCREMENT,
    operacion VARCHAR(10),
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    usuario VARCHAR(50),
    fecha_operacion DATE,
    hora_operacion TIME,
    idEmpresa INT,
    nombre_soc VARCHAR(100),
    tipo VARCHAR(50),
    cuit VARCHAR(13),
    fecha_contrato DATE,
    PRIMARY KEY (idLog)
);

DROP TABLE IF EXISTS bitacora_programa;
CREATE TABLE bitacora_programa (
    idLog INT AUTO_INCREMENT,
    operacion VARCHAR(10),
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    usuario VARCHAR(50),
    fecha_operacion DATE,
    hora_operacion TIME,
    idPrograma INT,
    nombre_programa VARCHAR(100),
    descripcion TEXT,
    legajo VARCHAR(20),
    monto INT,
    PRIMARY KEY (idLog)
);

-- Crear triggers para la tabla 'empresa'
DELIMITER //

DROP TRIGGER IF EXISTS before_insert_empresa;
CREATE TRIGGER before_insert_empresa
BEFORE INSERT ON empresa
FOR EACH ROW
BEGIN
    INSERT INTO bitacora_empresa (operacion, usuario, fecha_operacion, hora_operacion, idEmpresa, nombre_soc, tipo, cuit, fecha_contrato)
    VALUES ('INSERT', USER(), CURDATE(), CURTIME(), NEW.idEmpresa, NEW.nombre_soc, NEW.tipo, NEW.cuit, NEW.fecha_contrato);
END //

DROP TRIGGER IF EXISTS after_update_empresa;
CREATE TRIGGER after_update_empresa
AFTER UPDATE ON empresa
FOR EACH ROW
BEGIN
    INSERT INTO bitacora_empresa (operacion, usuario, fecha_operacion, hora_operacion, idEmpresa, nombre_soc, tipo, cuit, fecha_contrato)
    VALUES ('UPDATE', USER(), CURDATE(), CURTIME(), NEW.idEmpresa, NEW.nombre_soc, NEW.tipo, NEW.cuit, NEW.fecha_contrato);
END //

-- Crear triggers para la tabla 'programa'
DROP TRIGGER IF EXISTS before_delete_programa;
CREATE TRIGGER before_delete_programa
BEFORE DELETE ON programa
FOR EACH ROW
BEGIN
    INSERT INTO bitacora_programa (operacion, usuario, fecha_operacion, hora_operacion, idPrograma, nombre_programa, descripcion, legajo, monto)
    VALUES ('DELETE', USER(), CURDATE(), CURTIME(), OLD.idPrograma, OLD.nombre_programa, OLD.descripcion, OLD.legajo, OLD.monto);
END //

DROP TRIGGER IF EXISTS after_insert_programa;
CREATE TRIGGER after_insert_programa
AFTER INSERT ON programa
FOR EACH ROW
BEGIN
    INSERT INTO bitacora_programa (operacion, usuario, fecha_operacion, hora_operacion, idPrograma, nombre_programa, descripcion, legajo, monto)
    VALUES ('INSERT', USER(), CURDATE(), CURTIME(), NEW.idPrograma, NEW.nombre_programa, NEW.descripcion, NEW.legajo, NEW.monto);
END //

DELIMITER ;

/*
En este script se crean los triggers.

Se toman como tablas para los triggers las tablas empresa y programa
Los triggers regitran las variaciones de estas tablas en las tablas, creadas en este script, de bitacora_empresa y bitacora_programa

Ejemplo de cómo usar el trigger (en este caso cuando se hace un insert en empresa):

use proyecto_alonsomauricio;

INSERT INTO empresa (nombre_soc, tipo, cuit, fecha_contrato, idEnvergadura, idRubro, idBanco, idRrhh, idAsesor, idContacto, idRepresentante, idPrograma, idRatio, idLocalizacion)
VALUES ('Empresa Test', 'SA', '20-12345678-9', '2023-05-21', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1);

SELECT * FROM bitacora_empresa

UPDATE empresa SET nombre_soc = 'Nuevo Nombre' WHERE idEmpresa = 1;

 SELECT * FROM bitacora_empresa


Ejemplo de cómo usar el trigger (en este caso cuando se hace un insert en programa):

INSERT INTO programa (nombre_programa, descripcion, legajo, monto, idEstado, idLinea)
VALUES ('Programa Test', 'Descripción Test', '1234', 50000, 1, 1);

 SELECT * FROM bitacora_programa
*/