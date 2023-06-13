USE GD1C2023
GO

IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'G_DE_GESTION')
	THROW 51000, 'No se encontro esquema. Ejecutar primero script_creacion_inicial.sql', 1
GO

/*IF OBJECT_ID('G_DE_GESTION.Circuitos_Mas_Peligrosos', 'V') IS NOT NULL DROP VIEW G_DE_GESTION.Circuitos_Mas_Peligrosos;
IF OBJECT_ID('G_DE_GESTION.Incidentes_Escuderia_Tipo_Sector', 'V') IS NOT NULL DROP VIEW G_DE_GESTION.Incidentes_Escuderia_Tipo_Sector;
IF OBJECT_ID('G_DE_GESTION.Tiempo_Promedio_En_Paradas', 'V') IS NOT NULL DROP VIEW G_DE_GESTION.Tiempo_Promedio_En_Paradas;
IF OBJECT_ID('G_DE_GESTION.Cant_Paradas_Circuito_Escuderia', 'V') IS NOT NULL DROP VIEW G_DE_GESTION.Cant_Paradas_Circuito_Escuderia;
IF OBJECT_ID('G_DE_GESTION.Circuitos_Mayor_Tiempo_Boxes', 'V') IS NOT NULL DROP VIEW G_DE_GESTION.Circuitos_Mayor_Tiempo_Boxes;
IF OBJECT_ID('G_DE_GESTION.Circuitos_mayor_combustible', 'V') IS NOT NULL DROP VIEW G_DE_GESTION.Circuitos_mayor_combustible;
IF OBJECT_ID('G_DE_GESTION.Desgaste', 'V') IS NOT NULL DROP VIEW G_DE_GESTION.Desgaste;
IF OBJECT_ID('G_DE_GESTION.Mayor_velocidad_por_sector ', 'V') IS NOT NULL DROP VIEW G_DE_GESTION.Mayor_velocidad_por_sector ;
IF OBJECT_ID('G_DE_GESTION.Mejor_tiempo_vuelta ', 'V') IS NOT NULL DROP VIEW G_DE_GESTION.Mejor_tiempo_vuelta;
*/

IF OBJECT_ID('G_DE_GESTION.BI_hecho_pedidos', 'U') IS NOT NULL DROP TABLE G_DE_GESTION.BI_hecho_pedidos

IF OBJECT_ID('G_DE_GESTION.BI_dim_tiempo', 'U') IS NOT NULL DROP TABLE G_DE_GESTION.BI_dim_tiempo
IF OBJECT_ID('G_DE_GESTION.BI_dim_dia', 'U') IS NOT NULL DROP TABLE G_DE_GESTION.BI_dim_dia
IF OBJECT_ID('G_DE_GESTION.BI_dim_rango_horario', 'U') IS NOT NULL DROP TABLE G_DE_GESTION.BI_dim_rango_horario
IF OBJECT_ID('G_DE_GESTION.BI_dim_rango_etario', 'U') IS NOT NULL DROP TABLE G_DE_GESTION.BI_dim_rango_etario
IF OBJECT_ID('G_DE_GESTION.BI_dim_local', 'U') IS NOT NULL DROP TABLE G_DE_GESTION.BI_dim_local
IF OBJECT_ID('G_DE_GESTION.BI_dim_region', 'U') IS NOT NULL DROP TABLE G_DE_GESTION.BI_dim_region
IF OBJECT_ID('G_DE_GESTION.BI_dim_tipo_local', 'U') IS NOT NULL DROP TABLE G_DE_GESTION.BI_dim_tipo_local
IF OBJECT_ID('G_DE_GESTION.BI_dim_tipo_medio_pago', 'U') IS NOT NULL DROP TABLE G_DE_GESTION.BI_dim_tipo_medio_pago
IF OBJECT_ID('G_DE_GESTION.BI_dim_tipo_movilidad', 'U') IS NOT NULL DROP TABLE G_DE_GESTION.BI_dim_tipo_movilidad
IF OBJECT_ID('G_DE_GESTION.BI_dim_tipo_paquete', 'U') IS NOT NULL DROP TABLE G_DE_GESTION.BI_dim_tipo_paquete
IF OBJECT_ID('G_DE_GESTION.BI_dim_estado_pedido', 'U') IS NOT NULL DROP TABLE G_DE_GESTION.BI_dim_estado_pedido
IF OBJECT_ID('G_DE_GESTION.BI_dim_estado_envio_mensajeria', 'U') IS NOT NULL DROP TABLE G_DE_GESTION.BI_dim_estado_envio_mensajeria
IF OBJECT_ID('G_DE_GESTION.BI_dim_estado_reclamo', 'U') IS NOT NULL DROP TABLE G_DE_GESTION.BI_dim_estado_reclamo
GO


----- Dimensiones ----
CREATE TABLE G_DE_GESTION.BI_dim_tiempo(
	tiempo_id DECIMAL(18,0) IDENTITY(1,1) PRIMARY KEY,
	anio INT NOT NULL,
	mes INT NOT NULL
)
GO

CREATE TABLE G_DE_GESTION.BI_dim_dia(
	dia_id DECIMAL(18,0) PRIMARY KEY,
	dia NVARCHAR(50) NOT NULL,
)
GO

/*CREATE TABLE G_DE_GESTION.provincia(
	provincia_id DECIMAL(18,0) IDENTITY(1,1) PRIMARY KEY,
	provincia_descripcion NVARCHAR(255) NOT NULL
)
GO

CREATE TABLE G_DE_GESTION.localidad(
	localidad_id DECIMAL(18,0) IDENTITY(1,1) PRIMARY KEY,
	localidad_descripcion NVARCHAR(255) NOT NULL,
	provincia_id DECIMAL(18,0) REFERENCES G_DE_GESTION.provincia
)
GO*/
CREATE TABLE G_DE_GESTION.BI_dim_region(
	region_id DECIMAL(18,0) IDENTITY(1,1) PRIMARY KEY,
	provincia_descripcion NVARCHAR(255) NOT NULL,
	localidad_descripcion NVARCHAR(255) NOT NULL
)
GO

