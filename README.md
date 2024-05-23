COMISIÓN: 53190
ALUMNO:   ALONSO MAURICIO JAVIER 
TRABAJO PRÁCTICO – ENTREGA 2

1 – Cambios en el Schema respecto de la entrega anterior

El presente trabajo continúa con el desarrollo del Schema perteneciente al ficticio Consejo Federal de Desarrollo.

Antes de pasar a los aspectos requeridos para la presente entrega detallo las modificaciones que se hicieron para hacer más claro el Schema. 
•	Se mejoraron y/o eliminaron campos en algunas tablas. A modo de ejemplo, se mencionan los siguientes cambios:
o	Agregado de nombre_calle en tabla localización;
o	Renombre a nacionalidad en tabla representante;
o	Agregado de campo teléfono_dep y nombre_dep en tabla dep;
•	Cambios en tablas:
o	Se eliminó la tabla ‘departamento’. En su lugar se creó la tabla ‘ciudad’. 
•	Ajustes en foreing keys:
o	La entrega anterior contenía algunos errores en las definiciones de las forening keys. Se ajustaron para reflejar verdaderamente las tablas madre de las tablas hijas y no distorsionar el flujo de la información.
•	Modificación de relaciones:
o	Se anuló la relación entre la tabla ‘dep’ y la tabla ‘contacto’, para que esta última sea una tabla donde sólo se recopilen tel, email y web de las empresas. 

2 – Estructura de la presente entrega

La presente entrega cuenta con 7 scripts, que deben ejecutarse secuencialmente para que no se generen errores. Los scrips, ordenados son:
•	1-Script-DB: mediante el cual se crea el schema;
•	2-Script-DatosParametricas: por el cual se insertan datos en tablas paramétricas;
•	3-Script-InsercionDatos: se agregan los datos a las tablas que no designadas como  paramétricas. 
•	4-Script-Vistas: el cual crea las vistas requeridas;
•	5-Script-Funciones: que crea las funciones señaladas en la consigna;
•	6-Script-StoredProcedures: crea los StoredProcedures pedidos. 
•	7-Triggers: crea dos triggers. 
•	DER-SegundaEntrega: actualizado para esta entrega.

3 – Scripts DatosParametricas e InsercionDatos 

Decidí separar en dos scripts la carga de la información. Por un lado,  los datos de las tablas que ya conozco, o que están definidos, de antemano: bancos, sucursales, asesores, líneas, envergadura, país, provincia, sector, etc.  
Y por el otro lado, los datos de los casos que hacen al fin de la base de datos: la información de las empresas, los representantes, y las empresas. 
Separar la carga me facilitó el control de los scripts y su corrección. 

2 – Scrip-Vistas

En este script se generan las siguientes vistas:

•	vista_empresa_completa:
Esta vista muestra todas las tablas del schema.
El objetivo de esta vista es mostrar toda la información. Me sirvió para verificar rápidamente si los datos se cargaron bien después del script de inserción. 

