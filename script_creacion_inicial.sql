USE GD1C2023
GO

IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'G_DE_GESTION')
BEGIN 
	EXEC('CREATE SCHEMA G_DE_GESTION')
END
GO

-- Total tablas = 32

-- Se eliminan las tablas si existen (para testeo y tener ambiente limpio)
IF OBJECT_ID('G_DE_GESTION.cupon_reclamo') IS NOT NULL DROP TABLE G_DE_GESTION.cupon_reclamo
IF OBJECT_ID('G_DE_GESTION.reclamo') IS NOT NULL DROP TABLE G_DE_GESTION.reclamo
IF OBJECT_ID('G_DE_GESTION.tipo_reclamo') IS NOT NULL DROP TABLE G_DE_GESTION.tipo_reclamo
IF OBJECT_ID('G_DE_GESTION.operador_reclamo') IS NOT NULL DROP TABLE G_DE_GESTION.operador_reclamo
IF OBJECT_ID('G_DE_GESTION.pedido_cupon') IS NOT NULL DROP TABLE G_DE_GESTION.pedido_cupon
IF OBJECT_ID('G_DE_GESTION.cupon') IS NOT NULL DROP TABLE G_DE_GESTION.cupon
IF OBJECT_ID('G_DE_GESTION.tipo_cupon') IS NOT NULL DROP TABLE G_DE_GESTION.tipo_cupon
IF OBJECT_ID('G_DE_GESTION.producto_pedido') IS NOT NULL DROP TABLE G_DE_GESTION.producto_pedido
IF OBJECT_ID('G_DE_GESTION.producto_local') IS NOT NULL DROP TABLE G_DE_GESTION.producto_local
IF OBJECT_ID('G_DE_GESTION.producto') IS NOT NULL DROP TABLE G_DE_GESTION.producto
IF OBJECT_ID('G_DE_GESTION.pedido') IS NOT NULL DROP TABLE G_DE_GESTION.pedido
IF OBJECT_ID('G_DE_GESTION.horario_local') IS NOT NULL DROP TABLE G_DE_GESTION.horario_local
IF OBJECT_ID('G_DE_GESTION.local') IS NOT NULL DROP TABLE G_DE_GESTION.local
IF OBJECT_ID('G_DE_GESTION.horario') IS NOT NULL DROP TABLE G_DE_GESTION.horario
IF OBJECT_ID('G_DE_GESTION.categoria') IS NOT NULL DROP TABLE G_DE_GESTION.categoria
IF OBJECT_ID('G_DE_GESTION.tipo_local') IS NOT NULL DROP TABLE G_DE_GESTION.tipo_local
IF OBJECT_ID('G_DE_GESTION.localidad_repartidor') IS NOT NULL DROP TABLE G_DE_GESTION.localidad_repartidor
IF OBJECT_ID('G_DE_GESTION.envio_mensajeria') IS NOT NULL DROP TABLE G_DE_GESTION.envio_mensajeria
IF OBJECT_ID('G_DE_GESTION.repartidor') IS NOT NULL DROP TABLE G_DE_GESTION.repartidor
IF OBJECT_ID('G_DE_GESTION.tipo_movilidad') IS NOT NULL DROP TABLE G_DE_GESTION.tipo_movilidad
IF OBJECT_ID('G_DE_GESTION.paquete') IS NOT NULL DROP TABLE G_DE_GESTION.paquete
IF OBJECT_ID('G_DE_GESTION.tipo_paquete') IS NOT NULL DROP TABLE G_DE_GESTION.tipo_paquete
IF OBJECT_ID('G_DE_GESTION.medio_pago') IS NOT NULL DROP TABLE G_DE_GESTION.medio_pago
IF OBJECT_ID('G_DE_GESTION.tipo_medio_pago') IS NOT NULL DROP TABLE G_DE_GESTION.tipo_medio_pago
IF OBJECT_ID('G_DE_GESTION.tarjeta') IS NOT NULL DROP TABLE G_DE_GESTION.tarjeta
IF OBJECT_ID('G_DE_GESTION.marca_tarjeta') IS NOT NULL DROP TABLE G_DE_GESTION.marca_tarjeta
IF OBJECT_ID('G_DE_GESTION.direccion_usuario') IS NOT NULL DROP TABLE G_DE_GESTION.direccion_usuario
IF OBJECT_ID('G_DE_GESTION.usuario') IS NOT NULL DROP TABLE G_DE_GESTION.usuario
IF OBJECT_ID('G_DE_GESTION.direccion') IS NOT NULL DROP TABLE G_DE_GESTION.direccion
IF OBJECT_ID('G_DE_GESTION.tipo_direccion') IS NOT NULL DROP TABLE G_DE_GESTION.tipo_direccion
IF OBJECT_ID('G_DE_GESTION.localidad') IS NOT NULL DROP TABLE G_DE_GESTION.localidad
IF OBJECT_ID('G_DE_GESTION.provincia') IS NOT NULL DROP TABLE G_DE_GESTION.provincia
GO


-- Creacion de Tablas
CREATE TABLE G_DE_GESTION.provincia(
	provincia_id DECIMAL(18,0) IDENTITY(1,1) PRIMARY KEY,
	provincia_descripcion NVARCHAR(255) NOT NULL
)
GO

CREATE TABLE G_DE_GESTION.localidad(
	localidad_id DECIMAL(18,0) IDENTITY(1,1) PRIMARY KEY,
	localidad_descripcion NVARCHAR(255) NOT NULL,
	provincia_id DECIMAL(18,0) REFERENCES G_DE_GESTION.provincia
)
GO

CREATE TABLE G_DE_GESTION.tipo_movilidad(
	tipo_movilidad_id DECIMAL(18,0) IDENTITY(1,1) PRIMARY KEY,
	tipo_movilidad_descripcion NVARCHAR(50) NOT NULL
)
GO

CREATE TABLE G_DE_GESTION.repartidor(
	repartidor_id DECIMAL(18,0) IDENTITY(1,1) PRIMARY KEY,
	repartidor_nombre NVARCHAR(255) NOT NULL,
	repartidor_apellido NVARCHAR(255) NOT NULL,
	repartidor_dni DECIMAL(18,0) NOT NULL,
	repartidor_telefono DECIMAL(18,0) NOT NULL,
	repartidor_direccion NVARCHAR(255) NOT NULL,
	repartidor_email NVARCHAR(255) NOT NULL,
	repartidor_fecha_nac DATE NOT NULL,
	tipo_movilidad_id DECIMAL(18,0) REFERENCES G_DE_GESTION.tipo_movilidad
)
GO