/*CREATE TABLE G_DE_GESTION.BI_dim_rango_horario(
	rango_horario_id INT IDENTITY(1,1) PRIMARY KEY,
	rango_horario nvarchar(50) NOT NULL
)
GO*/
CREATE TABLE G_DE_GESTION.BI_dim_rango_horario(
	rango_horario_id INT IDENTITY(1,1) PRIMARY KEY,
	rango_horario_inicio DECIMAL(18,0) NOT NULL,
	rango_horario_fin DECIMAL(18,0) NOT NULL
)
GO


CREATE TABLE G_DE_GESTION.BI_dim_rango_etario(
	rango_etario_id INT IDENTITY(1,1) PRIMARY KEY,
	rango_etario nvarchar(50) NOT NULL
)
GO

/*CREATE TABLE G_DE_GESTION.tipo_local(
	tipo_local_id DECIMAL(18,0) IDENTITY(1,1) PRIMARY KEY,
	tipo_local_descripcion NVARCHAR(50) NOT NULL
)
GO

CREATE TABLE G_DE_GESTION.categoria(
	categoria_id DECIMAL(18,0) IDENTITY(1,1) PRIMARY KEY,
	categoria_descripcion NVARCHAR(50),
	tipo_local_id DECIMAL(18,0) REFERENCES G_DE_GESTION.tipo_local
)
GO*/
CREATE TABLE G_DE_GESTION.BI_dim_tipo_local(
	tipo_local_id DECIMAL(18,0) IDENTITY(1,1) PRIMARY KEY,
	tipo_local_descripcion NVARCHAR(50) NOT NULL,
	categoria_descripcion NVARCHAR(50)
)
GO

CREATE TABLE G_DE_GESTION.BI_dim_local(
	local_id DECIMAL(18,0) IDENTITY(1,1) PRIMARY KEY,
	local_nombre NVARCHAR(100) NOT NULL,
	local_descripcion NVARCHAR(255) NOT NULL,
	local_direccion NVARCHAR(255) NOT NULL,
	region_id DECIMAL(18,0) REFERENCES G_DE_GESTION.BI_dim_region NOT NULL,
	tipo_local_id DECIMAL(18,0) REFERENCES G_DE_GESTION.BI_dim_tipo_local
	--categoria_id DECIMAL(18,0) REFERENCES G_DE_GESTION.categoria
)
GO

CREATE TABLE G_DE_GESTION.BI_dim_tipo_medio_pago(
	tipo_medio_pago_id DECIMAL(18,0) IDENTITY(1,1) PRIMARY KEY,
	tipo_medio_pago_descripcion NVARCHAR(50) NOT NULL
)
GO

CREATE TABLE G_DE_GESTION.BI_dim_tipo_movilidad(
	tipo_movilidad_id DECIMAL(18,0) IDENTITY(1,1) PRIMARY KEY,
	tipo_movilidad_descripcion NVARCHAR(50) NOT NULL
)
GO

CREATE TABLE G_DE_GESTION.BI_dim_tipo_paquete (
	tipo_paquete_id DECIMAL(18,0) IDENTITY(1,1) PRIMARY KEY,
	tipo_paquete_descripcion NVARCHAR(50) NOT NULL
)
GO

CREATE TABLE G_DE_GESTION.BI_dim_estado_pedido (
	estado_pedido_id DECIMAL(18,0) IDENTITY(1,1) PRIMARY KEY,
	estado_pedido_descripcion NVARCHAR(50) NOT NULL
)
GO

CREATE TABLE G_DE_GESTION.BI_dim_estado_envio_mensajeria (
	estado_envio_mensajeria_id DECIMAL(18,0) IDENTITY(1,1) PRIMARY KEY,
	estado_envio_mensajeria_descripcion NVARCHAR(50) NOT NULL
)
GO

CREATE TABLE G_DE_GESTION.BI_dim_estado_reclamo (
	estado_reclamo_id DECIMAL(18,0) IDENTITY(1,1) PRIMARY KEY,
	estado_reclamo_descripcion NVARCHAR(50) NOT NULL
)
GO


----- Hechos ----
CREATE TABLE G_DE_GESTION.BI_hecho_pedidos (
	dia_id DECIMAL(18,0),
	local_id DECIMAL(18,0),
	rango_horario_id INT,
	region_id DECIMAL(18,0),
	rango_etario_id INT,
	--tipo_local_id DECIMAL(18,0), PK/FK No se puede migrar por tipo de local ya que no existe la categoria
	tiempo_id DECIMAL(18,0),
	estado_pedido_id DECIMAL(18,0),
	cantidad_pedidos DECIMAL(18,0) NOT NULL,
	pedido_total_servicio DECIMAL(18,0) NOT NULL,
	pedido_precio_envio DECIMAL(18,0) NOT NULL,
	pedido_total_cupones DECIMAL(18,0) NOT NULL,
	pedido_calificacion DECIMAL(18,0) NOT NULL,
	PRIMARY KEY(dia_id, local_id, rango_horario_id, region_id, rango_etario_id, tiempo_id, estado_pedido_id)
)
GO



----- Procedures -----
CREATE PROCEDURE G_DE_GESTION.migrar_BI_dim_tiempo AS
BEGIN
	INSERT INTO G_DE_GESTION.BI_dim_tiempo(anio, mes)
	SELECT DISTINCT 
		YEAR(p.pedido_fecha),
		MONTH(p.pedido_fecha)
	FROM G_DE_GESTION.pedido p
	UNION
	SELECT DISTINCT 
		YEAR(r.reclamo_fecha),
		MONTH(r.reclamo_fecha)
	FROM G_DE_GESTION.reclamo r
	UNION
	SELECT DISTINCT 
		YEAR(em.envio_mensajeria_fecha),
		MONTH(em.envio_mensajeria_fecha)
	FROM G_DE_GESTION.envio_mensajeria em
END
GO

CREATE PROCEDURE G_DE_GESTION.migrar_BI_dim_dia AS
BEGIN
	INSERT INTO G_DE_GESTION.BI_dim_dia(dia_id, dia)
	SELECT DISTINCT 
		(CASE
			WHEN h.horario_dia = 'Lunes' THEN 1
			WHEN h.horario_dia = 'Martes' THEN 2
			WHEN h.horario_dia = 'Miercoles' THEN 3
			WHEN h.horario_dia = 'Jueves' THEN 4
			WHEN h.horario_dia = 'Viernes' THEN 5
			WHEN h.horario_dia = 'Sabado' THEN 6
			WHEN h.horario_dia = 'Domingo' THEN 7
		END),
		h.horario_dia
	FROM G_DE_GESTION.horario h
	ORDER BY 1