•	vista_estado_empresas_por_departamento
En esta vista se cuentan la cantidad de casos que hay por DEP, discriminando según el estado.
Al usuario le permite saber qué cantidad de casos por dep (sucursal hay en el CFD. 
Se ordena la información por DEP y luego por Estado.
En esta vista interactúan las tablas asesor, programa, dep y estado.

•	vista_cantidad_empresas_por_sector
Esta tabla muestra la cantidad de casos que hay por sector de actividad.
Al usuario le permite saber qué sector de la economía tiene mayor cantidad de empresas registradas en el CFD. 
Interactúan las tablas empresa, rubro y sector. 

•	vista_empresas_con_ciudad_actividad_y_asesor
Vista de empresa, por ciudad, con actividad y asesor
En esta vista se enlistan las empresas detallando de qué ciudad son, qué actividad realizan y quién las está asesorando.
El usuario puede tener utilizar esta información para ubicar geográficamente las empresas, y qué actividad realizan. Además puede identificar qué asesor del CFD la está asesorando. 
Interactúan las tablas empresa, localización, ciudad, rubro y asesor. 
•	vista_detalle_empresas_con_representante
Esta vista permite saber qué recursos humanos tiene cada empresa, mediante los datos de la tabla rrhh, su envergadura (pequeña, mediana o gran empresa) y el representante que está al frente del negocio. 
Interactúan las tablas empresa, envergadura, rrhh, representante. 


3 – Scrip-Funciones

•	Función  calcular_estadisticas_por_estado
La primera función calcula, en relación del estado ingresado, el monto total (sumatoria de importes), y los promedios de patrimonios netos, margen, roa y roe de todas las empresas de ese estado.

La utilidad de esta función es para saber el promedio de los ratios de las empresas que componen un estado determinado. 
 
 Para testear  esta función se debe ingresar el siguiente script:

USE proyecto_alonsomauricio;
SELECT calcular_estadisticas_por_estado('nombre_estado'); 
EJEMPLO: SELECT calcular_estadisticas_por_estado('Instrumentación');

Los valores almacenados en nombre_estado son: Instrumentación, Amortizando, Cancelado, Desistido, Moroso
Las tablas principales utilizadas por esta función son ratio, programa y estado. 

•	Función contar_empresas_por_dep
La segunda función calcula, en relación de la dep ingresada, la cantidad de empresas
vinculadas a esa dep. Permite al usuario verificar el volumen de trabajo que genera cada dep. 

Para testear  esta función se debe ingresar el siguiente script:

USE proyecto_alonsomauricio;
SELECT contar_empresas_por_dep('nombre_dep');
EJEMPLO :  SELECT contar_empresas_por_dep('DEP - Buenos Aires');

Los valores almacenados en nombre_dep son:
DEP - Buenos Aires, DEP - La Plata, DEP - Catamarca, DEP - Resistencia, DEP - Rawson, DEP – Córdoba - DEP - Resistencia, DEP - Paraná, DEP - Formosa, DEP - San Salvador de Jujuy, DEP - Santa Rosa - DEP - La Rioja, DEP - Mendoza, DEP - Posadas, DEP - Neuquén, DEP - Viedma, DEP - Salta, DEP - San Juan - DEP - San Luis, DEP - Río Gallegos, DEP - Santa Fe, DEP - Santiago del Estero, DEP - Ushuaia, DEP - San Miguel de Tucumán


4 – Scrip-StoredProcedures

•	Stored Procedure: OrdenarTabla
El primer Stored Procedure ordena una tabla mediante el campo, de forma ascendente o descendente.
Lo que se completa en los parámetros nombre de tabla, campos y críterio de ordenamiento (ASC o DESC) es a elección del usuario.  
Este procedimiento le facilita la visualización y el orden de la información al usuario de los datos. Contribuye a que el usuario pueda obtener datos más fácilmente. 
Ejemplos para ilustrar cómo se implementan: 
use proyecto_alonsomauricio;
CALL OrdenarTabla('empresa', 'nombre_soc', 'ASC');
CALL OrdenarTabla('asesor', 'nombre_asesorcalcular_estadisticas_por_estado', 'DESC');
CALL OrdenarTabla('bancos', 'idbanco', 'DESC');

•	Stored Procedure: GestionarBancos
El segundo Stored Procedure gestiona la tabla bancos, agregando o eliminando bancos.
Le permite al usuario manipular los datos de la tabla bancos, agregar o eliminar un banco; por ejemplo si el se toma contacto con una entidad financiera no registrada que se sume a la operatoria del CFD; o, por el contrario, si se da de baja un agente financiero. 

o	Ejemplo para agregar un banco: 

use proyecto_alonsomauricio;
SET @resultado = '';
CALL GestionarBancos('insertar', 'Banca Almafuerte', NULL, @resultado);
SELECT @resultado;

Se debe declarar la variable resultado antes de correr el CALL. La función tiene que llevar el parámetro ´insertar´ para diferenciar del ´eliminar´. Luego viene el nombre del banco. El campo NULL es porque no se toma un id ya cargado.

o	Ejemplo para eliminar un banco:

use proyecto_alonsomauricio;
SET @resultado = '';
CALL GestionarBancos('eliminar', NULL, 20, @resultado);
SELECT @resultado;

Se debe declarar la variable resultado antes de correr el CALL. La función tiene llevar el parámetro ´eliminar´ para diferenciar del ´insertar´. Luego NULL, que sería el nombre del banco; no se necesita porqu ese busca con el id del banco a eliminar.

5 – Scrip-Triggers

Para los triggers ee toman como tablas para los triggers las tablas empresa y programa.
Los triggers registran las variaciones de estas tablas en las tablas, creadas en este script, de bitacora_empresa y bitacora_programa

o	Ejemplos de cómo usar los triggers (insert y update empresa):

use proyecto_alonsomauricio;
INSERT INTO empresa (nombre_soc, tipo, cuit, fecha_contrato, idEnvergadura, idRubro, idBanco, idRrhh, idAsesor, idContacto, idRepresentante, idPrograma, idRatio, idLocalizacion)
VALUES ('Empresa Test', 'SA', '20-12345678-9', '2023-05-21', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1);
SELECT * FROM bitacora_empresa  -- Para probar los datos registrados

UPDATE empresa SET nombre_soc = 'Nuevo Nombre' WHERE idEmpresa = 1;
 SELECT * FROM bitacora_empresa -- Para probar los datos registrados

o	Ejemplo de cómo usar el trigger (en este caso cuando se hace un insert en programa):

INSERT INTO programa (nombre_programa, descripcion, legajo, monto, idEstado, idLinea)
VALUES ('Programa Test', 'Descripción Test', '1234', 50000, 1, 1);
 SELECT * FROM bitacora_programa -- Para probar los datos registrados