CREATE TABLE G_DE_GESTION.localidad_repartidor(
	localidad_id DECIMAL(18,0) REFERENCES G_DE_GESTION.localidad,
	repartidor_id DECIMAL(18,0) REFERENCES G_DE_GESTION.repartidor,
	localidad_repartidor_activo BIT NOT NULL,
	PRIMARY KEY(localidad_id, repartidor_id)
)
GO

CREATE TABLE G_DE_GESTION.tipo_direccion(
	tipo_direccion_id DECIMAL(18,0) IDENTITY(1,1) PRIMARY KEY,
	tipo_direccion_descripcion NVARCHAR(50)
)
GO

CREATE TABLE G_DE_GESTION.direccion(
	direccion_id DECIMAL(18,0) IDENTITY(1,1) PRIMARY KEY,
	tipo_direccion_id DECIMAL(18,0) REFERENCES G_DE_GESTION.tipo_direccion,
	direccion_descripcion NVARCHAR(255) NOT NULL,
	localidad_id DECIMAL(18,0) REFERENCES G_DE_GESTION.localidad
)
GO

CREATE TABLE G_DE_GESTION.usuario(
	usuario_id DECIMAL(18,0) IDENTITY(1,1) PRIMARY KEY,
	usuario_nombre NVARCHAR(255) NOT NULL,
	usuario_apellido NVARCHAR(255) NOT NULL,
	usuario_dni DECIMAL(18,0) NOT NULL,
	usuario_fecha_registro DATETIME2(3) NOT NULL,
	usuario_telefono DECIMAL(18,0) NOT NULL,
	usuario_mail NVARCHAR(255) NOT NULL,
	usuario_fecha_nac DATE NOT NULL
)
GO

CREATE TABLE G_DE_GESTION.direccion_usuario(
	direccion_id DECIMAL(18,0) REFERENCES G_DE_GESTION.direccion,
	usuario_id DECIMAL(18,0) REFERENCES G_DE_GESTION.usuario,
	PRIMARY KEY (direccion_id, usuario_id)
)
GO

CREATE TABLE G_DE_GESTION.marca_tarjeta(
	marca_tarjeta_id DECIMAL(18,0) IDENTITY(1,1) PRIMARY KEY,
	marca_tarjeta_descripcion NVARCHAR(100) NOT NULL
)
GO

CREATE TABLE G_DE_GESTION.tarjeta(
	tarjeta_nro NVARCHAR(50) PRIMARY KEY,
	marca_tarjeta_id DECIMAL(18,0) REFERENCES G_DE_GESTION.marca_tarjeta,
	usuario_id DECIMAL(18,0) REFERENCES G_DE_GESTION.usuario
)
GO

CREATE TABLE G_DE_GESTION.tipo_medio_pago(
	tipo_medio_pago_id DECIMAL(18,0) IDENTITY(1,1) PRIMARY KEY,
	tipo_medio_pago_descripcion NVARCHAR(50) NOT NULL
)
GO

CREATE TABLE G_DE_GESTION.medio_pago(
	medio_pago_id DECIMAL(18,0) IDENTITY(1,1) PRIMARY KEY,
	tarjeta_nro NVARCHAR(50) REFERENCES G_DE_GESTION.tarjeta,
	tipo_medio_pago_id DECIMAL(18,0) REFERENCES G_DE_GESTION.tipo_medio_pago
)
GO

CREATE TABLE G_DE_GESTION.tipo_local(
	tipo_local_id DECIMAL(18,0) IDENTITY(1,1) PRIMARY KEY,
	tipo_local_descripcion NVARCHAR(50) NOT NULL
)
GO

CREATE TABLE G_DE_GESTION.categoria(
	categoria_id DECIMAL(18,0) IDENTITY(1,1) PRIMARY KEY,
	categoria_descripcion NVARCHAR(50) NOT NULL,
	tipo_local_id DECIMAL(18,0) REFERENCES G_DE_GESTION.tipo_local
)
GO

CREATE TABLE G_DE_GESTION.local(
	local_id DECIMAL(18,0) IDENTITY(1,1) PRIMARY KEY,
	local_nombre NVARCHAR(100) NOT NULL,
	local_descripcion NVARCHAR(255) NOT NULL,
	local_direccion NVARCHAR(255) NOT NULL,
	localidad_id DECIMAL(18,0) REFERENCES G_DE_GESTION.localidad,
	categoria_id DECIMAL(18,0) REFERENCES G_DE_GESTION.categoria
)
GO

CREATE TABLE G_DE_GESTION.horario(
	horario_id DECIMAL(18,0) IDENTITY(1,1) PRIMARY KEY,
	horario_hora_apertura DECIMAL(18,0) NOT NULL,
	horario_hora_cierre DECIMAL(18,0) NOT NULL,
	horario_dia NVARCHAR(50) NOT NULL
)
GO

CREATE TABLE G_DE_GESTION.horario_local(
	local_id DECIMAL(18,0) REFERENCES G_DE_GESTION.local,
	horario_id DECIMAL(18,0) REFERENCES G_DE_GESTION.horario,
	PRIMARY KEY(local_id, horario_id)
)
GO

CREATE TABLE G_DE_GESTION.producto(
	producto_codigo NVARCHAR(50) PRIMARY KEY,
	producto_nombre NVARCHAR(50) NOT NULL,
	producto_descripcion NVARCHAR(255) NOT NULL
)
GO

CREATE TABLE G_DE_GESTION.producto_local(
	local_id DECIMAL(18,0) REFERENCES G_DE_GESTION.local,
	producto_codigo NVARCHAR(50) REFERENCES G_DE_GESTION.producto,
	producto_local_precio DECIMAL(18,2) NOT NULL,
	PRIMARY KEY(local_id, producto_codigo)
)
GO

CREATE TABLE G_DE_GESTION.pedido(
	pedido_nro DECIMAL(18,0) PRIMARY KEY,
	pedido_fecha DATETIME2(3) NOT NULL,
	usuario_id DECIMAL(18,0) REFERENCES G_DE_GESTION.usuario,
	local_id DECIMAL(18,0) REFERENCES G_DE_GESTION.local,
	pedido_direccion_envio NVARCHAR(255) NOT NULL,
	pedido_precio_envio DECIMAL(18,2) NOT NULL,
	pedido_propina DECIMAL(18,2) NOT NULL,
	repartidor_id DECIMAL(18,0) REFERENCES G_DE_GESTION.repartidor,
	pedido_tarifa_servicio DECIMAL(18,2) NOT NULL,
	medio_pago_id DECIMAL(18,0) REFERENCES G_DE_GESTION.medio_pago,
	pedido_total_productos DECIMAL(18,2) NOT NULL,
	pedido_total_cupones DECIMAL(18,2) NOT NULL,
	pedido_total_servicio DECIMAL(18,2) NOT NULL,
	pedido_observ NVARCHAR(255) NOT NULL,
	pedido_estado NVARCHAR(50) NOT NULL,
	pedido_tiempo_estimado_entrega DECIMAL(18,2) NOT NULL,
	pedido_fecha_entrega DATETIME2(3) NOT NULL,
	pedido_calificacion DECIMAL(18,0) NOT NULL
)
GO