END
GO

CREATE PROCEDURE G_DE_GESTION.migrar_BI_dim_region AS
BEGIN
	INSERT INTO G_DE_GESTION.BI_dim_region(provincia_descripcion, localidad_descripcion)
	SELECT DISTINCT p.provincia_descripcion, l.localidad_descripcion
	FROM G_DE_GESTION.localidad l
	JOIN G_DE_GESTION.provincia p ON (p.provincia_id = l.provincia_id)
END
GO

-- NOTA: preguntar por la migracion. Hay rangos de 1hs?
-- Ayudar: crear CURSOR e implementar logica para leer fila por fila
CREATE PROCEDURE G_DE_GESTION.migrar_BI_dim_rango_horario AS
BEGIN
	DECLARE @apertura DECIMAL(18,0)
	DECLARE @cierre DECIMAL(18,0)
	DECLARE @next_rango DECIMAL(18,0)

	DECLARE cursor_horario CURSOR FOR
	SELECT DISTINCT h.horario_hora_apertura, h.horario_hora_cierre FROM G_DE_GESTION.horario h

	OPEN cursor_horario
	FETCH NEXT FROM cursor_horario INTO @apertura, @cierre
	SET @next_rango = @apertura
	WHILE @@FETCH_STATUS = 0
	BEGIN
		WHILE @apertura < @cierre
		BEGIN
			IF @apertura + 2 <= @cierre
			BEGIN
				SET @next_rango = @next_rango + 2
				INSERT INTO G_DE_GESTION.BI_dim_rango_horario(rango_horario_inicio, rango_horario_fin)
				VALUES(@apertura, @next_rango)
				--VALUES(STR(@apertura, 2, 0) + '-' + STR(@next_rango, 2, 0))
				--PRINT STR(@apertura, 2, 0) + '-' + STR(@next_rango, 2, 0)
			END
			ELSE
			BEGIN
				SET @next_rango = @next_rango + 1
				INSERT INTO G_DE_GESTION.BI_dim_rango_horario(rango_horario_inicio, rango_horario_fin)
				VALUES(@apertura, @next_rango)
				--VALUES(STR(@apertura, 2, 0) + '-' + STR(@next_rango, 2, 0))
				--PRINT STR(@apertura, 2, 0) + '-' + STR(@next_rango, 2, 0)
			END
			SET @apertura = @next_rango
		END
		FETCH NEXT FROM cursor_horario INTO @apertura, @cierre
		SET @next_rango = @apertura
	END

	CLOSE cursor_horario
	DEALLOCATE cursor_horario
END
GO

CREATE PROCEDURE G_DE_GESTION.migrar_BI_dim_rango_etario AS
BEGIN
	INSERT INTO G_DE_GESTION.BI_dim_rango_etario(rango_etario)
	SELECT DISTINCT
		(case
			when DATEDIFF(YEAR, u.usuario_fecha_nac, GETDATE()) < 25 then '<25' 
			when DATEDIFF(YEAR, u.usuario_fecha_nac, GETDATE()) between 25 and 35 then '25-35'
			when DATEDIFF(YEAR, u.usuario_fecha_nac, GETDATE()) between 35 and 55 then '35-55'
			when DATEDIFF(YEAR, u.usuario_fecha_nac, GETDATE()) > 55 then '>55'
		end)
	FROM G_DE_GESTION.usuario u
	UNION
	SELECT DISTINCT
		(case
			when DATEDIFF(YEAR, r.repartidor_fecha_nac, GETDATE()) < 25 then '<25' 
			when DATEDIFF(YEAR, r.repartidor_fecha_nac, GETDATE()) between 25 and 35 then '25-35'
			when DATEDIFF(YEAR, r.repartidor_fecha_nac, GETDATE()) between 35 and 55 then '35-55'
			when DATEDIFF(YEAR, r.repartidor_fecha_nac, GETDATE()) > 55 then '>55'
		end)
	FROM G_DE_GESTION.repartidor r
	UNION
	SELECT DISTINCT
		(case
			when DATEDIFF(YEAR, o.operador_reclamo_fecha_nac, GETDATE()) < 25 then '<25' 
			when DATEDIFF(YEAR, o.operador_reclamo_fecha_nac, GETDATE()) between 25 and 35 then '25-35'
			when DATEDIFF(YEAR, o.operador_reclamo_fecha_nac, GETDATE()) between 35 and 55 then '35-55'
			when DATEDIFF(YEAR, o.operador_reclamo_fecha_nac, GETDATE()) > 55 then '>55'
		end)
	FROM G_DE_GESTION.operador_reclamo o
END
GO

-- NOTA: ver como migrar esto. Se opta por migrar con los datos de ejemplo en enunciado
CREATE PROCEDURE G_DE_GESTION.migrar_BI_dim_tipo_local AS
BEGIN
	INSERT INTO G_DE_GESTION.BI_dim_tipo_local(tipo_local_descripcion, categoria_descripcion)
	SELECT tl.tipo_local_descripcion, c.categoria_descripcion
	FROM G_DE_GESTION.categoria c
	JOIN G_DE_GESTION.tipo_local tl ON (tl.tipo_local_id = c.tipo_local_id)
END
GO

CREATE PROCEDURE G_DE_GESTION.migrar_BI_dim_local AS
BEGIN
	INSERT INTO G_DE_GESTION.BI_dim_local(
		local_nombre,
		local_descripcion,
		local_direccion,
		region_id
	)
	SELECT l.local_nombre,
		l.local_descripcion,
		l.local_direccion,
		r.region_id
	FROM G_DE_GESTION.local l
	JOIN G_DE_GESTION.localidad lo ON (lo.localidad_id = l.localidad_id)
	JOIN G_DE_GESTION.provincia p ON (p.provincia_id = lo.provincia_id)
	JOIN G_DE_GESTION.BI_dim_region r ON (r.localidad_descripcion = lo.localidad_descripcion AND r.provincia_descripcion = p.provincia_descripcion)
	ORDER BY l.local_id
