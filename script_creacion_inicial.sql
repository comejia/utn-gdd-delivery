USE GD1C2023
GO

IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'G_DE_GESTION')
BEGIN 
	EXEC('CREATE SCHEMA G_DE_GESTION')
END
GO

-- Total tablas = 32 + 3 (se agregan estados)

-- Se eliminan las tablas si existen (para testeo y tener ambiente limpio)
IF OBJECT_ID('G_DE_GESTION.cupon_reclamo') IS NOT NULL DROP TABLE G_DE_GESTION.cupon_reclamo
IF OBJECT_ID('G_DE_GESTION.reclamo') IS NOT NULL DROP TABLE G_DE_GESTION.reclamo
IF OBJECT_ID('G_DE_GESTION.tipo_reclamo') IS NOT NULL DROP TABLE G_DE_GESTION.tipo_reclamo
IF OBJECT_ID('G_DE_GESTION.operador_reclamo') IS NOT NULL DROP TABLE G_DE_GESTION.operador_reclamo
IF OBJECT_ID('G_DE_GESTION.estado_reclamo') IS NOT NULL DROP TABLE G_DE_GESTION.estado_reclamo
IF OBJECT_ID('G_DE_GESTION.cupon_pedido') IS NOT NULL DROP TABLE G_DE_GESTION.cupon_pedido
IF OBJECT_ID('G_DE_GESTION.cupon') IS NOT NULL DROP TABLE G_DE_GESTION.cupon
IF OBJECT_ID('G_DE_GESTION.tipo_cupon') IS NOT NULL DROP TABLE G_DE_GESTION.tipo_cupon
IF OBJECT_ID('G_DE_GESTION.producto_pedido') IS NOT NULL DROP TABLE G_DE_GESTION.producto_pedido
IF OBJECT_ID('G_DE_GESTION.producto_local') IS NOT NULL DROP TABLE G_DE_GESTION.producto_local
IF OBJECT_ID('G_DE_GESTION.producto') IS NOT NULL DROP TABLE G_DE_GESTION.producto
IF OBJECT_ID('G_DE_GESTION.pedido') IS NOT NULL DROP TABLE G_DE_GESTION.pedido
IF OBJECT_ID('G_DE_GESTION.estado_pedido') IS NOT NULL DROP TABLE G_DE_GESTION.estado_pedido
IF OBJECT_ID('G_DE_GESTION.horario_local') IS NOT NULL DROP TABLE G_DE_GESTION.horario_local
IF OBJECT_ID('G_DE_GESTION.local') IS NOT NULL DROP TABLE G_DE_GESTION.local
IF OBJECT_ID('G_DE_GESTION.horario') IS NOT NULL DROP TABLE G_DE_GESTION.horario
IF OBJECT_ID('G_DE_GESTION.categoria') IS NOT NULL DROP TABLE G_DE_GESTION.categoria
IF OBJECT_ID('G_DE_GESTION.tipo_local') IS NOT NULL DROP TABLE G_DE_GESTION.tipo_local
IF OBJECT_ID('G_DE_GESTION.localidad_repartidor') IS NOT NULL DROP TABLE G_DE_GESTION.localidad_repartidor
IF OBJECT_ID('G_DE_GESTION.envio_mensajeria') IS NOT NULL DROP TABLE G_DE_GESTION.envio_mensajeria
IF OBJECT_ID('G_DE_GESTION.estado_envio_mensajeria') IS NOT NULL DROP TABLE G_DE_GESTION.estado_envio_mensajeria
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


----- Creacion de Tablas -----
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
	localidad_repartidor_activo BIT,
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
	categoria_descripcion NVARCHAR(50),
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

CREATE TABLE G_DE_GESTION.estado_pedido (
	estado_pedido_id DECIMAL(18,0) IDENTITY(1,1) PRIMARY KEY,
	estado_pedido_descripcion NVARCHAR(50) NOT NULL
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
	estado_pedido_id DECIMAL(18,0) REFERENCES G_DE_GESTION.estado_pedido,
	pedido_tiempo_estimado_entrega DECIMAL(18,2) NOT NULL,
	pedido_fecha_entrega DATETIME2(3) NOT NULL,
	pedido_calificacion DECIMAL(18,0) NOT NULL
)
GO

CREATE TABLE G_DE_GESTION.producto_pedido(
	producto_pedido_item DECIMAL(18,0) IDENTITY(1,1), -- PK
	pedido_nro DECIMAL(18,0) REFERENCES G_DE_GESTION.pedido, -- PK, FK
	local_id DECIMAL(18,0), -- PK, FK
	producto_codigo NVARCHAR(50), -- PK, FK
	producto_pedido_precio DECIMAL(18,2) NOT NULL,
	producto_pedido_cantidad DECIMAL(18,0) NOT NULL,
	PRIMARY KEY(producto_pedido_item, pedido_nro, local_id, producto_codigo),
	FOREIGN KEY(local_id, producto_codigo) REFERENCES G_DE_GESTION.producto_local(local_id, producto_codigo)
)
GO