CREATE TABLE G_DE_GESTION.producto_pedido(
	pedido_nro DECIMAL(18,0) REFERENCES G_DE_GESTION.pedido, -- PK, FK
	local_id DECIMAL(18,0), -- PK, FK
	producto_codigo NVARCHAR(50), -- PK, FK
	producto_pedido_precio DECIMAL(18,2) NOT NULL,
	producto_pedido_cantidad DECIMAL(18,0) NOT NULL,
	PRIMARY KEY(pedido_nro, local_id, producto_codigo),
	FOREIGN KEY(local_id, producto_codigo) REFERENCES G_DE_GESTION.producto_local(local_id, producto_codigo)
)
GO

CREATE TABLE G_DE_GESTION.tipo_cupon(
	tipo_cupon_id DECIMAL(18,0) IDENTITY(1,1) PRIMARY KEY,
	tipo_cupon_descripcion NVARCHAR(50) NOT NULL
)
GO

CREATE TABLE G_DE_GESTION.cupon(
	cupon_nro DECIMAL(18,0) PRIMARY KEY,
	cupon_monto DECIMAL(18,2) NOT NULL,
	cupon_fecha_alta DATETIME2(3) NOT NULL,
	cupon_fecha_vencimiento DATETIME2(3) NOT NULL,
	tipo_cupon_id DECIMAL(18,0) REFERENCES G_DE_GESTION.tipo_cupon,
	usuario_id DECIMAL(18,0) REFERENCES G_DE_GESTION.usuario
)
GO

CREATE TABLE G_DE_GESTION.pedido_cupon(
	pedido_nro DECIMAL(18,0) REFERENCES G_DE_GESTION.pedido,
	cupon_nro DECIMAL(18,0) REFERENCES G_DE_GESTION.cupon,
	PRIMARY KEY(pedido_nro, cupon_nro)
)
GO

CREATE TABLE G_DE_GESTION.tipo_reclamo (
	tipo_reclamo_id DECIMAL(18,0) IDENTITY(1,1) PRIMARY KEY,
	tipo_reclamo_descripcion NVARCHAR(50) NOT NULL
)
GO

CREATE TABLE G_DE_GESTION.operador_reclamo (
	operador_reclamo_id DECIMAL(18,0) IDENTITY(1,1) PRIMARY KEY,
	operador_reclamo_nombre NVARCHAR(255) NOT NULL,
	operador_reclamo_apellido NVARCHAR(255) NOT NULL,
	operador_reclamo_dni DECIMAL(18,0) NOT NULL,
	operador_reclamo_telefono DECIMAL(18,0) NOT NULL,
	operador_reclamo_direccion NVARCHAR(255) NOT NULL,
	operador_reclamo_mail NVARCHAR(255) NOT NULL,
	operador_reclamo_fecha_nac DATE NOT NULL
)
GO

CREATE TABLE G_DE_GESTION.reclamo(
	reclamo_nro DECIMAL(18,0) PRIMARY KEY,
	usuario_id DECIMAL(18,0) REFERENCES G_DE_GESTION.usuario,
	pedido_nro DECIMAL(18,0) REFERENCES G_DE_GESTION.pedido,
	tipo_reclamo_id DECIMAL(18,0) REFERENCES G_DE_GESTION.tipo_reclamo,
	reclamo_descripcion NVARCHAR(255) NOT NULL,
	reclamo_fecha DATETIME2 NOT NULL,
	operador_reclamo_id DECIMAL(18,0) REFERENCES G_DE_GESTION.operador_reclamo,
	reclamo_estado NVARCHAR(50) NOT NULL,
	reclamo_solucion NVARCHAR(255) NOT NULL,
	reclamo_fecha_solucion DATETIME2 NOT NULL,
	reclamo_calificacion DECIMAL(18,0) NOT NULL
)
GO

CREATE TABLE G_DE_GESTION.cupon_reclamo (
	cupon_nro DECIMAL(18,0) REFERENCES G_DE_GESTION.cupon,
	reclamo_nro DECIMAL(18,0) REFERENCES G_DE_GESTION.reclamo,
	PRIMARY KEY(cupon_nro, reclamo_nro)
)
GO

CREATE TABLE G_DE_GESTION.tipo_paquete (
	tipo_paquete_id DECIMAL(18,0) IDENTITY(1,1) PRIMARY KEY,
	tipo_paquete_descripcion NVARCHAR(50) NOT NULL
)
GO

CREATE TABLE G_DE_GESTION.paquete (
	paquete_id DECIMAL(18,0) IDENTITY(1,1) PRIMARY KEY,
	tipo_paquete_id DECIMAL(18,0) REFERENCES G_DE_GESTION.tipo_paquete,
	paquete_alto_max DECIMAL(18,2) NOT NULL,
	paquete_ancho_max DECIMAL(18,2) NOT NULL,
	paquete_largo_max DECIMAL(18,2) NOT NULL,
	paquete_peso_max DECIMAL(18,2) NOT NULL,
	paquete_precio DECIMAL(18,2) NOT NULL
)
GO

CREATE TABLE G_DE_GESTION.envio_mensajeria(
	envio_mensajeria_nro DECIMAL(18,0) PRIMARY KEY,
	usuario_id DECIMAL(18,0) REFERENCES G_DE_GESTION.usuario,
	envio_mensajeria_fecha DATETIME2(3) NOT NULL,
	envio_mensajeria_dir_orig NVARCHAR(255) NOT NULL,
	envio_mensajeria_dir_dest NVARCHAR(255) NOT NULL,
	envio_mensajeria_km DECIMAL(18,2) NOT NULL,
	paquete_id DECIMAL(18,0) REFERENCES G_DE_GESTION.paquete,
	envio_mensajeria_valor_asegurado DECIMAL(18,2) NOT NULL,
	envio_mensajeria_observ NVARCHAR(255) NOT NULL,
	envio_mensajeria_precio_envio DECIMAL(18,2) NOT NULL,
	envio_mensajeria_precio_seguro DECIMAL(18,2) NOT NULL,
	repartidor_id DECIMAL(18,0) REFERENCES G_DE_GESTION.repartidor,
	envio_mensajeria_propina DECIMAL(18,2) NOT NULL,
	medio_pago_id DECIMAL(18,0) REFERENCES G_DE_GESTION.medio_pago,
	envio_mensajeria_total DECIMAL(18,2) NOT NULL,
	envio_mensajeria_estado NVARCHAR(50) NOT NULL,
	envio_mensajeria_tiempo_estimado DECIMAL(18,2) NOT NULL,
	envio_mensajeria_fecha_entrega DATETIME2(3) NOT NULL,
	envio_mensajeria_calificacion DECIMAL(18,0) NOT NULL,
	local_id DECIMAL(18,0) REFERENCES G_DE_GESTION.localidad
)
GO