END
GO

CREATE PROCEDURE G_DE_GESTION.migrar_BI_dim_tipo_medio_pago AS
BEGIN
	INSERT INTO G_DE_GESTION.BI_dim_tipo_medio_pago(tipo_medio_pago_descripcion)
	SELECT mp.tipo_medio_pago_descripcion
	FROM G_DE_GESTION.tipo_medio_pago mp
END
GO

CREATE PROCEDURE G_DE_GESTION.migrar_BI_dim_tipo_movilidad AS
BEGIN
	INSERT INTO G_DE_GESTION.BI_dim_tipo_movilidad(tipo_movilidad_descripcion)
	SELECT tm.tipo_movilidad_descripcion
	FROM G_DE_GESTION.tipo_movilidad tm
END
GO

CREATE PROCEDURE G_DE_GESTION.migrar_BI_dim_tipo_paquete AS
BEGIN
	INSERT INTO G_DE_GESTION.BI_dim_tipo_paquete(tipo_paquete_descripcion)
	SELECT tp.tipo_paquete_descripcion
	FROM G_DE_GESTION.tipo_paquete tp
END
GO

CREATE PROCEDURE G_DE_GESTION.migrar_BI_dim_estado_pedido AS
BEGIN
	INSERT INTO G_DE_GESTION.BI_dim_estado_pedido(estado_pedido_descripcion)
	SELECT ep.estado_pedido_descripcion
	FROM G_DE_GESTION.estado_pedido ep
END
GO

CREATE PROCEDURE G_DE_GESTION.migrar_BI_dim_estado_envio_mensajeria AS
BEGIN
	INSERT INTO G_DE_GESTION.BI_dim_estado_envio_mensajeria(estado_envio_mensajeria_descripcion)
	SELECT eem.estado_envio_mensajeria_descripcion
	FROM G_DE_GESTION.estado_envio_mensajeria eem
END
GO

CREATE PROCEDURE G_DE_GESTION.migrar_BI_dim_estado_reclamo AS
BEGIN
	INSERT INTO G_DE_GESTION.BI_dim_estado_reclamo(estado_reclamo_descripcion)
	SELECT er.estado_reclamo_descripcion
	FROM G_DE_GESTION.estado_reclamo er
END
GO

CREATE PROCEDURE G_DE_GESTION.migrar_BI_hecho_pedidos AS
BEGIN
	SET DATEFIRST 1
	INSERT INTO G_DE_GESTION.BI_hecho_pedidos(
		dia_id,
		local_id,
		rango_horario_id,
		region_id,
		rango_etario_id,
		tiempo_id,
		estado_pedido_id,
		cantidad_pedidos,
		pedido_total_servicio,
		pedido_precio_envio,
		pedido_total_cupones,
		pedido_calificacion
	)
	SELECT
		dd.dia_id,
		dl.local_id,
		drh.rango_horario_id,
		dl.region_id,
		dre.rango_etario_id,
		dt.tiempo_id,
		dep.estado_pedido_id,
		COUNT(*),
		SUM(p.pedido_total_servicio),
		SUM(p.pedido_precio_envio),
		SUM(p.pedido_total_cupones),
		SUM(p.pedido_calificacion) / COUNT(*) -- confirmar cuenta
	FROM G_DE_GESTION.pedido p
	JOIN G_DE_GESTION.BI_dim_dia dd ON (dd.dia_id = DATEPART(DW, p.pedido_fecha))
	JOIN G_DE_GESTION.BI_dim_local dl ON (dl.local_id = p.local_id)
	JOIN G_DE_GESTION.BI_dim_rango_horario drh ON (DATEPART(HOUR, p.pedido_fecha) >= drh.rango_horario_inicio
												AND DATEPART(HOUR, p.pedido_fecha) <= drh.rango_horario_fin)
	JOIN G_DE_GESTION.usuario u ON (u.usuario_id = p.usuario_id)
	JOIN G_DE_GESTION.BI_dim_rango_etario dre ON (dre.rango_etario = 
					(case
						when DATEDIFF(YEAR, u.usuario_fecha_nac, GETDATE()) < 25 then '<25' 
						when DATEDIFF(YEAR, u.usuario_fecha_nac, GETDATE()) between 25 and 35 then '25-35'
						when DATEDIFF(YEAR, u.usuario_fecha_nac, GETDATE()) between 35 and 55 then '35-55'
						when DATEDIFF(YEAR, u.usuario_fecha_nac, GETDATE()) > 55 then '>55'
					end))
	JOIN G_DE_GESTION.BI_dim_tiempo dt ON (dt.anio = YEAR(p.pedido_fecha) AND dt.mes = MONTH(p.pedido_fecha))
	JOIN G_DE_GESTION.BI_dim_estado_pedido dep ON (dep.estado_pedido_id = p.estado_pedido_id)
	GROUP BY
		dd.dia_id,
		dl.local_id,
		drh.rango_horario_id,
		dl.region_id,
		dre.rango_etario_id,
		dt.tiempo_id,
		dep.estado_pedido_id
END
GO

----- Migracion OLAP -----
BEGIN TRANSACTION
	EXECUTE G_DE_GESTION.migrar_BI_dim_tiempo
	EXECUTE G_DE_GESTION.migrar_BI_dim_dia
	EXECUTE G_DE_GESTION.migrar_BI_dim_region
	EXECUTE G_DE_GESTION.migrar_BI_dim_rango_horario
	EXECUTE G_DE_GESTION.migrar_BI_dim_rango_etario
	EXECUTE G_DE_GESTION.migrar_BI_dim_tipo_local
	EXECUTE G_DE_GESTION.migrar_BI_dim_local
	EXECUTE G_DE_GESTION.migrar_BI_dim_tipo_medio_pago
	EXECUTE G_DE_GESTION.migrar_BI_dim_tipo_movilidad
	EXECUTE G_DE_GESTION.migrar_BI_dim_tipo_paquete
	EXECUTE G_DE_GESTION.migrar_BI_dim_estado_pedido
	EXECUTE G_DE_GESTION.migrar_BI_dim_estado_envio_mensajeria
	EXECUTE G_DE_GESTION.migrar_BI_dim_estado_reclamo
	EXECUTE G_DE_GESTION.migrar_BI_hecho_pedidos
