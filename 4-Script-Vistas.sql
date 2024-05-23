USE proyecto_alonsomauricio;

-- Vista de empresas completa:
-- En esta vista se muestran TODOS los datos que componen la base

DROP VIEW IF EXISTS vista_empresa_completa;
CREATE VIEW vista_empresa_completa AS
SELECT 
    e.idEmpresa,
    e.nombre_soc,
    e.tipo,
    e.cuit,
    e.fecha_contrato,
    en.tipo_envergadura,
    e.fecha_i_m_e,
    r.actividad AS rubro_actividad,
    s.nombre_sector AS rubro_sector,
    b.nombre_banco,
    rr.num_socios,
    rr.num_empleados,
    a.nombre_asesor,
    d.nombre_dep AS asesor_dep,
    c.telefono AS contacto_telefono,
    c.email AS contacto_email,
    c.web AS contacto_web,
    rep.nombre_rep AS representante_nombre,
    rep.dni AS representante_dni,
    rep.profesion AS representante_profesion,
    p.nombre_pais AS representante_pais,
    prog.nombre_programa,
    prog.descripcion AS programa_descripcion,
    prog.legajo AS programa_legajo,
    prog.monto AS programa_monto,
    es.nombre_estado AS programa_estado,
    l.nombre_linea AS programa_linea,
    rto.patneto,
    rto.margen,
    rto.roa,
    rto.roe,
    rto.endeudamiento,
    loc.nombre_calle,
    loc.numeracion_calle,
    ciu.nombre_ciudad,
    prov.nombre_provincia,
    pa.nombre_pais AS localizacion_pais
FROM empresa e
LEFT JOIN envergadura en ON e.idEnvergadura = en.idEnvergadura
LEFT JOIN rubro r ON e.idRubro = r.idRubro
LEFT JOIN sector s ON r.idSector = s.idSector
LEFT JOIN bancos b ON e.idBanco = b.idBanco
LEFT JOIN rrhh rr ON e.idRrhh = rr.idRrhh
LEFT JOIN asesor a ON e.idAsesor = a.idAsesor
LEFT JOIN dep d ON a.idDep = d.idDep
LEFT JOIN contacto c ON e.idContacto = c.idContacto
LEFT JOIN representante rep ON e.idRepresentante = rep.idRepresentante
LEFT JOIN pais p ON rep.nacionalidad = p.idPais
LEFT JOIN programa prog ON e.idPrograma = prog.idPrograma
LEFT JOIN estado es ON prog.idEstado = es.idEstado
LEFT JOIN linea l ON prog.idLinea = l.idLinea
LEFT JOIN ratio rto ON e.idRatio = rto.idRatio
LEFT JOIN localizacion loc ON e.idLocalizacion = loc.idLocalizacion
LEFT JOIN ciudad ciu ON loc.idCiudad = ciu.idCiudad
LEFT JOIN provincia prov ON loc.idProvincia = prov.idProvincia
LEFT JOIN pais pa ON loc.idPais = pa.idPais;




-- Vista de DEP y estado:
-- En esta vista se cuentan la cantidad de casos que hay por DEP, discriminando según el estado.
-- Se ordena la información por DEP y luego por Estado


DROP VIEW IF EXISTS  vista_estado_empresas_por_departamento;
CREATE VIEW vista_estado_empresas_por_departamento AS
SELECT 
    d.nombre_dep AS departamento,
    es.nombre_estado AS estado,
    COUNT(e.idEmpresa) AS cantidad_empresas
FROM empresa e
LEFT JOIN asesor a ON e.idAsesor = a.idAsesor
LEFT JOIN dep d ON a.idDep = d.idDep
LEFT JOIN programa prog ON e.idPrograma = prog.idPrograma
LEFT JOIN estado es ON prog.idEstado = es.idEstado
GROUP BY d.nombre_dep, es.nombre_estado
ORDER BY d.nombre_dep, es.nombre_estado;



-- Vista de sector
-- En esta vista se cuentan la cantidad de casos que hay por sector.
DROP VIEW IF EXISTS vista_cantidad_empresas_por_sector;
CREATE VIEW vista_cantidad_empresas_por_sector AS
SELECT 
    s.nombre_sector AS sector,
    COUNT(e.idEmpresa) AS cantidad_empresas
FROM empresa e
LEFT JOIN rubro r ON e.idRubro = r.idRubro
LEFT JOIN sector s ON r.idSector = s.idSector
GROUP BY s.nombre_sector
ORDER BY s.nombre_sector;



-- Vista de empresa, por ciudad, con actividad y asesor
-- En esta vista se enlistan las empresa detallando de qué ciudad son, qué actividad realizan y quién las está asesorando

DROP VIEW IF EXISTS vista_empresas_con_ciudad_actividad_y_asesor;
CREATE VIEW vista_empresas_con_ciudad_actividad_y_asesor AS
SELECT e.nombre_soc AS Nombre_empresa, c.nombre_ciudad AS Ciudad, r.actividad AS Actividad, a.nombre_asesor AS Asesor
FROM empresa e
INNER JOIN localizacion l ON e.idLocalizacion = l.idLocalizacion
INNER JOIN ciudad c ON l.idCiudad = c.idCiudad
INNER JOIN rubro r ON e.idRubro = r.idRubro
INNER JOIN asesor a ON e.idAsesor = a.idAsesor;



-- Vista de empresa, por envergadura, rrhh y representante
-- En esta vista se enlistan las empresa detallando su envergaruda, cuántos socios y empleados tienen, el nombre de su representante y la nacionalidad

DROP VIEW IF EXISTS vista_detalle_empresas_con_representante;
CREATE VIEW vista_detalle_empresas_con_representante AS
SELECT e.nombre_soc AS Nombre_empresa, 
       en.tipo_envergadura AS Envergadura, 
       r.num_socios AS Cantidad_socios, 
       r.num_empleados AS Cantidad_empleados, 
       rep.nombre_rep AS Representante, 
       p.nombre_pais AS Nacionalidad_representante
FROM empresa e
INNER JOIN envergadura en ON e.idEnvergadura = en.idEnvergadura
INNER JOIN rrhh r ON e.idRrhh = r.idRrhh
INNER JOIN representante rep ON e.idRepresentante = rep.idRepresentante
INNER JOIN pais p ON rep.nacionalidad = p.idPais;