/*
-- Funciones

CREATE FUNCTION G_DE_GESTION.obtener_provincia_codigo (@provincia_descripcion VARCHAR(255))
RETURNS DECIMAL(18,0)
AS
BEGIN
	DECLARE @codigo_obtenido DECIMAL
	SELECT @codigo_obtenido = lp.provincia_id FROM G_DE_GESTION.provincia lp WHERE lp.provincia_descripcion = @provincia_descripcion;
	RETURN @codigo_obtenido
END
GO

CREATE FUNCTION G_DE_GESTION.obtener_localidad_codigo (@localidad_descripcion VARCHAR(255), @localidad_codigo_postal DECIMAL(18,0), @provincia_descripcion VARCHAR(255))
RETURNS DECIMAL(18,0)
AS
BEGIN
	DECLARE @codigo_obtenido DECIMAL
	SELECT @codigo_obtenido = l.localidad_id FROM G_DE_GESTION.localidad l 
	WHERE l.localidad_descripcion = @localidad_descripcion 
		AND l.localidad_codigo_postal = @localidad_codigo_postal 
		AND l.provincia_id = G_DE_GESTION.obtener_provincia_codigo(@provincia_descripcion)
	RETURN @codigo_obtenido
END
GO

CREATE FUNCTION G_DE_GESTION.obtener_categoria_codigo (@categoria_producto_tipo VARCHAR(255))
RETURNS DECIMAL(18,0)
AS
BEGIN
	DECLARE @codigo_obtenido DECIMAL
	SELECT @codigo_obtenido = cp.categoria_producto_codigo FROM G_DE_GESTION.pedido_cupon cp WHERE cp.categoria_producto_tipo = @categoria_producto_tipo;
	RETURN @codigo_obtenido
END
GO

CREATE FUNCTION G_DE_GESTION.obtener_tipo_envio_codigo (@venta_medio_envio VARCHAR(255))
RETURNS DECIMAL(18,0)
AS
BEGIN
	DECLARE @codigo_obtenido DECIMAL
	SELECT @codigo_obtenido = te.tipo_envio_codigo FROM G_DE_GESTION.horario_local te WHERE te.tipo_envio_detalle LIKE @venta_medio_envio;
	RETURN @codigo_obtenido
END
GO

CREATE FUNCTION G_DE_GESTION.obtener_tipo_medio_pago_codigo (@venta_medio_pago_detalle NVARCHAR(255))
RETURNS DECIMAL(18,0)
AS
BEGIN
	DECLARE @codigo_obtenido DECIMAL
	SELECT @codigo_obtenido = tmp.tipo_medio_pago_codigo FROM G_DE_GESTION.horario_local tmp WHERE tmp.tipo_medio_pago_Detalle LIKE @venta_medio_pago_detalle;
	RETURN @codigo_obtenido
END
GO

CREATE FUNCTION G_DE_GESTION.obtener_pago_codigo (@medio_pago_costo DECIMAL(18,2), @medio_pago_detalle NVARCHAR(255))
RETURNS DECIMAL(18,0)
AS
BEGIN
	DECLARE @codigo_obtenido DECIMAL
	SELECT @codigo_obtenido = mp.tipo_medio_pago_codigo
	FROM G_DE_GESTION.medio_pago mp JOIN G_DE_GESTION.horario_local tmp ON mp.tipo_medio_pago_codigo = tmp.tipo_medio_pago_codigo
	WHERE mp.medio_pago_costo = @medio_pago_costo AND tmp.tipo_medio_pago_Detalle = @medio_pago_detalle
	RETURN @codigo_obtenido
END
GO

CREATE FUNCTION G_DE_GESTION.obtener_tipo_variante_codigo (@tipo_variante_detalle nvarchar(50))
RETURNS DECIMAL(18,0)
AS
BEGIN
    DECLARE @codigo_obtenido DECIMAL
    SELECT @codigo_obtenido = tp.tipo_variante_codigo FROM G_DE_GESTION.tipo_cupon tp WHERE tp.tipo_variante_detalle = @tipo_variante_detalle
    RETURN @codigo_obtenido
END
GO


CREATE FUNCTION G_DE_GESTION.obtener_medio_pago_codigo (@venta_medio_pago_detalle NVARCHAR(255))
RETURNS DECIMAL(18,0)
AS
BEGIN
    DECLARE @codigo_obtenido DECIMAL
    SELECT @codigo_obtenido = mp.medio_pago_codigo FROM G_DE_GESTION.medio_pago mp WHERE G_DE_GESTION.obtener_tipo_medio_pago_codigo(@venta_medio_pago_detalle) = mp.tipo_medio_pago_codigo;
    RETURN @codigo_obtenido
END
GO

CREATE FUNCTION G_DE_GESTION.obtener_proveedor_codigo (@proveedor_cuit nvarchar(50))
RETURNS DECIMAL(18,0)
AS
BEGIN
    DECLARE @codigo_obtenido DECIMAL
    SELECT @codigo_obtenido = p.proveedor_codigo FROM G_DE_GESTION.repartidor p WHERE p.proveedor_cuit = @proveedor_cuit
    RETURN @codigo_obtenido
END
GO*/


-- Procedures

CREATE PROCEDURE G_DE_GESTION.migrar_tipo_movilidad AS
BEGIN
	INSERT INTO G_DE_GESTION.tipo_movilidad(tipo_movilidad_descripcion)
	SELECT DISTINCT m.REPARTIDOR_TIPO_MOVILIDAD 
	FROM gd_esquema.Maestra m
	WHERE m.REPARTIDOR_TIPO_MOVILIDAD IS NOT NULL
END
GO

