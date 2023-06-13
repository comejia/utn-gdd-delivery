USE GD1C2023
GO

IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'G_DE_GESTION')
	THROW 51000, 'No se encontro esquema G_DE_GESTION. Ejecutar primero script_creacion_inicial.sql', 1
GO

IF OBJECT_ID('G_DE_GESTION.v_monto_total_no_cobrado_local', 'V') IS NOT NULL DROP VIEW G_DE_GESTION.v_monto_total_no_cobrado_local
IF OBJECT_ID('G_DE_GESTION.v_valor_promedio_envio', 'V') IS NOT NULL DROP VIEW G_DE_GESTION.v_valor_promedio_envio
IF OBJECT_ID('G_DE_GESTION.v_monto_total_cupones_utilizados', 'V') IS NOT NULL DROP VIEW G_DE_GESTION.v_monto_total_cupones_utilizados
IF OBJECT_ID('G_DE_GESTION.v_promedio_calificacion', 'V') IS NOT NULL DROP VIEW G_DE_GESTION.v_promedio_calificacion

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
	pedido_total_servicio DECIMAL(18,2) NOT NULL,
	pedido_precio_envio DECIMAL(18,2) NOT NULL,
	pedido_total_cupones DECIMAL(18,2) NOT NULL,
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


----- Vistas -----
CREATE VIEW G_DE_GESTION.v_monto_total_no_cobrado_local AS
	SELECT
		dl.local_nombre local,
		dd.dia dia,
		STR(drh.rango_horario_inicio, 2, 0) + '-' + STR(drh.rango_horario_fin, 2, 0) rango_horario,
		SUM(hp.pedido_total_servicio) monto_no_cobrado
	FROM G_DE_GESTION.BI_hecho_pedidos hp
	JOIN G_DE_GESTION.BI_dim_local dl ON (dl.local_id = hp.local_id)
	JOIN G_DE_GESTION.BI_dim_estado_pedido dep ON (dep.estado_pedido_id = hp.estado_pedido_id)
	JOIN G_DE_GESTION.BI_dim_dia dd ON (dd.dia_id = hp.dia_id)
	JOIN G_DE_GESTION.BI_dim_rango_horario drh ON (drh.rango_horario_id = hp.rango_horario_id)
	WHERE dep.estado_pedido_descripcion = 'Estado Mensajeria Cancelado'
	GROUP BY
		dl.local_nombre,
		dd.dia,
		STR(drh.rango_horario_inicio, 2, 0) + '-' + STR(drh.rango_horario_fin, 2, 0)
GO

CREATE VIEW G_DE_GESTION.v_monto_total_cupones_utilizados AS
	SELECT
		dt.mes,
		dre.rango_etario,
		SUM(hp.pedido_total_cupones) monto_total_cupones
	FROM G_DE_GESTION.BI_hecho_pedidos hp
	JOIN G_DE_GESTION.BI_dim_tiempo dt ON (dt.tiempo_id = hp.tiempo_id)
	JOIN G_DE_GESTION.BI_dim_rango_etario dre ON (dre.rango_etario_id = hp.rango_etario_id)
	GROUP BY
		dt.mes,
		dre.rango_etario
GO

CREATE VIEW G_DE_GESTION.v_valor_promedio_envio AS
	SELECT
		dt.mes,
		dr.localidad_descripcion localidad,
		AVG(hp.pedido_precio_envio) valor_promedio_envio
	FROM G_DE_GESTION.BI_hecho_pedidos hp
	JOIN G_DE_GESTION.BI_dim_tiempo dt ON (dt.tiempo_id = hp.tiempo_id)
	JOIN G_DE_GESTION.BI_dim_region dr ON (dr.region_id = hp.region_id)
	GROUP BY
		dt.mes,
		dr.localidad_descripcion
GO

CREATE VIEW G_DE_GESTION.v_promedio_calificacion AS
	SELECT
		dt.mes,
		dl.local_nombre local,
		AVG(hp.pedido_calificacion) promedio_calificacion
	FROM G_DE_GESTION.BI_hecho_pedidos hp
	JOIN G_DE_GESTION.BI_dim_tiempo dt ON (dt.tiempo_id = hp.tiempo_id)
	JOIN G_DE_GESTION.BI_dim_local dl ON (dl.local_id = hp.local_id)
	GROUP BY
		dt.mes,
		dl.local_nombre
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


----- Test Views -----
/*SELECT * FROM G_DE_GESTION.v_monto_total_no_cobrado_local
SELECT * FROM G_DE_GESTION.v_monto_total_cupones_utilizados
SELECT * FROM G_DE_GESTION.v_valor_promedio_envio
SELECT * FROM G_DE_GESTION.v_promedio_calificacion
GO
*/