COMMIT TRANSACTION
GO

-- Drop de FUNCTIONs y PROCEDUREs
DROP PROCEDURE G_DE_GESTION.migrar_BI_dim_tiempo
DROP PROCEDURE G_DE_GESTION.migrar_BI_dim_dia
DROP PROCEDURE G_DE_GESTION.migrar_BI_dim_region
DROP PROCEDURE G_DE_GESTION.migrar_BI_dim_rango_horario
DROP PROCEDURE G_DE_GESTION.migrar_BI_dim_rango_etario
DROP PROCEDURE G_DE_GESTION.migrar_BI_dim_tipo_local
DROP PROCEDURE G_DE_GESTION.migrar_BI_dim_local
DROP PROCEDURE G_DE_GESTION.migrar_BI_dim_tipo_medio_pago
DROP PROCEDURE G_DE_GESTION.migrar_BI_dim_tipo_movilidad
DROP PROCEDURE G_DE_GESTION.migrar_BI_dim_tipo_paquete
DROP PROCEDURE G_DE_GESTION.migrar_BI_dim_estado_pedido
DROP PROCEDURE G_DE_GESTION.migrar_BI_dim_estado_envio_mensajeria
DROP PROCEDURE G_DE_GESTION.migrar_BI_dim_estado_reclamo
DROP PROCEDURE G_DE_GESTION.migrar_BI_hecho_pedidos
GO





