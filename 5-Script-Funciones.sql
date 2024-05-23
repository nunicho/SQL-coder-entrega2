USE proyecto_alonsomauricio;

DELIMITER //

/*
La primera función calcula, en relación del estado ingresado, el monto total (sumatoria de importes),
y los promedio de patrimonios netos, margen, roa y roe de todas las empresas de ese estado, 
 
 Para testear  esta función se debe ingresar el siguiente script:

USE proyecto_alonsomauricio;
SELECT calcular_estadisticas_por_estado('nombre_estado'); 

EJEMPLO: SELECT calcular_estadisticas_por_estado('Instrumentación');

Los valores almacenados en nombre_estado son: Instrumentación, Amortizando, Cancelado, Desistido, Moroso
*/

DROP FUNCTION IF EXISTS calcular_estadisticas_por_estado;
CREATE FUNCTION calcular_estadisticas_por_estado(estado_nombre VARCHAR(15))
RETURNS VARCHAR(200)
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE resultado VARCHAR(200);
    DECLARE total_monto INT;
    DECLARE promedio_patneto DECIMAL(10,2);
    DECLARE promedio_margen DECIMAL(5,2);
    DECLARE promedio_roa DECIMAL(5,2);
    DECLARE promedio_roe DECIMAL(5,2);
    
    -- Calcula la suma del monto por estado
    SELECT SUM(monto) INTO total_monto
    FROM programa
    WHERE idEstado = (SELECT idEstado FROM estado WHERE nombre_estado = estado_nombre);
    
    -- Calcula los promedios de patneto, margen, roa y roe
    SELECT AVG(patneto), AVG(margen), AVG(roa), AVG(roe)
    INTO promedio_patneto, promedio_margen, promedio_roa, promedio_roe
    FROM ratio
    WHERE idRatio IN (SELECT idRatio FROM programa WHERE idEstado = (SELECT idEstado FROM estado WHERE nombre_estado = estado_nombre));
    
    -- Construye el resultado
    SET resultado = CONCAT('Estado: ', estado_nombre, 
                           ', Total Monto: ', total_monto,
                           ', Promedio Patneto: ', promedio_patneto,
                           ', Promedio Margen: ', promedio_margen,
                           ', Promedio ROA: ', promedio_roa,
                           ', Promedio ROE: ', promedio_roe);
                           
    RETURN resultado;
END //

DELIMITER ;


/*
La segunda función calcula, en relación de la dep ingresada, la cantidad de empresas
vinculadas a esa dep.

Para testear  esta función se debe ingresar el siguiente script:

USE proyecto_alonsomauricio;
SELECT contar_empresas_por_dep('nombre_dep');

EJEMPLO :  SELECT contar_empresas_por_dep('DEP - Buenos Aires');

Los valores almacenados en nombre_dep son:

DEP - Buenos Aires, DEP - La Plata, DEP - Catamarca, DEP - Resistencia, DEP - Rawson, DEP - Córdoba
DEP - Resistencia, DEP - Paraná, DEP - Formosa, DEP - San Salvador de Jujuy, DEP - Santa Rosa
DEP - La Rioja, DEP - Mendoza, DEP - Posadas, DEP - Neuquén, DEP - Viedma, DEP - Salta, DEP - San Juan
DEP - San Luis, DEP - Río Gallegos, DEP - Santa Fe, DEP - Santiago del Estero, DEP - Ushuaia, DEP - San Miguel de Tucumán

*/

DELIMITER //
DROP FUNCTION IF EXISTS contar_empresas_por_dep;
CREATE FUNCTION contar_empresas_por_dep(nombre_departamento VARCHAR(100))
RETURNS INT
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE cantidad_empresas INT;
    
    -- Contar las empresas por nombre de departamento
    SELECT COUNT(e.idEmpresa)
    INTO cantidad_empresas
    FROM empresa e
    LEFT JOIN asesor a ON e.idAsesor = a.idAsesor
    LEFT JOIN dep d ON a.idDep = d.idDep
    WHERE d.nombre_dep = nombre_departamento;
    
    RETURN cantidad_empresas;
END //

DELIMITER 