CREATE PROCEDURE G_DE_GESTION.migrar_tipo_paquete AS
BEGIN
	INSERT INTO G_DE_GESTION.tipo_paquete(tipo_paquete_descripcion)
	SELECT DISTINCT m.PAQUETE_TIPO 
	FROM gd_esquema.Maestra m
	WHERE m.PAQUETE_TIPO IS NOT NULL
END
GO

CREATE PROCEDURE G_DE_GESTION.migrar_tipo_local AS
BEGIN
	INSERT INTO G_DE_GESTION.tipo_local(tipo_local_descripcion)
	SELECT DISTINCT m.LOCAL_TIPO 
	FROM gd_esquema.Maestra m
	WHERE m.LOCAL_TIPO IS NOT NULL
END
GO

CREATE PROCEDURE G_DE_GESTION.migrar_tipo_reclamo AS
BEGIN
	INSERT INTO G_DE_GESTION.tipo_reclamo(tipo_reclamo_descripcion)
	SELECT DISTINCT m.RECLAMO_TIPO 
	FROM gd_esquema.Maestra m
	WHERE m.RECLAMO_TIPO IS NOT NULL
END
GO

CREATE PROCEDURE G_DE_GESTION.migrar_tipo_medio_pago AS
BEGIN
	INSERT INTO G_DE_GESTION.tipo_medio_pago(tipo_medio_pago_descripcion)
	SELECT DISTINCT m.MEDIO_PAGO_TIPO 
	FROM gd_esquema.Maestra m
	WHERE m.MEDIO_PAGO_TIPO IS NOT NULL
END
GO

CREATE PROCEDURE G_DE_GESTION.migrar_tipo_direccion AS
BEGIN
	INSERT INTO G_DE_GESTION.tipo_direccion(tipo_direccion_descripcion)
	SELECT DISTINCT m.DIRECCION_USUARIO_NOMBRE 
	FROM gd_esquema.Maestra m
	WHERE m.DIRECCION_USUARIO_NOMBRE IS NOT NULL
END
GO

CREATE PROCEDURE G_DE_GESTION.migrar_tipo_cupon AS
BEGIN
	INSERT INTO G_DE_GESTION.tipo_cupon(tipo_cupon_descripcion)
	SELECT DISTINCT m.CUPON_TIPO
	FROM gd_esquema.Maestra m
	WHERE m.CUPON_TIPO IS NOT NULL
	UNION
	SELECT DISTINCT m.CUPON_RECLAMO_TIPO
	FROM gd_esquema.Maestra m
	WHERE m.CUPON_RECLAMO_TIPO IS NOT NULL
END
GO

CREATE PROCEDURE G_DE_GESTION.migrar_horario AS
BEGIN
	INSERT INTO G_DE_GESTION.horario(
		horario_hora_apertura,
		horario_hora_cierre,
		horario_dia
	)
	SELECT DISTINCT
		m.HORARIO_LOCAL_HORA_APERTURA,
		m.HORARIO_LOCAL_HORA_CIERRE,
		m.HORARIO_LOCAL_DIA
	FROM gd_esquema.Maestra m
	WHERE m.HORARIO_LOCAL_HORA_APERTURA IS NOT NULL
END
GO

CREATE PROCEDURE G_DE_GESTION.migrar_producto AS
BEGIN
	INSERT INTO G_DE_GESTION.producto(
		producto_codigo,
		producto_nombre,
		producto_descripcion
	)
	SELECT DISTINCT
		m.PRODUCTO_LOCAL_CODIGO,
		m.PRODUCTO_LOCAL_NOMBRE,
		m.PRODUCTO_LOCAL_DESCRIPCION
	FROM gd_esquema.Maestra m
	WHERE m.PRODUCTO_LOCAL_CODIGO IS NOT NULL
END
GO

CREATE PROCEDURE G_DE_GESTION.migrar_operador_reclamo AS
BEGIN
	INSERT INTO G_DE_GESTION.operador_reclamo(
		operador_reclamo_nombre,
		operador_reclamo_apellido,
		operador_reclamo_dni,
		operador_reclamo_telefono,
		operador_reclamo_direccion,
		operador_reclamo_mail,
		operador_reclamo_fecha_nac
	)
	SELECT DISTINCT
		m.OPERADOR_RECLAMO_NOMBRE,
		m.OPERADOR_RECLAMO_APELLIDO,
		m.OPERADOR_RECLAMO_DNI,
		m.OPERADOR_RECLAMO_TELEFONO,
		m.OPERADOR_RECLAMO_DIRECCION,
		m.OPERADOR_RECLAMO_MAIL,
		m.OPERADOR_RECLAMO_FECHA_NAC
	FROM gd_esquema.Maestra m
	WHERE m.OPERADOR_RECLAMO_DNI IS NOT NULL
END
GO

CREATE PROCEDURE G_DE_GESTION.migrar_usuario AS
BEGIN
	INSERT INTO G_DE_GESTION.usuario(
		usuario_nombre,
		usuario_apellido,
		usuario_dni,
		usuario_fecha_registro,
		usuario_telefono,
		usuario_mail,
		usuario_fecha_nac
	)
	SELECT DISTINCT
		m.USUARIO_NOMBRE,
		m.USUARIO_APELLIDO,
		m.USUARIO_DNI,
		m.USUARIO_FECHA_REGISTRO,
		m.USUARIO_TELEFONO,
		m.USUARIO_MAIL,
		m.USUARIO_FECHA_NAC
	FROM gd_esquema.Maestra m
	WHERE m.USUARIO_DNI IS NOT NULL
END
GO

CREATE PROCEDURE G_DE_GESTION.migrar_marca_tarjeta AS
BEGIN
	INSERT INTO G_DE_GESTION.marca_tarjeta(marca_tarjeta_descripcion)
	SELECT DISTINCT m.MARCA_TARJETA 
	FROM gd_esquema.Maestra m
	WHERE m.MARCA_TARJETA IS NOT NULL
END
GO

CREATE PROCEDURE G_DE_GESTION.migrar_paquete AS
BEGIN
	INSERT INTO G_DE_GESTION.paquete(
		tipo_paquete_id,
		paquete_alto_max,
		paquete_ancho_max,
		paquete_largo_max,
		paquete_peso_max,
		paquete_precio
	)
	SELECT DISTINCT
		tp.tipo_paquete_id,
		m.PAQUETE_ALTO_MAX,
		m.PAQUETE_ANCHO_MAX,
		m.PAQUETE_LARGO_MAX,
		m.PAQUETE_PESO_MAX,
		m.PAQUETE_TIPO_PRECIO
	FROM gd_esquema.Maestra m
	JOIN G_DE_GESTION.tipo_paquete tp ON (tp.tipo_paquete_descripcion = m.PAQUETE_TIPO)