/*
CREATE TABLE G_DE_GESTION.BI_Telemetria 
(
	tele_codigo INT PRIMARY KEY,
	tele_auto INT NOT NULL, --(fk)
	tele_carrera INT NOT NULL,--(fk)
	tele_sector INT NOT NULL,--(fk)
	tele_numero_vuelta DECIMAL(18, 0) NOT NULL,
	tele_distancia_vuelta DECIMAL(18, 2) NOT NULL,
	tele_distancia_carrera DECIMAL(18, 6) NOT NULL,
	tele_posicion  DECIMAL(18, 0) NOT NULL,
	tele_tiempo_vuelta  DECIMAL(18, 10) NOT NULL ,
	tele_velocidad DECIMAL(18, 2) NOT NULL,
	tele_combustible DECIMAL(18, 2) NOT NULL,
	tele_vuelta INT NOT NULL, --(fk)
)

-- Insert Data

INSERT INTO G_DE_GESTION.BI_Carrera
SELECT 
	carr_codigo,
	carr_fecha,
	carr_circuito
FROM G_DE_GESTION.Carrera


INSERT INTO G_DE_GESTION.BI_Auto
SELECT DISTINCT auto_codigo, auto_escuderia FROM G_DE_GESTION.Auto

INSERT INTO G_DE_GESTION.BI_Vuelta -- Las distintas vueltas que tiene un circuito
SELECT DISTINCT tele_numero_vuelta, c.carr_circuito
FROM G_DE_GESTION.Telemetria t INNER JOIN G_DE_GESTION.Carrera c ON t.tele_carrera = c.carr_codigo
ORDER BY c.carr_circuito

INSERT INTO G_DE_GESTION.BI_Circuito
SELECT circ_codigo, circ_nombre FROM G_DE_GESTION.Circuito

INSERT INTO G_DE_GESTION.BI_Sector
SELECT 
	sect_codigo,
	sect_tipo,
	sect_tipo_nombre
FROM G_DE_GESTION.Sector
JOIN G_DE_GESTION.Sector_Tipo ON sect_tipo = sect_tipo_codigo

INSERT INTO G_DE_GESTION.BI_Escuderia
SELECT escu_codigo, escu_nombre FROM G_DE_GESTION.Escuderia

INSERT INTO G_DE_GESTION.BI_Telemetria
SELECT
	tele_codigo,
	tele_auto, 
	tele_carrera,
	tele_sector, 
	tele_numero_vuelta,
	tele_distancia_vuelta,
	tele_distancia_carrera,
	tele_posicion,
	tele_tiempo_vuelta,
	tele_velocidad,
	tele_combustible,
	BI_Vuelta_codigo
FROM G_DE_GESTION.Telemetria
JOIN G_DE_GESTION.BI_Carrera ON carr_codigo = tele_carrera
JOIN G_DE_GESTION.BI_Vuelta ON tele_numero_vuelta = vuelta_numero AND carr_circuito = vuelta_circuito


  --------------------------------------
  --------- TABLAS DE HECHOS -----------
  --------------------------------------

	-- Tabla de hechos de vuelta --
	---------------------------------

	CREATE TABLE G_DE_GESTION.BI_Performance
	(
		tiempo INT NOT NULL, -- (fk)
		auto INT NOT NULL, -- (fk)
		circuito INT NOT NULL, -- (FK)
		escuderia INT NOT NULL, --(FK)
		vuelta INT NOT NULL, --(FK)
		combustible_gastado DECIMAL(12,2),
		tiempo_vuela DECIMAL(12,2),
		velocidad_maxima DECIMAL(12,2),
		velocidad_maxima_frenada DECIMAL(12,2),
		velocidad_maxima_recta DECIMAL(12,2),
		velocidad_maxima_curva DECIMAL(12,2),
		desgaste_neu_izq_tra DECIMAL(12,2),
		desgaste_neu_der_tra DECIMAL(12,2),
		desgaste_neu_izq_del DECIMAL(12,2),
		desgaste_neu_der_del DECIMAL(12,2),
		desgaste_fre_izq_tra DECIMAL(12,2),
		desgaste_fre_der_tra DECIMAL(12,2),
		desgaste_fre_izq_del DECIMAL(12,2),
		desgaste_fre_der_del DECIMAL(12,2),
		desgaste_caja DECIMAL(12,2),
		desgaste_motor DECIMAL(12,2)			
	)
	
	INSERT INTO G_DE_GESTION.BI_Performance
	SELECT
		tbi.codigo,
		t.tele_auto,
		c.carr_circuito,
		a.auto_escuderia,
		t.tele_vuelta,
		(
			SELECT MAX(tele_combustible) - MIN(tele_combustible) FROM G_DE_GESTION.BI_Telemetria
			WHERE tele_vuelta = t.tele_vuelta AND tele_auto = T.tele_auto
			GROUP BY tele_vuelta
		),
			CASE 
		WHEN (
				SELECT MAX(t2.tele_tiempo_vuelta) FROM G_DE_GESTION.BI_Telemetria t2
				WHERE tele_vuelta = t.tele_vuelta AND tele_auto = T.tele_auto
				GROUP BY t2.tele_vuelta
			) = 0 THEN NULL 
				ELSE
			(
				SELECT MAX(t2.tele_tiempo_vuelta) FROM G_DE_GESTION.BI_Telemetria t2
				WHERE tele_vuelta = t.tele_vuelta AND tele_auto = T.tele_auto
				GROUP BY t2.tele_vuelta
			)
		END,
		MAX(t.tele_velocidad),
		(	
			SELECT MAX(tele_velocidad) FROM G_DE_GESTION.BI_Telemetria
			JOIN G_DE_GESTION.BI_Sector ON tele_sector = BI_sector_codigo
			WHERE tele_vuelta = t.tele_vuelta AND tele_auto = T.tele_auto AND sect_tipo_codigo = 1 -- Sector frenada
			GROUP BY tele_vuelta
		),
		(	
			SELECT MAX(tele_velocidad) FROM G_DE_GESTION.BI_Telemetria
			JOIN G_DE_GESTION.BI_Sector ON tele_sector = BI_sector_codigo
			WHERE tele_vuelta = t.tele_vuelta AND tele_auto = T.tele_auto AND sect_tipo_codigo = 2 -- Sector recta
			GROUP BY tele_vuelta
		),
		(	
			SELECT MAX(tele_velocidad) FROM G_DE_GESTION.BI_Telemetria
			JOIN G_DE_GESTION.BI_Sector ON tele_sector = BI_sector_codigo
			WHERE tele_vuelta = t.tele_vuelta AND tele_auto = T.tele_auto AND sect_tipo_codigo = 3 -- Sector curva
			GROUP BY tele_vuelta
		),
		(
			SELECT MAX(neum_tele_profundidad) - MIN(neum_tele_profundidad) FROM G_DE_GESTION.BI_Telemetria
			JOIN G_DE_GESTION.Neumatico_Tele ON tele_codigo = neum_tele_codigo
			WHERE tele_auto = T.tele_auto AND t.tele_vuelta = tele_vuelta
			AND neum_tele_posicion = 'Trasero Izquierdo'
			GROUP BY tele_vuelta	
		),
		(
			SELECT MAX(neum_tele_profundidad) - MIN(neum_tele_profundidad) FROM G_DE_GESTION.BI_Telemetria
			JOIN G_DE_GESTION.Neumatico_Tele ON tele_codigo = neum_tele_codigo
			WHERE tele_auto = T.tele_auto AND t.tele_vuelta = tele_vuelta
			AND neum_tele_posicion = 'Trasero Derecho'
			GROUP BY tele_vuelta	
		),
		(
			SELECT MAX(neum_tele_profundidad) - MIN(neum_tele_profundidad) FROM G_DE_GESTION.BI_Telemetria
			JOIN G_DE_GESTION.Neumatico_Tele ON tele_codigo = neum_tele_codigo
			WHERE tele_auto = T.tele_auto AND t.tele_vuelta = tele_vuelta
			AND neum_tele_posicion = 'Delantero Izquierdo'
			GROUP BY tele_vuelta	
		),
		(
			SELECT MAX(neum_tele_profundidad) - MIN(neum_tele_profundidad) FROM G_DE_GESTION.BI_Telemetria
			JOIN G_DE_GESTION.Neumatico_Tele ON tele_codigo = neum_tele_codigo
			WHERE tele_auto = T.tele_auto AND t.tele_vuelta = tele_vuelta
			AND neum_tele_posicion = 'Delantero Derecho'
			GROUP BY tele_vuelta	
		),
		(
			SELECT MAX(freno_tele_pastilla) - MIN(freno_tele_pastilla) FROM G_DE_GESTION.BI_Telemetria
			JOIN G_DE_GESTION.Freno_Tele ON tele_codigo = freno_tele_codigo
			WHERE tele_auto = T.tele_auto AND t.tele_vuelta = tele_vuelta
			AND freno_tele_posicion = 'Trasero Izquierdo'
			GROUP BY tele_vuelta	
		),
		(
			SELECT MAX(freno_tele_pastilla) - MIN(freno_tele_pastilla) FROM G_DE_GESTION.BI_Telemetria
			JOIN G_DE_GESTION.Freno_Tele ON tele_codigo = freno_tele_codigo
			WHERE tele_auto = T.tele_auto AND t.tele_vuelta = tele_vuelta
			AND freno_tele_posicion = 'Trasero Derecho'
			GROUP BY tele_vuelta	
		),
		(
			SELECT MAX(freno_tele_pastilla) - MIN(freno_tele_pastilla) FROM G_DE_GESTION.BI_Telemetria
			JOIN G_DE_GESTION.Freno_Tele ON tele_codigo = freno_tele_codigo
			WHERE tele_auto = T.tele_auto AND t.tele_vuelta = tele_vuelta
			AND freno_tele_posicion = 'Delantero Izquierdo'
			GROUP BY tele_vuelta	
		),
		(
			SELECT MAX(freno_tele_pastilla) - MIN(freno_tele_pastilla) FROM G_DE_GESTION.BI_Telemetria
			JOIN G_DE_GESTION.Freno_Tele ON tele_codigo = freno_tele_codigo
			WHERE tele_auto = T.tele_auto AND t.tele_vuelta = tele_vuelta
			AND freno_tele_posicion = 'Delantero Derecho'
			GROUP BY tele_vuelta	
		),
		(
			SELECT MAX(caja_tele_desgaste) - MIN(caja_tele_desgaste)FROM G_DE_GESTION.BI_Telemetria
			JOIN G_DE_GESTION.Caja_Tele ON tele_codigo = caja_tele_codigo
			WHERE tele_auto = T.tele_auto AND t.tele_vuelta = tele_vuelta
			GROUP BY tele_vuelta	
		),
		(
			SELECT MAX(motor_tele_potencia) - MIN(motor_tele_potencia) FROM G_DE_GESTION.BI_Telemetria
			JOIN G_DE_GESTION.Motor_Tele ON tele_codigo = motor_tele_codigo
			WHERE tele_auto = T.tele_auto AND t.tele_vuelta = tele_vuelta
			GROUP BY tele_vuelta		
		)	
		
	FROM G_DE_GESTION.BI_Telemetria t
	JOIN G_DE_GESTION.BI_Carrera c ON t.tele_carrera = c.carr_codigo
	JOIN G_DE_GESTION.BI_Auto a ON a.auto_codigo = t.tele_auto
	JOIN G_DE_GESTION.BI_dim_tiempo tbi	ON YEAR(c.carr_fecha) = tbi.anio AND DATEPART(Q, c.carr_fecha) = tbi.cuatrimestre AND DATEPART(D, c.carr_fecha) = tbi.dia
	GROUP BY t.tele_vuelta, tbi.codigo, t.tele_auto, c.carr_circuito, a.auto_escuderia
	ORDER BY 1, 2, 3, 4, 5
	
	ALTER TABLE G_DE_GESTION.BI_Performance
	ADD FOREIGN KEY (tiempo) REFERENCES G_DE_GESTION.BI_dim_tiempo
	ALTER TABLE G_DE_GESTION.BI_Performance
	ADD FOREIGN KEY (auto) REFERENCES G_DE_GESTION.BI_Auto
	ALTER TABLE G_DE_GESTION.BI_Performance
	ADD FOREIGN KEY (escuderia) REFERENCES G_DE_GESTION.BI_Escuderia
	ALTER TABLE G_DE_GESTION.BI_Performance
	ADD FOREIGN KEY (vuelta) REFERENCES G_DE_GESTION.BI_Vuelta
	ALTER TABLE G_DE_GESTION.BI_Performance
	ADD FOREIGN KEY (circuito) REFERENCES G_DE_GESTION.BI_Circuito
	GO

	-- Vistas de tabla de hechos de Incidentes
		
		CREATE VIEW G_DE_GESTION.Desgaste AS
		SELECT 
			v.auto [Auto],
			v.circuito [Circuito],
			v.vuelta [Vuelta],
			AVG(desgaste_caja) [Desgaste Caja],
			AVG(desgaste_motor) [Desgaste Motor],
			AVG(desgaste_fre_der_del) [Desgaste Freno der-del],
			AVG(desgaste_fre_der_tra) [Desgaste Freno dre-tra],
			AVG(desgaste_fre_izq_del) [Desgaste Freno izq-del],
			AVG(desgaste_fre_izq_tra) [Desgaste Freno izq-tra],
			AVG(desgaste_neu_der_del) [Desgaste der-del],
			AVG(desgaste_neu_der_tra) [Desgaste dre-tra],
			AVG(desgaste_neu_izq_del) [Desgaste izq-del],
			AVG(desgaste_neu_izq_tra) [Desgaste izq-tra]
		FROM G_DE_GESTION.BI_Performance v
		GROUP BY v.auto, v.circuito, v.vuelta
		GO

		CREATE VIEW G_DE_GESTION.Mejor_tiempo_vuelta AS
		SELECT 
			t.anio [Año],
			v.circuito [Circuito],
			v.escuderia [Escuderia],
			MIN(tiempo_vuela) [Mejor Tiempo Vuelta]
		FROM G_DE_GESTION.BI_Performance v
		JOIN G_DE_GESTION.BI_dim_tiempo T ON t.codigo = v.tiempo
		GROUP BY t.anio, circuito, escuderia
		GO

		CREATE VIEW G_DE_GESTION.Circuitos_mayor_combustible AS
		SELECT TOP 3
			v.circuito [Circuito],
			SUM(combustible_gastado) [Combustible  Gastado]
		FROM G_DE_GESTION.BI_Performance v
		GROUP BY circuito
		ORDER BY SUM(combustible_gastado) DESC
		GO

		CREATE VIEW G_DE_GESTION.Mayor_velocidad_por_sector AS
		SELECT 
			v.circuito [Circuito],
			MAX(v.velocidad_maxima_recta) [Velocidad Maxima Rectas],
			MAX(v.velocidad_maxima_curva) [Velocidad Maxima Curvas],
			MAX(v.velocidad_maxima_frenada) [Velocidad Maxima Frenadas]
		FROM G_DE_GESTION.BI_Performance v
		GROUP BY circuito
		GO


	-- Tabla de hechos de incidente --
	----------------------------------

	CREATE TABLE G_DE_GESTION.BI_Incidente
	(
		fecha INT NOT NULL,
		auto INT NOT NULL, --(FK)
		escuderia INT NOT NULL, --(FK)
		circuito INT NOT NULL, --  (FK)
		incidente INT NOT NULL, -- (FK)
		tipo_sector INT NOT NULL, -- (FK)
		PRIMARY KEY(fecha, auto, circuito, incidente, tipo_sector)
	)
	GO

	INSERT INTO G_DE_GESTION.BI_Incidente
	SELECT
		tbi.codigo,
		ii.invo_auto,
		a.auto_escuderia,
		c.carr_circuito,
		i.inci_codigo,
		s.sect_tipo
	FROM G_DE_GESTION.Involucrados_Incidente ii
	JOIN G_DE_GESTION.Incidente i ON ii.invo_incidente = i.inci_codigo
	JOIN G_DE_GESTION.Carrera c ON i.inci_carrera = c.carr_codigo
	JOIN G_DE_GESTION.Auto a ON ii.invo_auto = a.auto_codigo
	JOIN G_DE_GESTION.Sector s on i.inci_sector = s.sect_codigo
	JOIN G_DE_GESTION.BI_dim_tiempo tbi	ON YEAR(c.carr_fecha) = tbi.anio AND DATEPART(Q, c.carr_fecha) = tbi.cuatrimestre AND DATEPART(D, c.carr_fecha) = tbi.dia

	ALTER TABLE G_DE_GESTION.BI_Incidente
	ADD FOREIGN KEY (auto) REFERENCES G_DE_GESTION.Auto
	ALTER TABLE G_DE_GESTION.BI_Incidente
	ADD FOREIGN KEY (escuderia) REFERENCES G_DE_GESTION.Escuderia
	ALTER TABLE G_DE_GESTION.BI_Incidente
	ADD FOREIGN KEY (circuito) REFERENCES G_DE_GESTION.Circuito
	ALTER TABLE G_DE_GESTION.BI_Incidente
	ADD FOREIGN KEY (incidente) REFERENCES G_DE_GESTION.Incidente
	ALTER TABLE G_DE_GESTION.BI_Incidente
	ADD FOREIGN KEY (tipo_sector) REFERENCES G_DE_GESTION.Sector_Tipo
	GO

	-- Vistas de tabla de hechos de Incidentes

		CREATE VIEW G_DE_GESTION.Circuitos_Mas_Peligrosos AS
		SELECT 
			t.anio [Año],
			i.circuito [Circuito],
			COUNT(DISTINCT i.incidente) [Cantidad de Incidentes]
		FROM G_DE_GESTION.BI_Incidente i
		JOIN G_DE_GESTION.BI_dim_tiempo t ON i.fecha = t.codigo
		WHERE CONVERT(CHAR(4), t.anio) + CONVERT(CHAR(4), i.circuito) IN (
				SELECT TOP 3
					CONVERT(CHAR(4), T2.anio) + 
					CONVERT(CHAR(4), I2.circuito)	
				FROM G_DE_GESTION.BI_Incidente I2
				JOIN G_DE_GESTION.BI_dim_tiempo t2 ON I2.fecha = T2.codigo
				where t.anio = t2.anio 
				GROUP BY t2.anio, i2.circuito
				ORDER BY COUNT(DISTINCT i2.incidente)
			)
		GROUP BY t.anio, i.circuito
		GO

		CREATE VIEW G_DE_GESTION.Incidentes_Escuderia_Tipo_Sector AS
		SELECT
			t.anio [Año],
			i.escuderia [Escuderia],
			i.tipo_sector [Tipo de Sector],
			COUNT(i.incidente) [Cantidad de Incidentes]
		FROM G_DE_GESTION.BI_Incidente i
		JOIN G_DE_GESTION.BI_dim_tiempo t ON t.codigo = i.fecha
		GROUP BY t.anio, i.escuderia, i.tipo_sector
		GO
 

	-- Tabla de hechos de parada --
	-------------------------------

	CREATE TABLE G_DE_GESTION.BI_Parada
	(
		fecha CHAR(4) NOT NULL,
		auto INT NOT NULL, -- (FK)
		escuderia INT NOT NULL, --  (FK)
		circuito INT NOT NULL, --  (FK)
		parada INT NOT NULL, -- (FK)
		tiempo_parada DECIMAL(12,2) NOT NULL
		PRIMARY KEY(fecha, auto, escuderia, circuito, parada)
	)

	INSERT INTO G_DE_GESTION.BI_Parada
	SELECT 
		tbi.codigo,
		a.auto_codigo,
		a.auto_escuderia,
		c.carr_circuito,
		p.para_codigo,
		p.para_tiempo
	FROM G_DE_GESTION.Parada p
	JOIN G_DE_GESTION.Carrera c ON p.para_carrera = c.carr_codigo
	JOIN G_DE_GESTION.Auto a ON p.para_auto = a.auto_codigo 
	JOIN G_DE_GESTION.BI_dim_tiempo tbi	ON YEAR(c.carr_fecha) = tbi.anio AND DATEPART(Q, c.carr_fecha) = tbi.cuatrimestre AND DATEPART(D, c.carr_fecha) = tbi.dia

	ALTER TABLE G_DE_GESTION.BI_Parada
	ADD FOREIGN KEY (auto) REFERENCES G_DE_GESTION.Auto
	ALTER TABLE G_DE_GESTION.BI_Parada
	ADD FOREIGN KEY (escuderia) REFERENCES G_DE_GESTION.Escuderia
	ALTER TABLE G_DE_GESTION.BI_Parada
	ADD FOREIGN KEY (circuito) REFERENCES G_DE_GESTION.Circuito
	ALTER TABLE G_DE_GESTION.BI_Parada
	ADD FOREIGN KEY (parada) REFERENCES G_DE_GESTION.Parada
	GO

	-- Vistas de tabla de hechos de Paradas
		
		CREATE VIEW G_DE_GESTION.Tiempo_Promedio_En_Paradas AS
		SELECT 
			t.cuatrimestre [Cuatrimestre],
			p.escuderia [Escuderia],
			AVG(p.tiempo_parada) [Tiempo Promedio En Paradas]
		FROM G_DE_GESTION.BI_Parada p
		JOIN G_DE_GESTION.BI_dim_tiempo	t ON T.codigo = p.fecha
		GROUP BY t.cuatrimestre, p.escuderia
		GO

		CREATE VIEW G_DE_GESTION.Cant_Paradas_Circuito_Escuderia AS
		SELECT 
			t.anio [Año], 
			p.circuito [Circuito],
			p.escuderia [Escuderia],
			COUNT(p.parada) [Cantidad de Paradas]
		FROM G_DE_GESTION.BI_Parada p
		JOIN G_DE_GESTION.BI_dim_tiempo	t ON T.codigo = p.fecha
		GROUP BY t.anio, p.circuito, p.escuderia
		GO

		CREATE VIEW G_DE_GESTION.Circuitos_Mayor_Tiempo_Boxes AS
		SELECT TOP 3
			p.circuito [Circuito],
			SUM(p.tiempo_parada) [Tiempo En Parada]
		FROM G_DE_GESTION.BI_Parada p
		GROUP BY p.circuito
		GO

		*/
--------------------------------------
--------------- TESTS ----------------
--------------------------------------

-- SELECT * FROM G_DE_GESTION.Circuitos_Mas_Peligrosos
-- SELECT * FROM G_DE_GESTION.Incidentes_Escuderia_Tipo_Sector
-- SELECT * FROM G_DE_GESTION.Tiempo_Promedio_En_Paradas
-- SELECT * FROM G_DE_GESTION.Cant_Paradas_Circuito_Escuderia
-- SELECT * FROM G_DE_GESTION.Circuitos_Mayor_Tiempo_Boxes
-- SELECT * FROM G_DE_GESTION.Circuitos_mayor_combustible
-- SELECT * FROM G_DE_GESTION.Desgaste
-- SELECT * FROM G_DE_GESTION.Mayor_velocidad_por_sector 
-- SELECT * FROM G_DE_GESTION.Mejor_tiempo_vuelta 

