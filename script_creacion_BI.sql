USE GD1C2023
GO

IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'G_DE_GESTION')
	THROW 51000, 'No se encontro esquema G_DE_GESTION. Ejecutar primero script_creacion_inicial.sql', 1
GO

IF OBJECT_ID('G_DE_GESTION.v_monto_total_no_cobrado_local', 'V') IS NOT NULL DROP VIEW G_DE_GESTION.v_monto_total_no_cobrado_local
IF OBJECT_ID('G_DE_GESTION.v_valor_promedio_envio', 'V') IS NOT NULL DROP VIEW G_DE_GESTION.v_valor_promedio_envio
IF OBJECT_ID('G_DE_GESTION.v_monto_total_cupones_utilizados', 'V') IS NOT NULL DROP VIEW G_DE_GESTION.v_monto_total_cupones_utilizados
IF OBJECT_ID('G_DE_GESTION.v_promedio_calificacion', 'V') IS NOT NULL DROP VIEW G_DE_GESTION.v_promedio_calificacion
IF OBJECT_ID('G_DE_GESTION.v_desvio_promedio_entrega', 'V') IS NOT NULL DROP VIEW G_DE_GESTION.v_desvio_promedio_entrega
IF OBJECT_ID('G_DE_GESTION.v_porcentaje_entrega', 'V') IS NOT NULL DROP VIEW G_DE_GESTION.v_porcentaje_entrega
IF OBJECT_ID('G_DE_GESTION.v_promedio_mensual_valor_asegurado', 'V') IS NOT NULL DROP VIEW G_DE_GESTION.v_promedio_mensual_valor_asegurado
IF OBJECT_ID('G_DE_GESTION.v_cantidad_reclamos_recibidos', 'V') IS NOT NULL DROP VIEW G_DE_GESTION.v_cantidad_reclamos_recibidos
IF OBJECT_ID('G_DE_GESTION.v_tiempo_promedio_resolucion', 'V') IS NOT NULL DROP VIEW G_DE_GESTION.v_tiempo_promedio_resolucion
IF OBJECT_ID('G_DE_GESTION.v_monto_generado_cupones', 'V') IS NOT NULL DROP VIEW G_DE_GESTION.v_monto_generado_cupones

IF OBJECT_ID('G_DE_GESTION.BI_hecho_pedidos', 'U') IS NOT NULL DROP TABLE G_DE_GESTION.BI_hecho_pedidos
IF OBJECT_ID('G_DE_GESTION.BI_hecho_entregas', 'U') IS NOT NULL DROP TABLE G_DE_GESTION.BI_hecho_entregas
IF OBJECT_ID('G_DE_GESTION.BI_hecho_mensajeria', 'U') IS NOT NULL DROP TABLE G_DE_GESTION.BI_hecho_mensajeria
IF OBJECT_ID('G_DE_GESTION.BI_hecho_reclamos', 'U') IS NOT NULL DROP TABLE G_DE_GESTION.BI_hecho_reclamos

IF OBJECT_ID('G_DE_GESTION.BI_dim_tiempo', 'U') IS NOT NULL DROP TABLE G_DE_GESTION.BI_dim_tiempo
IF OBJECT_ID('G_DE_GESTION.BI_dim_dia', 'U') IS NOT NULL DROP TABLE G_DE_GESTION.BI_dim_dia
IF OBJECT_ID('G_DE_GESTION.BI_dim_rango_horario', 'U') IS NOT NULL DROP TABLE G_DE_GESTION.BI_dim_rango_horario
IF OBJECT_ID('G_DE_GESTION.BI_dim_rango_etario', 'U') IS NOT NULL DROP TABLE G_DE_GESTION.BI_dim_rango_etario
IF OBJECT_ID('G_DE_GESTION.BI_dim_local', 'U') IS NOT NULL DROP TABLE G_DE_GESTION.BI_dim_local
IF OBJECT_ID('G_DE_GESTION.BI_dim_region', 'U') IS NOT NULL DROP TABLE G_DE_GESTION.BI_dim_region
IF OBJECT_ID('G_DE_GESTION.BI_dim_tipo_local', 'U') IS NOT NULL DROP TABLE G_DE_GESTION.BI_dim_tipo_local
IF OBJECT_ID('G_DE_GESTION.BI_dim_tipo_medio_pago', 'U') IS NOT NULL DROP TABLE G_DE_GESTION.BI_dim_tipo_medio_pago
IF OBJECT_ID('G_DE_GESTION.BI_dim_tipo_reclamo', 'U') IS NOT NULL DROP TABLE G_DE_GESTION.BI_dim_tipo_reclamo
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