END
GO


/*
CREATE PROCEDURE G_DE_GESTION.migrar_pronvincias AS
BEGIN
	INSERT INTO LOS_MAGIOS.provincia  (provincia_nombre)
	SELECT DISTINCT m.CLIENTE_PROVINCIA
	FROM gd_esquema.Maestra m 
	WHERE m.CLIENTE_PROVINCIA IS NOT NULL
	UNION 
	SELECT DISTINCT  m.PROVEEDOR_PROVINCIA
	FROM gd_esquema.Maestra m 
	WHERE m.PROVEEDOR_PROVINCIA IS NOT NULL 
END
GO

CREATE PROCEDURE G_DE_GESTION.migrar_localidades AS
BEGIN
	INSERT INTO G_DE_GESTION.localidad (localidad_descripcion, localidad_codigo_postal, provincia_id)
	SELECT DISTINCT m.CLIENTE_LOCALIDAD as localidad_descripcion, m.CLIENTE_CODIGO_POSTAL as localidad_codigo_postal, G_DE_GESTION.obtener_provincia_codigo(m.CLIENTE_PROVINCIA) as provincia_id
	FROM gd_esquema.Maestra m 
	WHERE m.CLIENTE_LOCALIDAD IS NOT NULL
	UNION 
	SELECT DISTINCT  m.PROVEEDOR_LOCALIDAD, m.PROVEEDOR_CODIGO_POSTAL, G_DE_GESTION.obtener_provincia_codigo(m.PROVEEDOR_PROVINCIA) as provincia_id
	FROM gd_esquema.Maestra m 
	WHERE m.PROVEEDOR_LOCALIDAD IS NOT NULL 
END
GO

CREATE PROCEDURE G_DE_GESTION.migrar_clientes AS
BEGIN
	INSERT INTO G_DE_GESTION.reclamo(cliente_dni,
	cliente_nombre, cliente_apellido, cliente_direccion, cliente_telefono, cliente_mail,
	cliente_fecha_nac, localidad_id)
	SELECT DISTINCT CLIENTE_DNI,CLIENTE_NOMBRE ,CLIENTE_APELLIDO, CLIENTE_DIRECCION, CLIENTE_TELEFONO,
	CLIENTE_MAIL, CLIENTE_FECHA_NAC, G_DE_GESTION.obtener_localidad_codigo(CLIENTE_LOCALIDAD, CLIENTE_CODIGO_POSTAL, CLIENTE_PROVINCIA) FROM gd_esquema.Maestra m
	WHERE CLIENTE_DNI IS NOT NULL
END
GO

CREATE PROCEDURE G_DE_GESTION.migrar_proveedores AS
BEGIN
	INSERT INTO G_DE_GESTION.repartidor (proveedor_cuit, proveedor_domicilio, proveedor_mail, proveedor_razon_social, localidad_id)
	SELECT DISTINCT m.PROVEEDOR_CUIT, m.PROVEEDOR_DOMICILIO, m.PROVEEDOR_MAIL, m.PROVEEDOR_RAZON_SOCIAL,
							G_DE_GESTION.obtener_localidad_codigo(PROVEEDOR_LOCALIDAD, PROVEEDOR_CODIGO_POSTAL, PROVEEDOR_PROVINCIA)
	FROM gd_esquema.Maestra m WHERE m.PROVEEDOR_CUIT IS NOT NULL
END
GO

CREATE PROCEDURE G_DE_GESTION.migrar_descuento_compra AS
BEGIN
	INSERT INTO G_DE_GESTION.envio_mensajeria (descuento_compra_codigo, descuento_compra_valor)
	SELECT DISTINCT m.DESCUENTO_COMPRA_CODIGO, m.DESCUENTO_COMPRA_VALOR
	FROM gd_esquema.Maestra m WHERE m.DESCUENTO_COMPRA_CODIGO IS NOT NULL AND m.DESCUENTO_COMPRA_VALOR IS NOT NULL
END
GO

CREATE PROCEDURE G_DE_GESTION.migrar_categorias_productos AS
BEGIN
	INSERT INTO G_DE_GESTION.pedido_cupon (categoria_producto_tipo)
	SELECT DISTINCT m.PRODUCTO_CATEGORIA 
	FROM gd_esquema.Maestra m WHERE m.PRODUCTO_CATEGORIA IS NOT NULL 
END
GO

CREATE PROCEDURE G_DE_GESTION.migrar_tipo_canal AS
BEGIN
    INSERT INTO G_DE_GESTION.operador_reclamo(tipo_canal_detalle)
    SELECT distinct m.VENTA_CANAL 
    FROM gd_esquema.Maestra m 
    WHERE m.VENTA_CANAL IS NOT NULL
END
GO

CREATE PROCEDURE G_DE_GESTION.migrar_canal AS
BEGIN
	INSERT INTO G_DE_GESTION.tipo_reclamo(tipo_canal_codigo, canal_costo)
	SELECT distinct t.tipo_canal_codigo, m.VENTA_CANAL_COSTO
	FROM gd_esquema.Maestra m join G_DE_GESTION.operador_reclamo t on t.tipo_canal_detalle = m.VENTA_CANAL
END
GO

CREATE PROCEDURE G_DE_GESTION.migrar_tipo_envio AS
BEGIN
	INSERT INTO G_DE_GESTION.horario_local (tipo_envio_detalle)
	SELECT DISTINCT m.VENTA_MEDIO_ENVIO FROM gd_esquema.Maestra m WHERE m.VENTA_MEDIO_ENVIO IS NOT NULL
END
GO

CREATE PROCEDURE G_DE_GESTION.migrar_envio AS
BEGIN
	INSERT INTO G_DE_GESTION.tarjeta (envio_precio, tipo_envio_codigo)
	SELECT DISTINCT m.VENTA_ENVIO_PRECIO, G_DE_GESTION.obtener_tipo_envio_codigo(m.VENTA_MEDIO_ENVIO) as tipo_envio_codigo 
	FROM gd_esquema.Maestra m
	WHERE m.VENTA_MEDIO_ENVIO IS NOT NULL
END
GO

--- dudoso. 
CREATE PROCEDURE G_DE_GESTION.migrar_tipo_envio_localidad AS
BEGIN
	INSERT INTO G_DE_GESTION.usuario (localidad_id, tipo_envio_codigo)
	SELECT DISTINCT G_DE_GESTION.obtener_localidad_codigo(m.CLIENTE_LOCALIDAD, m.CLIENTE_CODIGO_POSTAL, m.CLIENTE_PROVINCIA )as localidad_id, G_DE_GESTION.obtener_tipo_envio_codigo(m.VENTA_MEDIO_ENVIO) as tipo_envio_codigo
	FROM gd_esquema.Maestra m
	WHERE m.CLIENTE_LOCALIDAD IS NOT NULL AND m.VENTA_MEDIO_ENVIO IS NOT NULL
END
GO


CREATE PROCEDURE G_DE_GESTION.migrar_tipo_descuento AS
BEGIN
	INSERT INTO G_DE_GESTION.cupon_reclamo (tipo_descuento_detalle)
	SELECT DISTINCT VENTA_DESCUENTO_CONCEPTO FROM gd_esquema.Maestra WHERE VENTA_DESCUENTO_CONCEPTO IS NOT NULL
END
GO


CREATE PROCEDURE G_DE_GESTION.migrar_tipo_medio_pago AS
BEGIN 
	INSERT INTO G_DE_GESTION.horario_local(tipo_medio_pago_Detalle)
	SELECT DISTINCT VENTA_MEDIO_PAGO FROM gd_esquema.Maestra WHERE VENTA_MEDIO_PAGO IS NOT NULL
	UNION SELECT DISTINCT COMPRA_MEDIO_PAGO FROM gd_esquema.Maestra WHERE COMPRA_MEDIO_PAGO IS NOT NULL
END
GO



CREATE PROCEDURE G_DE_GESTION.migrar_medio_pago AS
BEGIN
	INSERT INTO G_DE_GESTION.medio_pago (medio_pago_costo, tipo_medio_pago_codigo)
	SELECT DISTINCT m.VENTA_MEDIO_PAGO_COSTO, G_DE_GESTION.obtener_tipo_medio_pago_codigo(m.VENTA_MEDIO_PAGO) as tipo_medio_pago_codigo
	FROM gd_esquema.Maestra m
	WHERE m.VENTA_MEDIO_PAGO_COSTO IS NOT NULL
	UNION 
	SELECT DISTINCT m.VENTA_MEDIO_PAGO_COSTO, G_DE_GESTION.obtener_tipo_medio_pago_codigo(m.COMPRA_MEDIO_PAGO) as tipo_medio_pago_codigo 
	FROM gd_esquema.Maestra m
	WHERE m.VENTA_MEDIO_PAGO_COSTO IS NULL

END
GO

CREATE PROCEDURE G_DE_GESTION.migrar_tipo_variante AS
BEGIN
    INSERT INTO G_DE_GESTION.tipo_cupon(tipo_variante_detalle) 
    SELECT distinct m.PRODUCTO_TIPO_VARIANTE
    FROM gd_esquema.Maestra m 
    WHERE m.PRODUCTO_TIPO_VARIANTE IS NOT NULL
END
GO

CREATE PROCEDURE G_DE_GESTION.migrar_variante AS
BEGIN
    INSERT INTO G_DE_GESTION.local (variante_codigo, tipo_variante_codigo,variante_descripcion) 
    SELECT distinct m.PRODUCTO_VARIANTE_CODIGO, G_DE_GESTION.obtener_tipo_variante_codigo(m.PRODUCTO_TIPO_VARIANTE), m.PRODUCTO_VARIANTE
    FROM gd_esquema.Maestra m 
    WHERE m.PRODUCTO_VARIANTE_CODIGO IS NOT NULL
END
GO

CREATE PROCEDURE G_DE_GESTION.migrar_venta AS
BEGIN
	INSERT INTO G_DE_GESTION.marca_tarjeta (venta_codigo, venta_fecha, venta_total, cliente_codigo, canal_codigo, medio_pago_codigo, envio_codigo)
	SELECT DISTINCT m.VENTA_CODIGO, m.VENTA_FECHA, m.VENTA_TOTAL, c.cliente_codigo, tipo_reclamo.canal_codigo,
		mp.medio_pago_codigo, en.envio_codigo
	FROM gd_esquema.Maestra m JOIN G_DE_GESTION.reclamo c
			ON c.cliente_nombre = m.CLIENTE_NOMBRE AND c.cliente_dni = m.CLIENTE_DNI 
			AND c.cliente_apellido = m.CLIENTE_APELLIDO AND c.cliente_telefono = m.CLIENTE_TELEFONO
		JOIN G_DE_GESTION.operador_reclamo tc ON tc.tipo_canal_detalle = m.VENTA_CANAL
		JOIN G_DE_GESTION.tipo_reclamo ON tipo_reclamo.canal_codigo = tc.tipo_canal_codigo
		JOIN G_DE_GESTION.horario_local tpe ON tpe.tipo_envio_detalle = m.VENTA_MEDIO_ENVIO
		JOIN G_DE_GESTION.tarjeta en ON tpe.tipo_envio_codigo = en.tipo_envio_codigo AND en.envio_precio = m.VENTA_ENVIO_PRECIO
		JOIN G_DE_GESTION.horario_local tmp ON tmp.tipo_medio_pago_Detalle = m.VENTA_MEDIO_PAGO
		JOIN G_DE_GESTION.medio_pago mp ON tmp.tipo_medio_pago_codigo = mp.medio_pago_codigo
	WHERE m.VENTA_CODIGO IS NOT NULL
END
GO	

CREATE PROCEDURE G_DE_GESTION.migrar_venta_descuento AS
BEGIN
	INSERT INTO G_DE_GESTION.direccion (venta_descuento_importe, venta_codigo, tipo_descuento_codigo)
	SELECT DISTINCT m.VENTA_DESCUENTO_IMPORTE, m.venta_codigo,td.tipo_descuento_codigo
	FROM gd_esquema.Maestra m
	JOIN G_DE_GESTION.cupon_reclamo td ON m.VENTA_DESCUENTO_CONCEPTO LIKE td.tipo_descuento_detalle
	WHERE VENTA_CODIGO IS NOT NULL
END
GO

CREATE PROCEDURE G_DE_GESTION.migrar_cupones AS 
BEGIN
	INSERT INTO G_DE_GESTION.cupon (cupon_codigo, cupon_fecha_desde, cupon_fecha_hasta, cupon_tipo, cupon_valor)
	SELECT DISTINCT VENTA_CUPON_CODIGO, VENTA_CUPON_FECHA_DESDE, VENTA_CUPON_FECHA_HASTA, VENTA_CUPON_TIPO, VENTA_CUPON_VALOR FROM gd_esquema.Maestra
	WHERE VENTA_CUPON_CODIGO IS NOT NULL
END
GO

CREATE PROCEDURE G_DE_GESTION.migrar_venta_cupon AS
BEGIN
	INSERT INTO G_DE_GESTION.tipo_direccion (cupon_codigo, venta_codigo, venta_cupon_importe)
	SELECT c.cupon_codigo , v.venta_codigo, m.VENTA_CUPON_IMPORTE FROM gd_esquema.Maestra m
	JOIN G_DE_GESTION.marca_tarjeta v ON v.venta_codigo = m.VENTA_CODIGO
	JOIN G_DE_GESTION.cupon c ON m.VENTA_CUPON_CODIGO = c.cupon_codigo
	WHERE m.VENTA_CODIGO IS NOT NULL AND m.VENTA_CUPON_CODIGO IS NOT NULL
END
GO

CREATE PROCEDURE G_DE_GESTION.migrar_producto AS
BEGIN
    INSERT INTO G_DE_GESTION.producto(producto_codigo, categoria_producto_codigo, producto_descripcion, producto_marca, producto_material, 
        producto_nombre, producto_variante_codigo) 
    SELECT distinct m.PRODUCTO_CODIGO, G_DE_GESTION.obtener_categoria_codigo(m.PRODUCTO_CATEGORIA) , m.PRODUCTO_DESCRIPCION, m.PRODUCTO_MARCA, m.PRODUCTO_MATERIAL, m.PRODUCTO_NOMBRE, m.PRODUCTO_VARIANTE_CODIGO
    FROM gd_esquema.Maestra m 
    WHERE m.PRODUCTO_CODIGO IS NOT NULL
END
GO

CREATE PROCEDURE G_DE_GESTION.migrar_venta_producto AS
BEGIN
	INSERT INTO G_DE_GESTION.direccion_usuario (producto_codigo, venta_codigo, venta_producto_cantidad, venta_producto_precio)
	SELECT DISTINCT p.producto_codigo, v.venta_codigo ,SUM(m.VENTA_PRODUCTO_CANTIDAD) as venta_producto_cantidad, SUM(m.VENTA_PRODUCTO_PRECIO) as venta_producto_precio FROM gd_esquema.Maestra m
	JOIN G_DE_GESTION.producto p ON m.PRODUCTO_CODIGO = p.producto_codigo
	JOIN G_DE_GESTION.marca_tarjeta v ON m.VENTA_CODIGO = v.venta_codigo
	WHERE m.VENTA_CODIGO IS NOT NULL AND m.PRODUCTO_CODIGO IS NOT NULL AND m.VENTA_PRODUCTO_PRECIO IS NOT NULL AND m.VENTA_PRODUCTO_CANTIDAD IS NOT NULL
	GROUP BY p.producto_codigo, v.venta_codigo
END
GO

--mirar
CREATE PROCEDURE G_DE_GESTION.migrar_compra AS
BEGIN
    INSERT INTO G_DE_GESTION.localidad_repartidor(compra_numero, compra_fecha, compra_total, descuento_compra_codigo, medio_pago_codigo, proveedor_codigo)
    SELECT distinct m.COMPRA_NUMERO, m.COMPRA_FECHA, m.COMPRA_TOTAL, m.DESCUENTO_COMPRA_CODIGO, 
    G_DE_GESTION.obtener_medio_pago_codigo(m.COMPRA_MEDIO_PAGO), G_DE_GESTION.obtener_proveedor_codigo(m.PROVEEDOR_CUIT)
    FROM gd_esquema.Maestra m 
    WHERE m.COMPRA_NUMERO is not null and m.DESCUENTO_COMPRA_CODIGO is not null
END
GO

CREATE PROCEDURE G_DE_GESTION.migrar_compra_producto AS
BEGIN
	INSERT INTO G_DE_GESTION.pedido (compra_numero, producto_codigo, compra_producto_cantidad, compra_producto_precio)
	SELECT DISTINCT c.compra_numero, p.producto_codigo , SUM(m.COMPRA_PRODUCTO_CANTIDAD) as compra_producto_cantidad, SUM(m.COMPRA_PRODUCTO_PRECIO) as compra_producto_precio
	FROM gd_esquema.Maestra m
	JOIN G_DE_GESTION.producto p ON m.PRODUCTO_CODIGO LIKE p.producto_codigo
	JOIN G_DE_GESTION.localidad_repartidor c ON m.COMPRA_NUMERO = c.compra_numero
	GROUP BY c.compra_numero, p.producto_codigo
END
GO
*/

