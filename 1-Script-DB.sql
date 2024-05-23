
-- Eliminamos el esquema si existe
DROP SCHEMA IF EXISTS `proyecto_alonsomauricio`;
-- Creamos el esquema
CREATE SCHEMA IF NOT EXISTS `proyecto_alonsomauricio`;
USE proyecto_alonsomauricio;

-- Creación de tablas
CREATE TABLE IF NOT EXISTS envergadura (
    idEnvergadura INT AUTO_INCREMENT,
    tipo_envergadura VARCHAR(30) NOT NULL,
    PRIMARY KEY (idEnvergadura)
);

CREATE TABLE IF NOT EXISTS estado (
    idEstado INT AUTO_INCREMENT,
    nombre_estado VARCHAR(15) NOT NULL,
    PRIMARY KEY (idEstado)
);

CREATE TABLE IF NOT EXISTS pais (
    idPais INT AUTO_INCREMENT,
    nombre_pais VARCHAR(50) NOT NULL,
    PRIMARY KEY (idPais)
);

CREATE TABLE IF NOT EXISTS contacto (
    idContacto INT AUTO_INCREMENT,
    telefono VARCHAR(20),
    email VARCHAR(50) NOT NULL,
    web VARCHAR(100),
    PRIMARY KEY (idContacto)
);

CREATE TABLE IF NOT EXISTS dep (
    idDep INT AUTO_INCREMENT,
    nombre_dep VARCHAR(100) NOT NULL,
    telefono_dep VARCHAR(20),
    email_dep VARCHAR(50) NOT NULL,
    PRIMARY KEY (idDep)
);

CREATE TABLE IF NOT EXISTS representante (
    idRepresentante INT AUTO_INCREMENT,
    nombre_rep VARCHAR(100) NOT NULL,
    dni VARCHAR(8) NOT NULL,
    profesion VARCHAR(50),
    nacionalidad INT,
    PRIMARY KEY (idRepresentante),
    FOREIGN KEY (nacionalidad) REFERENCES pais(idPais)
);

CREATE TABLE IF NOT EXISTS provincia (
    idProvincia INT AUTO_INCREMENT,
    nombre_provincia VARCHAR(50) NOT NULL,
    PRIMARY KEY (idProvincia)
);

CREATE TABLE IF NOT EXISTS ciudad (
    idCiudad INT AUTO_INCREMENT,
    nombre_ciudad VARCHAR(50) NOT NULL,
    PRIMARY KEY (idCiudad)
);

CREATE TABLE IF NOT EXISTS sector (
    idSector INT AUTO_INCREMENT,
    nombre_sector VARCHAR(30) NOT NULL,
    PRIMARY KEY (idSector)
);

CREATE TABLE IF NOT EXISTS rubro (
    idRubro INT AUTO_INCREMENT,
    actividad VARCHAR(200) NOT NULL,
    idSector INT,
    PRIMARY KEY (idRubro),
    FOREIGN KEY (idSector) REFERENCES sector(idSector)
);

CREATE TABLE IF NOT EXISTS bancos (
    idBanco INT AUTO_INCREMENT,
    nombre_banco VARCHAR(30),
    PRIMARY KEY (idBanco)
);

CREATE TABLE IF NOT EXISTS rrhh (
    idRrhh INT AUTO_INCREMENT,
    num_socios TINYINT NOT NULL,
    num_empleados TINYINT,
    PRIMARY KEY (idRrhh)
);

CREATE TABLE IF NOT EXISTS asesor (
    idAsesor INT AUTO_INCREMENT,
    nombre_asesor VARCHAR(100) NOT NULL,
    idDep INT,
    PRIMARY KEY (idAsesor),
    FOREIGN KEY (idDep) REFERENCES dep(idDep)
);

CREATE TABLE IF NOT EXISTS linea (
    idLinea INT AUTO_INCREMENT,
    nombre_linea VARCHAR(50) NOT NULL,
    PRIMARY KEY (idLinea)
);

CREATE TABLE IF NOT EXISTS programa (
    idPrograma INT AUTO_INCREMENT,
    nombre_programa VARCHAR(100) NOT NULL,
    descripcion TEXT,
    legajo VARCHAR(20),
    monto INT,
    idEstado INT,
    idLinea INT,
    PRIMARY KEY (idPrograma),
    FOREIGN KEY (idLinea) REFERENCES linea(idLinea),
    FOREIGN KEY (idEstado) REFERENCES estado(idEstado)
);

CREATE TABLE IF NOT EXISTS ratio (
    idRatio INT AUTO_INCREMENT,
    patneto INT NOT NULL,
    margen DECIMAL(5,2) NOT NULL,
    roa DECIMAL(5,2),
    roe DECIMAL(5,2),
    endeudamiento DECIMAL(5,2),
    PRIMARY KEY (idRatio)
);

CREATE TABLE IF NOT EXISTS localizacion (
    idLocalizacion INT AUTO_INCREMENT,
    nombre_calle VARCHAR(50),
    numeracion_calle INT,
    idCiudad INT,
    idProvincia INT,
    idPais INT,
    PRIMARY KEY (idLocalizacion),
    FOREIGN KEY (idCiudad) REFERENCES ciudad(idCiudad),
    FOREIGN KEY (idProvincia) REFERENCES provincia(idProvincia),
    FOREIGN KEY (idPais) REFERENCES pais(idPais)
);

CREATE TABLE IF NOT EXISTS empresa (
    idEmpresa INT AUTO_INCREMENT,
    nombre_soc VARCHAR(100) NOT NULL,
    tipo VARCHAR(50) NOT NULL,
    cuit VARCHAR(13) NOT NULL,
    fecha_contrato DATE NOT NULL,
    idEnvergadura INT,
    fecha_i_m_e DATE,
    idRubro INT,
    idBanco INT,
    idRrhh INT,
    idAsesor INT,
    idContacto INT,
    idRepresentante INT,
    idPrograma INT,
    idRatio INT,
    idLocalizacion INT,
    PRIMARY KEY (idEmpresa),
    FOREIGN KEY (idEnvergadura) REFERENCES envergadura(idEnvergadura),
    FOREIGN KEY (idRubro) REFERENCES rubro(idRubro),
    FOREIGN KEY (idBanco) REFERENCES bancos(idBanco),
    FOREIGN KEY (idRrhh) REFERENCES rrhh(idRrhh),
    FOREIGN KEY (idAsesor) REFERENCES asesor(idAsesor),
    FOREIGN KEY (idContacto) REFERENCES contacto(idContacto),
    FOREIGN KEY (idRepresentante) REFERENCES representante(idRepresentante),
    FOREIGN KEY (idPrograma) REFERENCES programa(idPrograma),
    FOREIGN KEY (idRatio) REFERENCES ratio(idRatio),
    FOREIGN KEY (idLocalizacion) REFERENCES localizacion(idLocalizacion)
);