CREATE TABLE G_DE_GESTION.tipo_cupon(
	tipo_cupon_id DECIMAL(18,0) IDENTITY(1,1) PRIMARY KEY,
	tipo_cupon_descripcion NVARCHAR(50) NOT NULL
)
GO

CREATE TABLE G_DE_GESTION.cupon(
	cupon_id DECIMAL(18,0) IDENTITY(1,1) PRIMARY KEY,
	cupon_nro DECIMAL(18,0) NOT NULL,
	cupon_monto DECIMAL(18,2) NOT NULL,
	cupon_fecha_alta DATETIME2(3) NOT NULL,
	cupon_fecha_vencimiento DATETIME2(3) NOT NULL,
	tipo_cupon_id DECIMAL(18,0) REFERENCES G_DE_GESTION.tipo_cupon,
	usuario_id DECIMAL(18,0) REFERENCES G_DE_GESTION.usuario
)
GO

CREATE TABLE G_DE_GESTION.cupon_pedido(
	pedido_nro DECIMAL(18,0) REFERENCES G_DE_GESTION.pedido,
	cupon_id DECIMAL(18,0) REFERENCES G_DE_GESTION.cupon,
	cupon_pedido_monto DECIMAL(18,2) NOT NULL,
	PRIMARY KEY(pedido_nro, cupon_id)
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

CREATE TABLE G_DE_GESTION.estado_reclamo (
	estado_reclamo_id DECIMAL(18,0) IDENTITY(1,1) PRIMARY KEY,
	estado_reclamo_descripcion NVARCHAR(50) NOT NULL
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
	estado_reclamo_id DECIMAL(18,0) REFERENCES G_DE_GESTION.estado_reclamo,
	reclamo_solucion NVARCHAR(255) NOT NULL,
	reclamo_fecha_solucion DATETIME2 NOT NULL,
	reclamo_calificacion DECIMAL(18,0) NOT NULL
)
GO

CREATE TABLE G_DE_GESTION.cupon_reclamo (
	cupon_id DECIMAL(18,0) REFERENCES G_DE_GESTION.cupon,
	reclamo_nro DECIMAL(18,0) REFERENCES G_DE_GESTION.reclamo,
	cupon_reclamo_monto DECIMAL(18,2) NOT NULL,
	PRIMARY KEY(cupon_id, reclamo_nro)
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

CREATE TABLE G_DE_GESTION.estado_envio_mensajeria (
	estado_envio_mensajeria_id DECIMAL(18,0) IDENTITY(1,1) PRIMARY KEY,
	estado_envio_mensajeria_descripcion NVARCHAR(50) NOT NULL
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
	estado_envio_mensajeria_id DECIMAL(18,0) REFERENCES G_DE_GESTION.estado_envio_mensajeria,
	envio_mensajeria_tiempo_estimado DECIMAL(18,2) NOT NULL,
	envio_mensajeria_fecha_entrega DATETIME2(3) NOT NULL,
	envio_mensajeria_calificacion DECIMAL(18,0) NOT NULL,
	localidad_id DECIMAL(18,0) REFERENCES G_DE_GESTION.localidad
)
GO



----- Funciones -----
CREATE FUNCTION G_DE_GESTION.obtener_provincia_codigo (@provincia_descripcion VARCHAR(255))
RETURNS DECIMAL(18,0)
AS
BEGIN
	DECLARE @codigo_obtenido DECIMAL
	SELECT @codigo_obtenido = lp.provincia_id FROM G_DE_GESTION.provincia lp WHERE lp.provincia_descripcion = @provincia_descripcion;
	RETURN @codigo_obtenido
END
GO

CREATE FUNCTION G_DE_GESTION.obtener_codigo_localidad (@localidad_descripcion VARCHAR(255))
RETURNS DECIMAL(18,0)
AS
BEGIN
	DECLARE @codigo_obtenido DECIMAL
	SELECT @codigo_obtenido = l.localidad_id FROM G_DE_GESTION.localidad l WHERE l.localidad_descripcion = @localidad_descripcion;
	RETURN @codigo_obtenido
END
GO


CREATE FUNCTION G_DE_GESTION.obtener_codigo_tipo_direccion (@tipo_direccion_descripcion VARCHAR(50))
RETURNS DECIMAL(18,0)
AS
BEGIN
	DECLARE @codigo_obtenido DECIMAL
	SELECT @codigo_obtenido = td.tipo_direccion_id FROM G_DE_GESTION.tipo_direccion td WHERE td.tipo_direccion_descripcion = @tipo_direccion_descripcion;
	RETURN @codigo_obtenido
END
GO

CREATE FUNCTION G_DE_GESTION.obtener_codigo_direccion(@direccion_descripcion VARCHAR(50))
RETURNS DECIMAL(18,0)
AS
BEGIN
	DECLARE @codigo_obtenido DECIMAL
	SELECT @codigo_obtenido = d.direccion_id FROM G_DE_GESTION.direccion d WHERE d.direccion_descripcion = @direccion_descripcion;
	RETURN @codigo_obtenido
END
GO

CREATE FUNCTION G_DE_GESTION.obtener_codigo_usuario(@usuario_nombre VARCHAR(255), @usuario_apellido VARCHAR(255), @usuario_dni DECIMAL(18,0))
RETURNS DECIMAL(18,0)
AS
BEGIN
	DECLARE @codigo_obtenido DECIMAL
	SELECT @codigo_obtenido = u.usuario_id FROM G_DE_GESTION.usuario u 
	WHERE u.usuario_nombre = @usuario_nombre
	AND u.usuario_apellido = @usuario_apellido
	AND u.usuario_dni = @usuario_dni;
	
	RETURN @codigo_obtenido
END
GO

CREATE FUNCTION G_DE_GESTION.obtener_marca_tarjeta(@marca_tarjeta_descripcion VARCHAR(100))
RETURNS DECIMAL(18,0)
AS
BEGIN
	DECLARE @codigo_obtenido DECIMAL
	SELECT @codigo_obtenido = mt.marca_tarjeta_id FROM G_DE_GESTION.marca_tarjeta mt WHERE mt.marca_tarjeta_descripcion = @marca_tarjeta_descripcion;
	RETURN @codigo_obtenido
END
GO


----- Procedures -----
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

	INSERT INTO G_DE_GESTION.tipo_local(tipo_local_descripcion)
	VALUES ('Tipo Local Comida')
END
GO

CREATE PROCEDURE G_DE_GESTION.migrar_categoria AS
BEGIN
	INSERT INTO G_DE_GESTION.categoria(
		categoria_descripcion,
		tipo_local_id
	) 
	VALUES
		('Kiosko', (SELECT tl.tipo_local_id FROM G_DE_GESTION.tipo_local tl WHERE tl.tipo_local_descripcion = 'Tipo Local Mercado')),
		('Supermercado', (SELECT tl.tipo_local_id FROM G_DE_GESTION.tipo_local tl WHERE tl.tipo_local_descripcion = 'Tipo Local Mercado')),
		('Parrilla', (SELECT tl.tipo_local_id FROM G_DE_GESTION.tipo_local tl WHERE tl.tipo_local_descripcion = 'Tipo Local Comida')),
		('Heladeria', (SELECT tl.tipo_local_id FROM G_DE_GESTION.tipo_local tl WHERE tl.tipo_local_descripcion = 'Tipo Local Comida')),
		('Comidas rapidas', (SELECT tl.tipo_local_id FROM G_DE_GESTION.tipo_local tl WHERE tl.tipo_local_descripcion = 'Tipo Local Comida'))
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

CREATE PROCEDURE G_DE_GESTION.migrar_provincias AS
BEGIN
	INSERT INTO G_DE_GESTION.provincia(provincia_descripcion)
	SELECT DISTINCT m.DIRECCION_USUARIO_PROVINCIA
	FROM gd_esquema.Maestra m 
	WHERE m.DIRECCION_USUARIO_PROVINCIA IS NOT NULL
	UNION
	SELECT DISTINCT m.ENVIO_MENSAJERIA_PROVINCIA
	FROM gd_esquema.Maestra m 
	WHERE m.ENVIO_MENSAJERIA_PROVINCIA IS NOT NULL
	UNION
	SELECT DISTINCT m.LOCAL_PROVINCIA
	FROM gd_esquema.Maestra m 
	WHERE m.LOCAL_PROVINCIA IS NOT NULL
END
GO

CREATE PROCEDURE G_DE_GESTION.migrar_localidades AS
BEGIN
	INSERT INTO G_DE_GESTION.localidad(
		localidad_descripcion,
		provincia_id
	)
	SELECT DISTINCT
		m.DIRECCION_USUARIO_LOCALIDAD, 
		p.provincia_id
	FROM gd_esquema.Maestra m 
	JOIN G_DE_GESTION.provincia p ON (p.provincia_descripcion = m.DIRECCION_USUARIO_PROVINCIA)
	WHERE m.DIRECCION_USUARIO_LOCALIDAD IS NOT NULL
	UNION
	SELECT DISTINCT
		m.ENVIO_MENSAJERIA_LOCALIDAD,
		p.provincia_id
	FROM gd_esquema.Maestra m
	JOIN G_DE_GESTION.provincia p ON (p.provincia_descripcion = m.ENVIO_MENSAJERIA_PROVINCIA)
	WHERE m.ENVIO_MENSAJERIA_LOCALIDAD IS NOT NULL 
	UNION 
	SELECT DISTINCT
		m.LOCAL_LOCALIDAD,
		p.provincia_id
	FROM gd_esquema.Maestra m 
	JOIN G_DE_GESTION.provincia p ON (p.provincia_descripcion = m.LOCAL_PROVINCIA)
	WHERE m.LOCAL_LOCALIDAD IS NOT NULL 
END
GO

CREATE PROCEDURE G_DE_GESTION.migrar_tarjeta AS
BEGIN
	INSERT INTO G_DE_GESTION.tarjeta(
		tarjeta_nro,
		marca_tarjeta_id,
		usuario_id
	)
	SELECT DISTINCT 
		m.MEDIO_PAGO_NRO_TARJETA,
		mt.marca_tarjeta_id,
		u.usuario_id
	FROM gd_esquema.Maestra m
	JOIN G_DE_GESTION.marca_tarjeta mt ON (mt.marca_tarjeta_descripcion = m.MARCA_TARJETA)
	JOIN G_DE_GESTION.usuario u ON (u.usuario_dni = m.USUARIO_DNI)
	WHERE m.MEDIO_PAGO_NRO_TARJETA IS NOT NULL
END
GO

CREATE PROCEDURE G_DE_GESTION.migrar_direcciones AS
BEGIN
	INSERT INTO G_DE_GESTION.direccion(
		tipo_direccion_id,
		direccion_descripcion,
		localidad_id
	)
	SELECT DISTINCT 
		td.tipo_direccion_id,
		m.DIRECCION_USUARIO_DIRECCION,
		l.localidad_id
	FROM gd_esquema.Maestra m
	JOIN G_DE_GESTION.tipo_direccion td ON (td.tipo_direccion_descripcion = m.DIRECCION_USUARIO_NOMBRE)
	JOIN G_DE_GESTION.localidad l ON (l.localidad_descripcion = m.DIRECCION_USUARIO_LOCALIDAD)
	WHERE m.DIRECCION_USUARIO_DIRECCION IS NOT NULL
END
GO

CREATE PROCEDURE G_DE_GESTION.migrar_direccion_usuario AS
BEGIN
	INSERT INTO G_DE_GESTION.direccion_usuario(
		direccion_id,
		usuario_id
	)
	SELECT DISTINCT
		d.direccion_id,
		u.usuario_id
	FROM gd_esquema.Maestra m
	JOIN G_DE_GESTION.direccion d ON (d.direccion_descripcion = m.DIRECCION_USUARIO_DIRECCION)
	JOIN G_DE_GESTION.usuario u ON (u.usuario_dni = m.USUARIO_DNI)
	WHERE m.DIRECCION_USUARIO_DIRECCION IS NOT NULL
END
GO

CREATE PROCEDURE G_DE_GESTION.migrar_repartidor AS
BEGIN
	INSERT INTO G_DE_GESTION.repartidor(
		repartidor_nombre,
		repartidor_apellido,
		repartidor_dni,
		repartidor_telefono,
		repartidor_direccion,
		repartidor_email,
		repartidor_fecha_nac,
		tipo_movilidad_id
	)
	SELECT DISTINCT
		m.REPARTIDOR_NOMBRE,
		m.REPARTIDOR_APELLIDO,
		m.REPARTIDOR_DNI,
		m.REPARTIDOR_TELEFONO,
		m.REPARTIDOR_DIRECION,
		m.REPARTIDOR_EMAIL,
		m.REPARTIDOR_FECHA_NAC,
		tm.tipo_movilidad_id
	FROM gd_esquema.Maestra m
	JOIN G_DE_GESTION.tipo_movilidad tm ON (tm.tipo_movilidad_descripcion = m.REPARTIDOR_TIPO_MOVILIDAD)
END
GO

CREATE PROCEDURE G_DE_GESTION.migrar_medio_pago AS
BEGIN
	INSERT INTO G_DE_GESTION.medio_pago(
		tarjeta_nro,
		tipo_medio_pago_id
	)
	SELECT DISTINCT
		t.tarjeta_nro,
		tmp.tipo_medio_pago_id
	FROM gd_esquema.Maestra m
	JOIN G_DE_GESTION.tarjeta t ON (t.tarjeta_nro = m.MEDIO_PAGO_NRO_TARJETA)
	JOIN G_DE_GESTION.tipo_medio_pago tmp ON (tmp.tipo_medio_pago_descripcion = m.MEDIO_PAGO_TIPO)
END
GO

CREATE PROCEDURE G_DE_GESTION.migrar_estado_envio_mensajeria AS
BEGIN
	INSERT INTO G_DE_GESTION.estado_envio_mensajeria(estado_envio_mensajeria_descripcion)
	SELECT DISTINCT m.ENVIO_MENSAJERIA_ESTADO
	FROM gd_esquema.Maestra m
	WHERE m.ENVIO_MENSAJERIA_NRO IS NOT NULL
END
GO

CREATE PROCEDURE G_DE_GESTION.migrar_envio_mensajeria AS
BEGIN
	INSERT INTO G_DE_GESTION.envio_mensajeria(
		envio_mensajeria_nro,
		usuario_id,
		envio_mensajeria_fecha,
		envio_mensajeria_dir_orig,
		envio_mensajeria_dir_dest,
		envio_mensajeria_km,
		paquete_id,
		envio_mensajeria_valor_asegurado,
		envio_mensajeria_observ,
		envio_mensajeria_precio_envio,
		envio_mensajeria_precio_seguro,
		repartidor_id,
		envio_mensajeria_propina,
		medio_pago_id,
		envio_mensajeria_total,
		estado_envio_mensajeria_id,
		envio_mensajeria_tiempo_estimado,
		envio_mensajeria_fecha_entrega,
		envio_mensajeria_calificacion,
		localidad_id
	)
	SELECT DISTINCT
		m.ENVIO_MENSAJERIA_NRO,
		u.usuario_id,
		m.ENVIO_MENSAJERIA_FECHA,
		m.ENVIO_MENSAJERIA_DIR_ORIG,
		m.ENVIO_MENSAJERIA_DIR_DEST,
		m.ENVIO_MENSAJERIA_KM,
		p_t.paquete_id,
		m.ENVIO_MENSAJERIA_VALOR_ASEGURADO,
		m.ENVIO_MENSAJERIA_OBSERV,
		m.ENVIO_MENSAJERIA_PRECIO_ENVIO,
		m.ENVIO_MENSAJERIA_PRECIO_SEGURO,
		r.repartidor_id,
		m.ENVIO_MENSAJERIA_PROPINA,
		(SELECT mp.medio_pago_id FROM G_DE_GESTION.medio_pago mp
			JOIN G_DE_GESTION.tipo_medio_pago tmp ON (tmp.tipo_medio_pago_id = mp.tipo_medio_pago_id)
			WHERE mp.tarjeta_nro = m.MEDIO_PAGO_NRO_TARJETA AND tmp.tipo_medio_pago_descripcion = m.MEDIO_PAGO_TIPO
		) as medio_pago_id,
		m.ENVIO_MENSAJERIA_TOTAL,
		e.estado_envio_mensajeria_id,
		m.ENVIO_MENSAJERIA_TIEMPO_ESTIMADO,
		m.ENVIO_MENSAJERIA_FECHA_ENTREGA,
		m.ENVIO_MENSAJERIA_CALIFICACION,
		(SELECT l.localidad_id FROM G_DE_GESTION.localidad l
			JOIN G_DE_GESTION.provincia p ON (p.provincia_id = l.provincia_id)
			WHERE l.localidad_descripcion = m.ENVIO_MENSAJERIA_LOCALIDAD AND p.provincia_descripcion = m.ENVIO_MENSAJERIA_PROVINCIA
		) as localidad_id
	FROM gd_esquema.Maestra m
	JOIN G_DE_GESTION.usuario u ON (u.usuario_dni = m.USUARIO_DNI)
	JOIN (SELECT 
				p.paquete_id,
				tp.tipo_paquete_descripcion 
		  FROM G_DE_GESTION.paquete p
		  JOIN G_DE_GESTION.tipo_paquete tp ON (tp.tipo_paquete_id = p.tipo_paquete_id)
		 ) p_t ON (p_t.tipo_paquete_descripcion = m.PAQUETE_TIPO)
	JOIN G_DE_GESTION.repartidor r ON (r.repartidor_dni = m.REPARTIDOR_DNI)
	JOIN G_DE_GESTION.estado_envio_mensajeria e ON (e.estado_envio_mensajeria_descripcion = m.ENVIO_MENSAJERIA_ESTADO)
	WHERE m.ENVIO_MENSAJERIA_NRO IS NOT NULL
END
GO

CREATE PROCEDURE G_DE_GESTION.migrar_local AS
BEGIN
	INSERT INTO G_DE_GESTION.local(
		local_nombre,
		local_descripcion,
		local_direccion,
		localidad_id,
		categoria_id
	)
	SELECT DISTINCT
		m.LOCAL_NOMBRE,
		m.LOCAL_DESCRIPCION,
		m.LOCAL_DIRECCION,
		l_p.localidad_id,
		NULL
	FROM gd_esquema.Maestra m
	JOIN (SELECT l.localidad_id, l.localidad_descripcion, p.provincia_descripcion FROM G_DE_GESTION.localidad l
			JOIN G_DE_GESTION.provincia p ON (p.provincia_id = l.provincia_id)
	) l_p ON (l_p.localidad_descripcion = m.LOCAL_LOCALIDAD AND l_p.provincia_descripcion = LOCAL_PROVINCIA)
	WHERE m.LOCAL_NOMBRE IS NOT NULL
END
GO

CREATE PROCEDURE G_DE_GESTION.migrar_estado_pedido AS
BEGIN
	INSERT INTO G_DE_GESTION.estado_pedido(estado_pedido_descripcion)
	SELECT DISTINCT m.PEDIDO_ESTADO
	FROM gd_esquema.Maestra m
	WHERE m.PEDIDO_NRO IS NOT NULL
END
GO

CREATE PROCEDURE G_DE_GESTION.migrar_pedido AS
BEGIN
	INSERT INTO G_DE_GESTION.pedido(
		pedido_nro,
		pedido_fecha,
		usuario_id,
		local_id,
		pedido_direccion_envio,
		pedido_precio_envio,
		pedido_propina,
		repartidor_id,
		pedido_tarifa_servicio,
		medio_pago_id,
		pedido_total_productos,
		pedido_total_cupones,
		pedido_total_servicio,
		pedido_observ,
		estado_pedido_id,
		pedido_tiempo_estimado_entrega,
		pedido_fecha_entrega,
		pedido_calificacion
	)
	SELECT DISTINCT
		m.PEDIDO_NRO,
		m.PEDIDO_FECHA,
		u.usuario_id,
		l.local_id,
		m.DIRECCION_USUARIO_DIRECCION,
		m.PEDIDO_PRECIO_ENVIO,
		m.PEDIDO_PROPINA,
		r.repartidor_id,
		m.PEDIDO_TARIFA_SERVICIO,
		mp.medio_pago_id,
		m.PEDIDO_TOTAL_PRODUCTOS,
		m.PEDIDO_TOTAL_CUPONES,
		m.PEDIDO_TOTAL_SERVICIO,
		m.PEDIDO_OBSERV,
		e.estado_pedido_id,
		m.PEDIDO_TIEMPO_ESTIMADO_ENTREGA,
		m.PEDIDO_FECHA_ENTREGA,
		m.PEDIDO_CALIFICACION
	FROM gd_esquema.Maestra m
	JOIN G_DE_GESTION.usuario u ON (u.usuario_dni = m.USUARIO_DNI)
	JOIN G_DE_GESTION.repartidor r ON (r.repartidor_dni = m.REPARTIDOR_DNI)
	JOIN G_DE_GESTION.local l ON (l.local_nombre = m.LOCAL_NOMBRE)
	JOIN (SELECT mp.medio_pago_id, mp.tarjeta_nro, tmp.tipo_medio_pago_descripcion FROM G_DE_GESTION.medio_pago mp
			JOIN G_DE_GESTION.tipo_medio_pago tmp ON (tmp.tipo_medio_pago_id = mp.tipo_medio_pago_id)
		) mp ON mp.tarjeta_nro = m.MEDIO_PAGO_NRO_TARJETA AND mp.tipo_medio_pago_descripcion = m.MEDIO_PAGO_TIPO
	JOIN G_DE_GESTION.estado_pedido e ON (e.estado_pedido_descripcion = m.PEDIDO_ESTADO)
	WHERE m.PEDIDO_NRO IS NOT NULL
END
GO

CREATE PROCEDURE G_DE_GESTION.migrar_estado_reclamo AS
BEGIN
	INSERT INTO G_DE_GESTION.estado_reclamo(estado_reclamo_descripcion)
	SELECT DISTINCT m.RECLAMO_ESTADO
	FROM gd_esquema.Maestra m
	WHERE m.RECLAMO_NRO IS NOT NULL
END
GO

CREATE PROCEDURE G_DE_GESTION.migrar_reclamo AS
BEGIN
	INSERT INTO G_DE_GESTION.reclamo(
		reclamo_nro,
		usuario_id,
		pedido_nro,
		tipo_reclamo_id,
		reclamo_descripcion,
		reclamo_fecha,
		operador_reclamo_id,
		estado_reclamo_id,
		reclamo_solucion,
		reclamo_fecha_solucion,
		reclamo_calificacion
	)
	SELECT DISTINCT
		m.RECLAMO_NRO,
		u.usuario_id,
		p.pedido_nro,
		tr.tipo_reclamo_id,
		m.RECLAMO_DESCRIPCION,
		m.RECLAMO_FECHA,
		o.operador_reclamo_id,
		e.estado_reclamo_id,
		m.RECLAMO_SOLUCION,
		m.RECLAMO_FECHA_SOLUCION,
		m.RECLAMO_CALIFICACION
	FROM gd_esquema.Maestra m
	JOIN G_DE_GESTION.usuario u ON (u.usuario_dni = m.USUARIO_DNI)
	JOIN G_DE_GESTION.pedido p ON (p.pedido_nro = m.PEDIDO_NRO)
	JOIN G_DE_GESTION.tipo_reclamo tr ON (tr.tipo_reclamo_descripcion = m.RECLAMO_TIPO)
	JOIN G_DE_GESTION.operador_reclamo o ON (o.operador_reclamo_dni = m.OPERADOR_RECLAMO_DNI 
											AND o.operador_reclamo_fecha_nac = m.OPERADOR_RECLAMO_FECHA_NAC)
	JOIN G_DE_GESTION.estado_reclamo e ON (e.estado_reclamo_descripcion = m.RECLAMO_ESTADO)
	WHERE m.RECLAMO_NRO IS NOT NULL
END
GO

CREATE PROCEDURE G_DE_GESTION.migrar_horario_local AS
BEGIN
	INSERT INTO G_DE_GESTION.horario_local(
		local_id,
		horario_id
	)
	SELECT DISTINCT
		l.local_id,
		h.horario_id
	FROM gd_esquema.Maestra m
	JOIN G_DE_GESTION.local l ON (l.local_nombre = m.LOCAL_NOMBRE)
	JOIN G_DE_GESTION.horario h ON (h.horario_hora_apertura = m.HORARIO_LOCAL_HORA_APERTURA
									AND h.horario_hora_cierre = m.HORARIO_LOCAL_HORA_CIERRE
									AND h.horario_dia = m.HORARIO_LOCAL_DIA)
END
GO

CREATE PROCEDURE G_DE_GESTION.migrar_producto_local AS
BEGIN
	INSERT INTO G_DE_GESTION.producto_local(
		local_id,
		producto_codigo,
		producto_local_precio
	)
	SELECT DISTINCT
		l.local_id,
		p.producto_codigo,
		m.PRODUCTO_LOCAL_PRECIO
	FROM gd_esquema.Maestra m
	JOIN G_DE_GESTION.local l ON (l.local_nombre = m.LOCAL_NOMBRE)
	JOIN G_DE_GESTION.producto p ON (p.producto_codigo = m.PRODUCTO_LOCAL_CODIGO)
	WHERE m.PRODUCTO_LOCAL_CODIGO IS NOT NULL
END
GO

CREATE PROCEDURE G_DE_GESTION.migrar_producto_pedido AS
BEGIN
	INSERT INTO G_DE_GESTION.producto_pedido(
		pedido_nro,
		local_id,
		producto_codigo,
		producto_pedido_precio,
		producto_pedido_cantidad
	)
	SELECT
		pe.pedido_nro,
		pe.local_id,
		pl.producto_codigo,
		pl.producto_local_precio,
		m.PRODUCTO_CANTIDAD * count(*)
	FROM gd_esquema.Maestra m
	JOIN G_DE_GESTION.pedido pe ON (pe.pedido_nro = m.PEDIDO_NRO)
	JOIN G_DE_GESTION.producto_local pl ON (pl.local_id = pe.local_id AND pl.producto_codigo = m.PRODUCTO_LOCAL_CODIGO)
	WHERE m.PEDIDO_NRO IS NOT NULL AND m.PRODUCTO_LOCAL_CODIGO IS NOT NULL
	GROUP BY
		pe.pedido_nro,
		pe.local_id,
		pl.producto_codigo,
		pl.producto_local_precio,
		m.PRODUCTO_CANTIDAD
END
GO

CREATE PROCEDURE G_DE_GESTION.migrar_cupon AS
BEGIN
	-- CUPON
	INSERT INTO G_DE_GESTION.cupon(
		cupon_nro,
		cupon_monto,
		cupon_fecha_alta,
		cupon_fecha_vencimiento,
		tipo_cupon_id,
		usuario_id
	)
	SELECT 
		m.CUPON_NRO,
		m.CUPON_MONTO,
		m.CUPON_FECHA_ALTA,
		m.CUPON_FECHA_VENCIMIENTO,
		tc.tipo_cupon_id,
		u.usuario_id
	FROM gd_esquema.Maestra m
	JOIN G_DE_GESTION.tipo_cupon tc ON (tc.tipo_cupon_descripcion = m.CUPON_TIPO)
	JOIN G_DE_GESTION.usuario u ON (u.usuario_dni = m.USUARIO_DNI)
	WHERE m.CUPON_NRO IS NOT NULL AND m.PEDIDO_NRO IS NOT NULL
	
	-- CUPON_RECLAMO
	INSERT INTO G_DE_GESTION.cupon(
		cupon_nro,
		cupon_monto,
		cupon_fecha_alta,
		cupon_fecha_vencimiento,
		tipo_cupon_id,
		usuario_id
	)
	SELECT 
		m.CUPON_RECLAMO_NRO,
		m.CUPON_RECLAMO_MONTO,
		m.CUPON_RECLAMO_FECHA_ALTA,
		m.CUPON_RECLAMO_FECHA_VENCIMIENTO,
		tc.tipo_cupon_id,
		u.usuario_id
	FROM gd_esquema.Maestra m
	JOIN G_DE_GESTION.tipo_cupon tc ON (tc.tipo_cupon_descripcion = m.CUPON_RECLAMO_TIPO)
	JOIN G_DE_GESTION.usuario u ON (u.usuario_dni = m.USUARIO_DNI)
	WHERE m.CUPON_RECLAMO_NRO IS NOT NULL AND RECLAMO_NRO IS NOT NULL
END
GO

CREATE PROCEDURE G_DE_GESTION.migrar_cupon_reclamo AS
BEGIN
	INSERT INTO G_DE_GESTION.cupon_reclamo(
		cupon_id,
		reclamo_nro,
		cupon_reclamo_monto
	)
	SELECT 
		c.cupon_id,
		r.reclamo_nro,
		c.cupon_monto
	FROM gd_esquema.Maestra m
	JOIN G_DE_GESTION.reclamo r ON (r.reclamo_nro = m.RECLAMO_NRO)
	JOIN G_DE_GESTION.cupon c ON (c.cupon_nro = m.CUPON_RECLAMO_NRO)
	WHERE c.cupon_id > (SELECT count(*) FROM gd_esquema.Maestra m
						WHERE m.CUPON_NRO IS NOT NULL AND m.PEDIDO_NRO IS NOT NULL)
END
GO

CREATE PROCEDURE G_DE_GESTION.migrar_cupon_pedido AS
BEGIN
	INSERT INTO G_DE_GESTION.cupon_pedido(
		pedido_nro,
		cupon_id,
		cupon_pedido_monto
	)
	SELECT DISTINCT
		p.pedido_nro,
		c.cupon_id,
		c.cupon_monto
	FROM gd_esquema.Maestra m
	JOIN G_DE_GESTION.pedido p ON (p.pedido_nro = m.PEDIDO_NRO)
	JOIN G_DE_GESTION.cupon c ON (c.cupon_nro = m.CUPON_NRO)
	WHERE c.cupon_id <= (SELECT count(*) FROM gd_esquema.Maestra m
						WHERE m.CUPON_NRO IS NOT NULL AND m.PEDIDO_NRO IS NOT NULL)
END
GO

CREATE PROCEDURE G_DE_GESTION.migrar_localidad_repartidor AS
BEGIN
	INSERT INTO G_DE_GESTION.localidad_repartidor(
		localidad_id,
		repartidor_id
	)
	SELECT DISTINCT
		l.localidad_id,
		r.repartidor_id	
	FROM gd_esquema.Maestra m
	JOIN G_DE_GESTION.localidad l ON (l.localidad_descripcion = m.LOCAL_LOCALIDAD)
	JOIN G_DE_GESTION.repartidor r ON (r.repartidor_dni = m.REPARTIDOR_DNI)
	WHERE m.PEDIDO_NRO IS NOT NULL
	UNION
	SELECT DISTINCT
		l.localidad_id,
		r.repartidor_id	
	FROM gd_esquema.Maestra m
	JOIN G_DE_GESTION.localidad l ON (l.localidad_descripcion = m.ENVIO_MENSAJERIA_LOCALIDAD)
	JOIN G_DE_GESTION.repartidor r ON (r.repartidor_dni = m.REPARTIDOR_DNI)
	WHERE m.ENVIO_MENSAJERIA_NRO IS NOT NULL
END
GO


----- Migracion OLTP -----
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
	EXECUTE G_DE_GESTION.migrar_cupon
	EXECUTE G_DE_GESTION.migrar_provincias
	EXECUTE G_DE_GESTION.migrar_localidades
	EXECUTE G_DE_GESTION.migrar_tarjeta
	EXECUTE G_DE_GESTION.migrar_direcciones
	EXECUTE G_DE_GESTION.migrar_direccion_usuario
	EXECUTE G_DE_GESTION.migrar_repartidor
	EXECUTE G_DE_GESTION.migrar_medio_pago
	EXECUTE G_DE_GESTION.migrar_estado_envio_mensajeria
	EXECUTE G_DE_GESTION.migrar_envio_mensajeria
	EXECUTE G_DE_GESTION.migrar_categoria
	EXECUTE G_DE_GESTION.migrar_local
	EXECUTE G_DE_GESTION.migrar_estado_pedido
	EXECUTE G_DE_GESTION.migrar_pedido
	EXECUTE G_DE_GESTION.migrar_estado_reclamo
	EXECUTE G_DE_GESTION.migrar_reclamo
	EXECUTE G_DE_GESTION.migrar_horario_local
	EXECUTE G_DE_GESTION.migrar_producto_local
	EXECUTE G_DE_GESTION.migrar_producto_pedido
	EXECUTE G_DE_GESTION.migrar_cupon_reclamo
	EXECUTE G_DE_GESTION.migrar_cupon_pedido
	EXECUTE G_DE_GESTION.migrar_localidad_repartidor
COMMIT TRANSACTION
GO

----- Drop de FUNCTIONs y PROCEDUREs -----
DROP FUNCTION G_DE_GESTION.obtener_provincia_codigo
DROP FUNCTION G_DE_GESTION.obtener_codigo_localidad
DROP FUNCTION G_DE_GESTION.obtener_codigo_tipo_direccion
DROP FUNCTION G_DE_GESTION.obtener_codigo_direccion
DROP FUNCTION G_DE_GESTION.obtener_codigo_usuario
DROP FUNCTION G_DE_GESTION.obtener_marca_tarjeta

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
DROP PROCEDURE G_DE_GESTION.migrar_cupon
DROP PROCEDURE G_DE_GESTION.migrar_provincias
DROP PROCEDURE G_DE_GESTION.migrar_localidades
DROP PROCEDURE G_DE_GESTION.migrar_tarjeta
DROP PROCEDURE G_DE_GESTION.migrar_direcciones
DROP PROCEDURE G_DE_GESTION.migrar_direccion_usuario
DROP PROCEDURE G_DE_GESTION.migrar_repartidor
DROP PROCEDURE G_DE_GESTION.migrar_medio_pago
DROP PROCEDURE G_DE_GESTION.migrar_envio_mensajeria
DROP PROCEDURE G_DE_GESTION.migrar_local
DROP PROCEDURE G_DE_GESTION.migrar_pedido
DROP PROCEDURE G_DE_GESTION.migrar_reclamo
DROP PROCEDURE G_DE_GESTION.migrar_horario_local
DROP PROCEDURE G_DE_GESTION.migrar_producto_local
DROP PROCEDURE G_DE_GESTION.migrar_producto_pedido
DROP PROCEDURE G_DE_GESTION.migrar_cupon_reclamo
DROP PROCEDURE G_DE_GESTION.migrar_cupon_pedido
DROP PROCEDURE G_DE_GESTION.migrar_localidad_repartidor
DROP PROCEDURE G_DE_GESTION.migrar_categoria
DROP PROCEDURE G_DE_GESTION.migrar_estado_reclamo
DROP PROCEDURE G_DE_GESTION.migrar_estado_pedido
DROP PROCEDURE G_DE_GESTION.migrar_estado_envio_mensajeria
GO