-- Migracion
BEGIN TRANSACTION
	EXECUTE G_DE_GESTION.migrar_tipo_movilidad
	EXECUTE G_DE_GESTION.migrar_tipo_paquete
	EXECUTE G_DE_GESTION.migrar_tipo_local
	EXECUTE G_DE_GESTION.migrar_tipo_reclamo
	EXECUTE G_DE_GESTION.migrar_tipo_medio_pago
	EXECUTE G_DE_GESTION.migrar_tipo_direccion
	EXECUTE G_DE_GESTION.migrar_tipo_cupon
	EXECUTE G_DE_GESTION.migrar_horario
	EXECUTE G_DE_GESTION.migrar_producto
	EXECUTE G_DE_GESTION.migrar_operador_reclamo
	EXECUTE G_DE_GESTION.migrar_usuario
	EXECUTE G_DE_GESTION.migrar_marca_tarjeta
	EXECUTE G_DE_GESTION.migrar_paquete
COMMIT TRANSACTION
GO

-- Eliminacion de FUNCTIONs y PROCEDUREs
/*
DROP FUNCTION G_DE_GESTION.obtener_provincia_codigo
DROP FUNCTION G_DE_GESTION.obtener_localidad_codigo
*/

DROP PROCEDURE G_DE_GESTION.migrar_tipo_movilidad
DROP PROCEDURE G_DE_GESTION.migrar_tipo_paquete
DROP PROCEDURE G_DE_GESTION.migrar_tipo_local
DROP PROCEDURE G_DE_GESTION.migrar_tipo_reclamo
DROP PROCEDURE G_DE_GESTION.migrar_tipo_medio_pago
DROP PROCEDURE G_DE_GESTION.migrar_tipo_direccion
DROP PROCEDURE G_DE_GESTION.migrar_tipo_cupon
DROP PROCEDURE G_DE_GESTION.migrar_horario
DROP PROCEDURE G_DE_GESTION.migrar_producto
DROP PROCEDURE G_DE_GESTION.migrar_operador_reclamo
DROP PROCEDURE G_DE_GESTION.migrar_usuario
DROP PROCEDURE G_DE_GESTION.migrar_marca_tarjeta
DROP PROCEDURE G_DE_GESTION.migrar_paquete
GO