CREATE TABLE G_DE_GESTION.BI_dim_region(
	region_id DECIMAL(18,0) IDENTITY(1,1) PRIMARY KEY,
	provincia_descripcion NVARCHAR(255) NOT NULL,
	localidad_descripcion NVARCHAR(255) NOT NULL
)
GO

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

CREATE TABLE G_DE_GESTION.BI_dim_tipo_local(
	tipo_local_id DECIMAL(18,0) IDENTITY(1,1) PRIMARY KEY,
	tipo_local_descripcion NVARCHAR(50) NOT NULL,
	categoria_descripcion NVARCHAR(50)
)
GO

CREATE TABLE G_DE_GESTION.BI_dim_local(
	local_id DECIMAL(18,0) IDENTITY(1,1) PRIMARY KEY,
	local_nombre NVARCHAR(100) NOT NULL,
	localidad_descripcion NVARCHAR(255) NOT NULL,
	provincia_descripcion NVARCHAR(255) NOT NULL,
	categoria_descripcion NVARCHAR(50),
	tipo_local_descripcion NVARCHAR(50)
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

CREATE TABLE G_DE_GESTION.BI_dim_tipo_reclamo (
	tipo_reclamo_id DECIMAL(18,0) IDENTITY(1,1) PRIMARY KEY,
	tipo_reclamo_descripcion NVARCHAR(50) NOT NULL
)
GO


----- Hechos ----
CREATE TABLE G_DE_GESTION.BI_hecho_pedidos (
	dia_id DECIMAL(18,0),
	local_id DECIMAL(18,0),
	rango_horario_id INT,
	region_id DECIMAL(18,0),
	rango_etario_id INT,
	tiempo_id DECIMAL(18,0),
	estado_pedido_id DECIMAL(18,0),
	tipo_local_id DECIMAL(18,0),
	cantidad_pedidos DECIMAL(18,0) NOT NULL,
	pedido_total_servicio DECIMAL(18,2) NOT NULL,
	pedido_precio_envio DECIMAL(18,2) NOT NULL,
	pedido_total_cupones DECIMAL(18,2) NOT NULL,
	pedido_calificacion DECIMAL(18,0) NOT NULL,
	PRIMARY KEY(dia_id, local_id, rango_horario_id, region_id, rango_etario_id, tiempo_id, estado_pedido_id)
)
GO

CREATE TABLE G_DE_GESTION.BI_hecho_entregas (
	tipo_movilidad_id DECIMAL(18,0),
	dia_id DECIMAL(18,0),
	rango_horario_id INT,
	tiempo_id DECIMAL(18,0),
	rango_etario_id INT,
	region_id DECIMAL(18,0),
	cantidad_entregas DECIMAL(18,0) NOT NULL,
	desvio_entrega DECIMAL(18,0) NOT NULL,
	tiempo_estimado DECIMAL(18,2) NOT NULL,
	PRIMARY KEY(tipo_movilidad_id, dia_id, rango_horario_id, tiempo_id, rango_etario_id, region_id)
)
GO

CREATE TABLE G_DE_GESTION.BI_hecho_mensajeria (
	tiempo_id DECIMAL(18,0),
	tipo_paquete_id DECIMAL(18,0),
	estado_envio_mensajeria_id DECIMAL(18,0),
	cantidad DECIMAL(18,0) NOT NULL,
	envio_mensajeria_valor_asegurado DECIMAL(18,2) NOT NULL
	PRIMARY KEY(tiempo_id, tipo_paquete_id, estado_envio_mensajeria_id)
)
GO

CREATE TABLE G_DE_GESTION.BI_hecho_reclamos (
	tiempo_id DECIMAL(18,0),
	rango_horario_id INT,
	dia_id DECIMAL(18,0),
	local_id DECIMAL(18,0),
	tipo_reclamo_id DECIMAL(18,0),
	rango_etario_id INT,
	cantidad_reclamos DECIMAL(18,0) NOT NULL,
	tiempo_resolucion DECIMAL(18,0) NOT NULL,
	total_cupones DECIMAL(18,2) NOT NULL,
	PRIMARY KEY(tiempo_id, rango_horario_id, dia_id, local_id, tipo_reclamo_id, rango_etario_id)
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
			END
			ELSE
			BEGIN
				SET @next_rango = @next_rango + 1
				INSERT INTO G_DE_GESTION.BI_dim_rango_horario(rango_horario_inicio, rango_horario_fin)
				VALUES(@apertura, @next_rango)
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
		localidad_descripcion,
		provincia_descripcion,
		categoria_descripcion,
		tipo_local_descripcion
	)
	SELECT
		l.local_nombre,
		lo.localidad_descripcion,
		p.provincia_descripcion,
		c.categoria_descripcion,
		tl.tipo_local_descripcion
	FROM G_DE_GESTION.local l
	JOIN G_DE_GESTION.localidad lo ON (lo.localidad_id = l.localidad_id)
	JOIN G_DE_GESTION.provincia p ON (p.provincia_id = lo.provincia_id)
	LEFT JOIN G_DE_GESTION.categoria c ON (c.categoria_id = l.categoria_id)
	LEFT JOIN G_DE_GESTION.tipo_local tl ON (tl.tipo_local_id = c.tipo_local_id)
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

CREATE PROCEDURE G_DE_GESTION.migrar_BI_dim_estado_reclamo AS
BEGIN
	INSERT INTO G_DE_GESTION.BI_dim_estado_reclamo(estado_reclamo_descripcion)
	SELECT er.estado_reclamo_descripcion
	FROM G_DE_GESTION.estado_reclamo er
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

CREATE PROCEDURE G_DE_GESTION.migrar_BI_dim_tipo_reclamo AS
BEGIN
	INSERT INTO G_DE_GESTION.BI_dim_tipo_reclamo(tipo_reclamo_descripcion)
	SELECT tr.tipo_reclamo_descripcion
	FROM G_DE_GESTION.tipo_reclamo tr
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
		tipo_local_id,
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
		dr.region_id,
		dre.rango_etario_id,
		dt.tiempo_id,
		dep.estado_pedido_id,
		dtl.tipo_local_id,
		COUNT(*),
		SUM(p.pedido_total_servicio),
		SUM(p.pedido_precio_envio),
		SUM(p.pedido_total_cupones),
		SUM(p.pedido_calificacion)
	FROM G_DE_GESTION.pedido p
	JOIN G_DE_GESTION.BI_dim_dia dd ON (dd.dia_id = DATEPART(DW, p.pedido_fecha))
	JOIN G_DE_GESTION.BI_dim_local dl ON (dl.local_id = p.local_id)
	JOIN G_DE_GESTION.BI_dim_rango_horario drh ON (DATEPART(HOUR, p.pedido_fecha) >= drh.rango_horario_inicio
												AND DATEPART(HOUR, p.pedido_fecha) <= drh.rango_horario_fin)
	JOIN G_DE_GESTION.BI_dim_region dr ON (dr.localidad_descripcion = dl.localidad_descripcion AND dr.provincia_descripcion = dl.provincia_descripcion)
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
	LEFT JOIN G_DE_GESTION.BI_dim_tipo_local dtl ON (dtl.categoria_descripcion = dl.categoria_descripcion AND dtl.tipo_local_descripcion = dl.tipo_local_descripcion)
	GROUP BY
		dd.dia_id,
		dl.local_id,
		drh.rango_horario_id,
		dr.region_id,
		dre.rango_etario_id,
		dt.tiempo_id,
		dep.estado_pedido_id,
		dtl.tipo_local_id
END
GO

CREATE PROCEDURE G_DE_GESTION.migrar_BI_hecho_entregas AS
BEGIN
	INSERT INTO G_DE_GESTION.BI_hecho_entregas(
		tipo_movilidad_id,
		dia_id,
		rango_horario_id,
		tiempo_id,
		rango_etario_id,
		region_id,
		cantidad_entregas,
		desvio_entrega,
		tiempo_estimado
	)
	SELECT
		dtm.tipo_movilidad_id,
		dd.dia_id,
		drh.rango_horario_id,
		dt.tiempo_id,
		dre.rango_etario_id,
		dr.region_id,
		COUNT(*),
		SUM(DATEDIFF(MINUTE, p.pedido_fecha, p.pedido_fecha_entrega)),
		SUM(p.pedido_tiempo_estimado_entrega)
	FROM G_DE_GESTION.pedido p
	JOIN G_DE_GESTION.BI_dim_local dl ON (dl.local_id = p.local_id)
	JOIN G_DE_GESTION.repartidor r ON (r.repartidor_id = p.repartidor_id)
	JOIN G_DE_GESTION.BI_dim_tipo_movilidad dtm ON (dtm.tipo_movilidad_id = r.tipo_movilidad_id)
	JOIN G_DE_GESTION.BI_dim_dia dd ON (dd.dia_id = DATEPART(DW, p.pedido_fecha))
	JOIN G_DE_GESTION.BI_dim_rango_horario drh ON (DATEPART(HOUR, p.pedido_fecha) >= drh.rango_horario_inicio
												AND DATEPART(HOUR, p.pedido_fecha) <= drh.rango_horario_fin)
	JOIN G_DE_GESTION.BI_dim_tiempo dt ON (dt.anio = YEAR(p.pedido_fecha) AND dt.mes = MONTH(p.pedido_fecha))
	JOIN G_DE_GESTION.BI_dim_rango_etario dre ON (dre.rango_etario =
					(case
						when DATEDIFF(YEAR, r.repartidor_fecha_nac, GETDATE()) < 25 then '<25'
						when DATEDIFF(YEAR, r.repartidor_fecha_nac, GETDATE()) between 25 and 35 then '25-35'
						when DATEDIFF(YEAR, r.repartidor_fecha_nac, GETDATE()) between 35 and 55 then '35-55'
						when DATEDIFF(YEAR, r.repartidor_fecha_nac, GETDATE()) > 55 then '>55'
					end))
	JOIN G_DE_GESTION.BI_dim_region dr ON (dr.localidad_descripcion = dl.localidad_descripcion AND dr.provincia_descripcion = dl.provincia_descripcion)
	JOIN G_DE_GESTION.BI_dim_estado_pedido dep ON (dep.estado_pedido_id = p.estado_pedido_id)
	WHERE dep.estado_pedido_descripcion = 'Estado Mensajeria Entregado'
	GROUP BY
		dtm.tipo_movilidad_id,
		dd.dia_id,
		drh.rango_horario_id,
		dt.tiempo_id,
		dre.rango_etario_id,
		dr.region_id
	UNION
	SELECT
		dtm.tipo_movilidad_id,
		dd.dia_id,
		drh.rango_horario_id,
		dt.tiempo_id,
		dre.rango_etario_id,
		dr.region_id,
		COUNT(*),
		SUM(DATEDIFF(MINUTE, em.envio_mensajeria_fecha, em.envio_mensajeria_fecha_entrega)),
		SUM(em.envio_mensajeria_tiempo_estimado)
	FROM G_DE_GESTION.envio_mensajeria em
	JOIN G_DE_GESTION.localidad l ON (l.localidad_id = em.localidad_id)
	JOIN G_DE_GESTION.provincia p ON (p.provincia_id = l.provincia_id)
	JOIN G_DE_GESTION.BI_dim_region dr ON (dr.localidad_descripcion = l.localidad_descripcion AND dr.provincia_descripcion = p.provincia_descripcion)
	JOIN G_DE_GESTION.repartidor r ON (r.repartidor_id = em.repartidor_id)
	JOIN G_DE_GESTION.BI_dim_tipo_movilidad dtm ON (dtm.tipo_movilidad_id = r.tipo_movilidad_id)
	JOIN G_DE_GESTION.BI_dim_dia dd ON (dd.dia_id = DATEPART(DW, em.envio_mensajeria_fecha))
	JOIN G_DE_GESTION.BI_dim_rango_horario drh ON (DATEPART(HOUR, em.envio_mensajeria_fecha) >= drh.rango_horario_inicio
												AND DATEPART(HOUR, em.envio_mensajeria_fecha) <= drh.rango_horario_fin)
	JOIN G_DE_GESTION.BI_dim_tiempo dt ON (dt.anio = YEAR(em.envio_mensajeria_fecha) AND dt.mes = MONTH(em.envio_mensajeria_fecha))
	JOIN G_DE_GESTION.BI_dim_rango_etario dre ON (dre.rango_etario =
					(case
						when DATEDIFF(YEAR, r.repartidor_fecha_nac, GETDATE()) < 25 then '<25'
						when DATEDIFF(YEAR, r.repartidor_fecha_nac, GETDATE()) between 25 and 35 then '25-35'
						when DATEDIFF(YEAR, r.repartidor_fecha_nac, GETDATE()) between 35 and 55 then '35-55'
						when DATEDIFF(YEAR, r.repartidor_fecha_nac, GETDATE()) > 55 then '>55'
					end))
	JOIN G_DE_GESTION.estado_envio_mensajeria eem ON (eem.estado_envio_mensajeria_id = em.estado_envio_mensajeria_id)
	WHERE eem.estado_envio_mensajeria_descripcion = 'Estado Mensajeria Entregado'
	GROUP BY
		dtm.tipo_movilidad_id,
		dd.dia_id,
		drh.rango_horario_id,
		dt.tiempo_id,
		dre.rango_etario_id,
		dr.region_id
END
GO

CREATE PROCEDURE G_DE_GESTION.migrar_BI_hecho_mensajeria AS
BEGIN
	INSERT INTO G_DE_GESTION.BI_hecho_mensajeria(
		tiempo_id,
		tipo_paquete_id,
		estado_envio_mensajeria_id,
		cantidad,
		envio_mensajeria_valor_asegurado
	)
	SELECT
		dt.tiempo_id,
		dtp.tipo_paquete_id,
		deem.estado_envio_mensajeria_id,
		COUNT(*),
		SUM(em.envio_mensajeria_valor_asegurado)
	FROM G_DE_GESTION.envio_mensajeria em
	JOIN G_DE_GESTION.BI_dim_tiempo dt ON (dt.anio = YEAR(em.envio_mensajeria_fecha) AND dt.mes = MONTH(em.envio_mensajeria_fecha))
	JOIN G_DE_GESTION.paquete p ON (p.paquete_id = em.paquete_id)
	JOIN G_DE_GESTION.BI_dim_tipo_paquete dtp ON (dtp.tipo_paquete_id = p.tipo_paquete_id)
	JOIN G_DE_GESTION.BI_dim_estado_envio_mensajeria deem ON (deem.estado_envio_mensajeria_id = em.estado_envio_mensajeria_id)
	GROUP BY
		dt.tiempo_id,
		dtp.tipo_paquete_id,
		deem.estado_envio_mensajeria_id
END
GO

CREATE PROCEDURE G_DE_GESTION.migrar_BI_hecho_reclamos AS
BEGIN
	INSERT INTO G_DE_GESTION.BI_hecho_reclamos(
		tiempo_id,
		rango_horario_id,
		dia_id,
		local_id,
		tipo_reclamo_id,
		rango_etario_id,
		cantidad_reclamos,
		tiempo_resolucion,
		total_cupones
	)
	SELECT
		dt.tiempo_id,
		drh.rango_horario_id,
		dd.dia_id,
		p.local_id,
		dtr.tipo_reclamo_id,
		dre.rango_etario_id,
		COUNT(*),
		SUM(DATEDIFF(MINUTE, r.reclamo_fecha, r.reclamo_fecha_solucion)),
		SUM(cr.cupon_reclamo_monto)
	FROM G_DE_GESTION.reclamo r
	JOIN G_DE_GESTION.BI_dim_tiempo dt ON (dt.anio = YEAR(r.reclamo_fecha) AND dt.mes = MONTH(r.reclamo_fecha))
	JOIN G_DE_GESTION.BI_dim_rango_horario drh ON (DATEPART(HOUR, r.reclamo_fecha) >= drh.rango_horario_inicio
												AND DATEPART(HOUR, r.reclamo_fecha) <= drh.rango_horario_fin)
	JOIN G_DE_GESTION.BI_dim_dia dd ON (dd.dia_id = DATEPART(DW, r.reclamo_fecha))
	JOIN G_DE_GESTION.pedido p ON (p.pedido_nro = r.pedido_nro)
	JOIN G_DE_GESTION.BI_dim_tipo_reclamo dtr ON (dtr.tipo_reclamo_id = r.tipo_reclamo_id)
	JOIN G_DE_GESTION.operador_reclamo o ON (o.operador_reclamo_id = r.operador_reclamo_id)
	JOIN G_DE_GESTION.BI_dim_rango_etario dre ON (dre.rango_etario =
				(case
					when DATEDIFF(YEAR, o.operador_reclamo_fecha_nac, GETDATE()) < 25 then '<25'
					when DATEDIFF(YEAR, o.operador_reclamo_fecha_nac, GETDATE()) between 25 and 35 then '25-35'
					when DATEDIFF(YEAR, o.operador_reclamo_fecha_nac, GETDATE()) between 35 and 55 then '35-55'
					when DATEDIFF(YEAR, o.operador_reclamo_fecha_nac, GETDATE()) > 55 then '>55'
				end))
	JOIN G_DE_GESTION.cupon_reclamo cr ON (cr.reclamo_nro = r.reclamo_nro)

	GROUP BY
		dt.tiempo_id,
		drh.rango_horario_id,
		dd.dia_id,
		p.local_id,
		dtr.tipo_reclamo_id,
		dre.rango_etario_id
END
GO


----- Vistas -----
CREATE VIEW G_DE_GESTION.v_monto_total_no_cobrado_local AS
	SELECT
		dl.local_nombre local,
		dd.dia,
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

CREATE VIEW G_DE_GESTION.v_valor_promedio_envio AS
	SELECT
		dt.mes,
		dr.localidad_descripcion localidad,
		SUM(hp.pedido_precio_envio) / SUM(hp.cantidad_pedidos) valor_promedio_envio
	FROM G_DE_GESTION.BI_hecho_pedidos hp
	JOIN G_DE_GESTION.BI_dim_tiempo dt ON (dt.tiempo_id = hp.tiempo_id)
	JOIN G_DE_GESTION.BI_dim_region dr ON (dr.region_id = hp.region_id)
	GROUP BY
		dt.mes,
		dr.localidad_descripcion
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

CREATE VIEW G_DE_GESTION.v_promedio_calificacion AS
	SELECT
		dt.mes,
		dl.local_nombre local,
		SUM(hp.pedido_calificacion) / SUM(hp.cantidad_pedidos) promedio_calificacion
	FROM G_DE_GESTION.BI_hecho_pedidos hp
	JOIN G_DE_GESTION.BI_dim_tiempo dt ON (dt.tiempo_id = hp.tiempo_id)
	JOIN G_DE_GESTION.BI_dim_local dl ON (dl.local_id = hp.local_id)
	GROUP BY
		dt.mes,
		dl.local_nombre
GO

CREATE VIEW G_DE_GESTION.v_desvio_promedio_entrega AS
	SELECT
		dtm.tipo_movilidad_descripcion movilidad,
		dd.dia,
		STR(drh.rango_horario_inicio, 2, 0) + '-' + STR(drh.rango_horario_fin, 2, 0) rango_horario,
		SUM(he.desvio_entrega) / SUM(he.tiempo_estimado) desvio_promedio
	FROM G_DE_GESTION.BI_hecho_entregas he
	JOIN G_DE_GESTION.BI_dim_tipo_movilidad dtm ON (dtm.tipo_movilidad_id = he.tipo_movilidad_id)
	JOIN G_DE_GESTION.BI_dim_dia dd ON (dd.dia_id = he.dia_id)
	JOIN G_DE_GESTION.BI_dim_rango_horario drh ON (drh.rango_horario_id = he.rango_horario_id)
	GROUP BY
		dtm.tipo_movilidad_descripcion,
		dd.dia,
		STR(drh.rango_horario_inicio, 2, 0) + '-' + STR(drh.rango_horario_fin, 2, 0)
GO

CREATE VIEW G_DE_GESTION.v_porcentaje_entrega AS
	SELECT
		dt.mes,
		dre.rango_etario,
		dr.localidad_descripcion,
		(SUM(he.cantidad_entregas) / 
			(SELECT COUNT(*) FROM G_DE_GESTION.BI_hecho_entregas he1
			JOIN G_DE_GESTION.BI_dim_tiempo dt1 ON (dt1.tiempo_id = he1.tiempo_id)
			WHERE dt1.anio = dt.anio and dt1.mes = dt.mes)) * 100 AS porcentaje_entrega
	FROM G_DE_GESTION.BI_hecho_entregas he
	JOIN G_DE_GESTION.BI_dim_tiempo dt ON (dt.tiempo_id = he.tiempo_id)
	JOIN G_DE_GESTION.BI_dim_rango_etario dre ON (dre.rango_etario_id = he.rango_etario_id)
	JOIN G_DE_GESTION.BI_dim_region dr ON (dr.region_id = he.region_id)
	GROUP BY
		dt.mes,
		dt.anio,
		dre.rango_etario,
		dr.localidad_descripcion	
GO

CREATE VIEW G_DE_GESTION.v_promedio_mensual_valor_asegurado AS
	SELECT
		dt.mes,
		dtp.tipo_paquete_descripcion tipo_paquete,
		SUM(hm.envio_mensajeria_valor_asegurado) / SUM(hm.cantidad) promedio_valor_asegurado
	FROM G_DE_GESTION.BI_hecho_mensajeria hm
	JOIN G_DE_GESTION.BI_dim_tiempo dt ON (dt.tiempo_id = hm.tiempo_id)
	JOIN G_DE_GESTION.BI_dim_tipo_paquete dtp ON (dtp.tipo_paquete_id = hm.tipo_paquete_id)
	JOIN G_DE_GESTION.BI_dim_estado_envio_mensajeria deem ON (deem.estado_envio_mensajeria_id = hm.estado_envio_mensajeria_id)
	WHERE deem.estado_envio_mensajeria_descripcion = 'Estado Mensajeria Entregado'
	GROUP BY
		dt.mes,
		dtp.tipo_paquete_descripcion
GO

CREATE VIEW G_DE_GESTION.v_cantidad_reclamos_recibidos AS
	SELECT
		dt.mes,
		dl.local_nombre local,
		dd.dia,
		STR(drh.rango_horario_inicio, 2, 0) + '-' + STR(drh.rango_horario_fin, 2, 0) rango_horario,
		SUM(hr.cantidad_reclamos) reclamos_recibidos
	FROM G_DE_GESTION.BI_hecho_reclamos hr
	JOIN G_DE_GESTION.BI_dim_tiempo dt ON (dt.tiempo_id = hr.tiempo_id)
	JOIN G_DE_GESTION.BI_dim_local dl ON (dl.local_id = hr.local_id)
	JOIN G_DE_GESTION.BI_dim_dia dd ON (dd.dia_id = hr.dia_id)
	JOIN G_DE_GESTION.BI_dim_rango_horario drh ON (drh.rango_horario_id = hr.rango_horario_id)
	GROUP BY
		dt.mes,
		dl.local_nombre,
		dd.dia,
		STR(drh.rango_horario_inicio, 2, 0) + '-' + STR(drh.rango_horario_fin, 2, 0)
GO

CREATE VIEW G_DE_GESTION.v_tiempo_promedio_resolucion AS
	SELECT
		dt.mes,
		dtr.tipo_reclamo_descripcion tipo_reclamo,
		dre.rango_etario,
		SUM(hr.tiempo_resolucion) / SUM(hr.cantidad_reclamos) tiempo_promedio_resolucion
	FROM G_DE_GESTION.BI_hecho_reclamos hr
	JOIN G_DE_GESTION.BI_dim_tiempo dt ON (dt.tiempo_id = hr.tiempo_id)
	JOIN G_DE_GESTION.BI_dim_tipo_reclamo dtr ON (dtr.tipo_reclamo_id = hr.tipo_reclamo_id)
	JOIN G_DE_GESTION.BI_dim_rango_etario dre ON (dre.rango_etario_id = hr.rango_etario_id)
	GROUP BY
		dt.mes,
		dtr.tipo_reclamo_descripcion,
		dre.rango_etario
GO

CREATE VIEW G_DE_GESTION.v_monto_generado_cupones AS
	SELECT
		dt.mes,
		SUM(hr.total_cupones) monto_cupon
	FROM G_DE_GESTION.BI_hecho_reclamos hr
	JOIN G_DE_GESTION.BI_dim_tiempo dt ON (dt.tiempo_id = hr.tiempo_id)
	GROUP BY
		dt.mes
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
	EXECUTE G_DE_GESTION.migrar_BI_dim_tipo_reclamo
	EXECUTE G_DE_GESTION.migrar_BI_dim_estado_pedido
	EXECUTE G_DE_GESTION.migrar_BI_dim_estado_envio_mensajeria
	EXECUTE G_DE_GESTION.migrar_BI_dim_estado_reclamo
	EXECUTE G_DE_GESTION.migrar_BI_hecho_pedidos
	EXECUTE G_DE_GESTION.migrar_BI_hecho_entregas
	EXECUTE G_DE_GESTION.migrar_BI_hecho_mensajeria
	EXECUTE G_DE_GESTION.migrar_BI_hecho_reclamos
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
DROP PROCEDURE G_DE_GESTION.migrar_BI_dim_tipo_reclamo
DROP PROCEDURE G_DE_GESTION.migrar_BI_dim_estado_pedido
DROP PROCEDURE G_DE_GESTION.migrar_BI_dim_estado_envio_mensajeria
DROP PROCEDURE G_DE_GESTION.migrar_BI_dim_estado_reclamo
DROP PROCEDURE G_DE_GESTION.migrar_BI_hecho_pedidos
DROP PROCEDURE G_DE_GESTION.migrar_BI_hecho_entregas
DROP PROCEDURE G_DE_GESTION.migrar_BI_hecho_mensajeria
DROP PROCEDURE G_DE_GESTION.migrar_BI_hecho_reclamos
GO


----- Test Views -----
/*
SELECT * FROM G_DE_GESTION.v_monto_total_no_cobrado_local
SELECT * FROM G_DE_GESTION.v_monto_total_cupones_utilizados
SELECT * FROM G_DE_GESTION.v_valor_promedio_envio
SELECT * FROM G_DE_GESTION.v_promedio_calificacion
SELECT * FROM G_DE_GESTION.v_desvio_promedio_entrega
SELECT * FROM G_DE_GESTION.v_porcentaje_entrega
SELECT * FROM G_DE_GESTION.v_promedio_mensual_valor_asegurado
SELECT * FROM G_DE_GESTION.v_cantidad_reclamos_recibidos
SELECT * FROM G_DE_GESTION.v_tiempo_promedio_resolucion
SELECT * FROM G_DE_GESTION.v_monto_generado_cupones
GO
*/
