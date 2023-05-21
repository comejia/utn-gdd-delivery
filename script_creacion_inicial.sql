USE GD1C2023
GO

IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'G_DE_GESTION')
BEGIN 
	EXEC('CREATE SCHEMA G_DE_GESTION')
END
GO

-- Total tablas = 32

-- Se eliminan las tablas si existen (para testeo y tener ambiente limpio)
IF OBJECT_ID('G_DE_GESTION.tipo_direccion') IS NOT NULL DROP TABLE G_DE_GESTION.tipo_direccion
IF OBJECT_ID('G_DE_GESTION.direccion') IS NOT NULL DROP TABLE G_DE_GESTION.direccion
IF OBJECT_ID('G_DE_GESTION.direccion_usuario') IS NOT NULL DROP TABLE G_DE_GESTION.direccion_usuario
IF OBJECT_ID('G_DE_GESTION.usuario') IS NOT NULL DROP TABLE G_DE_GESTION.usuario
IF OBJECT_ID('G_DE_GESTION.marca_tarjeta') IS NOT NULL DROP TABLE G_DE_GESTION.marca_tarjeta
IF OBJECT_ID('G_DE_GESTION.tarjeta') IS NOT NULL DROP TABLE G_DE_GESTION.tarjeta
IF OBJECT_ID('G_DE_GESTION.horario_local') IS NOT NULL DROP TABLE G_DE_GESTION.horario_local
IF OBJECT_ID('G_DE_GESTION.medio_pago') IS NOT NULL DROP TABLE G_DE_GESTION.medio_pago
IF OBJECT_ID('G_DE_GESTION.localidad') IS NOT NULL DROP TABLE G_DE_GESTION.localidad
IF OBJECT_ID('G_DE_GESTION.provincia') IS NOT NULL DROP TABLE G_DE_GESTION.provincia
IF OBJECT_ID('G_DE_GESTION.cupon') IS NOT NULL DROP TABLE G_DE_GESTION.cupon
IF OBJECT_ID('G_DE_GESTION.producto') IS NOT NULL DROP TABLE G_DE_GESTION.producto
IF OBJECT_ID('G_DE_GESTION.pedido') IS NOT NULL DROP TABLE G_DE_GESTION.pedido
IF OBJECT_ID('G_DE_GESTION.localidad_repartidor') IS NOT NULL DROP TABLE G_DE_GESTION.localidad_repartidor
IF OBJECT_ID('G_DE_GESTION.repartidor') IS NOT NULL DROP TABLE G_DE_GESTION.repartidor
IF OBJECT_ID('G_DE_GESTION.reclamo') IS NOT NULL DROP TABLE G_DE_GESTION.reclamo
IF OBJECT_ID('G_DE_GESTION.tipo_reclamo') IS NOT NULL DROP TABLE G_DE_GESTION.tipo_reclamo
IF OBJECT_ID('G_DE_GESTION.operador_reclamo') IS NOT NULL DROP TABLE G_DE_GESTION.operador_reclamo
IF OBJECT_ID('G_DE_GESTION.cupon_reclamo') IS NOT NULL DROP TABLE G_DE_GESTION.cupon_reclamo
IF OBJECT_ID('G_DE_GESTION.pedido_cupon') IS NOT NULL DROP TABLE G_DE_GESTION.pedido_cupon
IF OBJECT_ID('G_DE_GESTION.envio_mensajeria') IS NOT NULL DROP TABLE G_DE_GESTION.envio_mensajeria
IF OBJECT_ID('G_DE_GESTION.local') IS NOT NULL DROP TABLE G_DE_GESTION.local
IF OBJECT_ID('G_DE_GESTION.tipo_cupon') IS NOT NULL DROP TABLE G_DE_GESTION.tipo_cupon
IF OBJECT_ID('G_DE_GESTION.horario_local') IS NOT NULL DROP TABLE G_DE_GESTION.horario_local
IF OBJECT_ID('G_DE_GESTION.horario') IS NOT NULL DROP TABLE G_DE_GESTION.horario
IF OBJECT_ID('G_DE_GESTION.categoria') IS NOT NULL DROP TABLE G_DE_GESTION.categoria
IF OBJECT_ID('G_DE_GESTION.tipo_local') IS NOT NULL DROP TABLE G_DE_GESTION.tipo_local
IF OBJECT_ID('G_DE_GESTION.producto_local') IS NOT NULL DROP TABLE G_DE_GESTION.producto_local
IF OBJECT_ID('G_DE_GESTION.producto_pedido') IS NOT NULL DROP TABLE G_DE_GESTION.producto_pedido
IF OBJECT_ID('G_DE_GESTION.tipo_movilidad') IS NOT NULL DROP TABLE G_DE_GESTION.tipo_movilidad
IF OBJECT_ID('G_DE_GESTION.paquete') IS NOT NULL DROP TABLE G_DE_GESTION.paquete
IF OBJECT_ID('G_DE_GESTION.tipo_paquete') IS NOT NULL DROP TABLE G_DE_GESTION.tipo_paquete
GO

-- Creacion de Tablas
CREATE TABLE G_DE_GESTION.provincia(
provincia_codigo DECIMAL(19,0) IDENTITY (1,1) PRIMARY KEY,
provincia_nombre NVARCHAR(255) NOT NULL
);
GO

CREATE TABLE G_DE_GESTION.localidad(
localidad_codigo DECIMAL(19,0) IDENTITY (1,1) PRIMARY KEY,
localidad_nombre NVARCHAR(255) NOT NULL,
localidad_codigo_postal DECIMAL(18,0) NOT NULL,
provincia_codigo DECIMAL(19,0) REFERENCES G_DE_GESTION.provincia
);
GO

-- Pensar el codigo vs cuit
CREATE TABLE G_DE_GESTION.repartidor(
proveedor_codigo DECIMAL(19,0) IDENTITY(1,1) PRIMARY KEY,
proveedor_razon_social NVARCHAR(50) NOT NULL,
proveedor_cuit NVARCHAR(50) NOT NULL,
proveedor_domicilio NVARCHAR(50) NOT NULL,
proveedor_mail NVARCHAR(50) NOT NULL,
localidad_codigo DECIMAL(19,0) REFERENCES G_DE_GESTION.localidad
);
GO

CREATE TABLE G_DE_GESTION.reclamo(
cliente_codigo DECIMAL(19,0) IDENTITY(1,1) PRIMARY KEY,
cliente_dni DECIMAL(18,0) NOT NULL,
cliente_nombre NVARCHAR(255) NOT NULL,
cliente_apellido NVARCHAR(255) NOT NULL,
cliente_direccion NVARCHAR(255) NOT NULL,
cliente_telefono DECIMAL(18,0) NOT NULL,
cliente_mail NVARCHAR(255) NOT NULL,
cliente_fecha_nac DATE NOT NULL,
localidad_codigo DECIMAL(19,0) REFERENCES G_DE_GESTION.localidad
);
GO


CREATE TABLE G_DE_GESTION.horario_local(
tipo_envio_codigo DECIMAL(19,0) IDENTITY(1,1) PRIMARY KEY,
tipo_envio_detalle NVARCHAR(255) NOT NULL
);
GO

CREATE TABLE G_DE_GESTION.usuario(
localidad_codigo DECIMAL(19,0) REFERENCES G_DE_GESTION.localidad,
tipo_envio_codigo DECIMAL(19,0) REFERENCES G_DE_GESTION.horario_local,
PRIMARY KEY (localidad_codigo, tipo_envio_codigo),
);
GO

CREATE TABLE G_DE_GESTION.tarjeta(
envio_codigo DECIMAL(19,0) IDENTITY(1,1) PRIMARY KEY,
envio_precio DECIMAL(18,2) NOT NULL,
tipo_envio_codigo DECIMAL(19,0) REFERENCES G_DE_GESTION.horario_local
);
GO

CREATE TABLE G_DE_GESTION.operador_reclamo (
tipo_canal_codigo DECIMAL(19,0) IDENTITY(1,1) PRIMARY KEY,
tipo_canal_detalle NVARCHAR(255) NOT NULL
);
GO

CREATE TABLE G_DE_GESTION.tipo_reclamo (
canal_codigo DECIMAL(19,0) IDENTITY(1,1) PRIMARY KEY,
canal_costo DECIMAL(18,2) NOT NULL,
tipo_canal_codigo DECIMAL(19,0) REFERENCES G_DE_GESTION.operador_reclamo
);
GO


CREATE TABLE G_DE_GESTION.horario_local(
tipo_medio_pago_codigo DECIMAL(19,0) IDENTITY(1,1) PRIMARY KEY,
tipo_medio_pago_Detalle NVARCHAR(255) NOT NULL,
tipo_medio_pago_descuento DECIMAL(18,2)
);
GO

CREATE TABLE G_DE_GESTION.medio_pago(
medio_pago_codigo DECIMAL(19,0) IDENTITY(1,1) PRIMARY KEY,
medio_pago_costo DECIMAL(18,2),
tipo_medio_pago_codigo DECIMAL(19,0) REFERENCES G_DE_GESTION.horario_local
);
GO

CREATE TABLE G_DE_GESTION.envio_mensajeria(
descuento_compra_codigo DECIMAL(19,0) PRIMARY KEY,
descuento_compra_valor DECIMAL(18,2) NOT NULL
);
GO

CREATE TABLE G_DE_GESTION.localidad_repartidor(
compra_numero DECIMAL(19,0) PRIMARY KEY,
compra_fecha DATE NOT NULL,
compra_total DECIMAL(18,2) NOT NULL,
medio_pago_codigo DECIMAL(19,0) REFERENCES G_DE_GESTION.medio_pago,
descuento_compra_codigo DECIMAL(19,0) REFERENCES G_DE_GESTION.envio_mensajeria,
proveedor_codigo DECIMAL(19,0) REFERENCES G_DE_GESTION.repartidor
);
GO

CREATE TABLE G_DE_GESTION.pedido_cupon(
categoria_producto_codigo DECIMAL(19,0) IDENTITY(1,1) PRIMARY KEY,
categoria_producto_tipo NVARCHAR(255) NOT NULL
);
GO

CREATE TABLE G_DE_GESTION.tipo_cupon(
tipo_variante_codigo DECIMAL(19,0) IDENTITY(1,1) PRIMARY KEY,
tipo_variante_detalle NVARCHAR(255) NOT NULL
);
GO

CREATE TABLE G_DE_GESTION.local(
variante_codigo NVARCHAR(50) PRIMARY KEY,
variante_descripcion NVARCHAR(50) NOT NULL,
tipo_variante_codigo DECIMAL(19,0) REFERENCES G_DE_GESTION.tipo_cupon
);
GO

CREATE TABLE G_DE_GESTION.producto(
producto_codigo NVARCHAR(50) PRIMARY KEY,
producto_nombre NVARCHAR(50) NOT NULL,
producto_descripcion NVARCHAR(50) NOT NULL,
producto_material NVARCHAR(50) NOT NULL,
producto_marca NVARCHAR(255) NOT NULL,
categoria_producto_codigo DECIMAL(19,0) REFERENCES G_DE_GESTION.pedido_cupon,
producto_variante_codigo NVARCHAR(50) REFERENCES G_DE_GESTION.local
);
GO

CREATE TABLE G_DE_GESTION.pedido(
compra_numero DECIMAL(19,0) REFERENCES G_DE_GESTION.localidad_repartidor,
producto_codigo NVARCHAR(50) REFERENCES G_DE_GESTION.producto,
compra_producto_cantidad DECIMAL(18,0) NOT NULL,
compra_producto_precio DECIMAL(18,2) NOT NULL,
PRIMARY KEY(compra_numero, producto_codigo)
);
GO

CREATE TABLE G_DE_GESTION.marca_tarjeta(
venta_codigo DECIMAL(19,0) PRIMARY KEY,
venta_fecha DATE NOT NULL,
venta_total DECIMAL(18,2) NOT NULL,
cliente_codigo DECIMAL(19,0) REFERENCES G_DE_GESTION.reclamo,
canal_codigo DECIMAL(19,0) REFERENCES G_DE_GESTION.tipo_reclamo,
medio_pago_codigo DECIMAL(19,0) REFERENCES G_DE_GESTION.medio_pago,
envio_codigo DECIMAL(19,0) REFERENCES G_DE_GESTION.tarjeta
);
GO

CREATE TABLE G_DE_GESTION.cupon_reclamo (
tipo_descuento_codigo DECIMAL(19,0) IDENTITY(1,1) PRIMARY KEY,
tipo_descuento_detalle NVARCHAR(255) NOT NULL
);
GO


CREATE TABLE G_DE_GESTION.direccion(
venta_descuento_codigo DECIMAL(19,0) IDENTITY(1,1) PRIMARY KEY,
venta_descuento_importe DECIMAL(18,2) NOT NULL,
venta_codigo DECIMAL(19,0) REFERENCES G_DE_GESTION.marca_tarjeta,
tipo_descuento_codigo DECIMAL(19,0) REFERENCES G_DE_GESTION.cupon_reclamo
);
GO

CREATE TABLE G_DE_GESTION.direccion_usuario(
producto_codigo NVARCHAR(50) REFERENCES G_DE_GESTION.producto,
venta_codigo DECIMAL(19,0) REFERENCES G_DE_GESTION.marca_tarjeta,
venta_producto_cantidad DECIMAL(18,0) NOT NULL,
venta_producto_precio DECIMAL(18,2) NOT NULL,
PRIMARY KEY (producto_codigo, venta_codigo)
);
GO

CREATE TABLE G_DE_GESTION.cupon(
cupon_codigo NVARCHAR(255) PRIMARY KEY,
cupon_fecha_desde DATE NOT NULL,
cupon_fecha_hasta DATE NOT NULL,
cupon_valor DECIMAL(18,2) NOT NULL,
cupon_tipo NVARCHAR(50) NOT NULL
);

GO

CREATE TABLE G_DE_GESTION.tipo_direccion(
cupon_codigo NVARCHAR(255) REFERENCES G_DE_GESTION.cupon,
venta_codigo DECIMAL(19,0) REFERENCES G_DE_GESTION.marca_tarjeta,
venta_cupon_importe DECIMAL(18,2) NOT NULL,
);

GO

-- Funciones ----

CREATE FUNCTION G_DE_GESTION.obtener_provincia_codigo (@provincia_nombre VARCHAR(255))
RETURNS DECIMAL(19,0)
AS
BEGIN
	DECLARE @codigo_obtenido DECIMAL
	SELECT @codigo_obtenido = lp.provincia_codigo FROM G_DE_GESTION.provincia lp WHERE lp.provincia_nombre = @provincia_nombre;
	RETURN @codigo_obtenido
END
GO

CREATE FUNCTION G_DE_GESTION.obtener_localidad_codigo (@localidad_nombre VARCHAR(255), @localidad_codigo_postal DECIMAL(19,0), @provincia_nombre VARCHAR(255))
RETURNS DECIMAL(19,0)
AS
BEGIN
	DECLARE @codigo_obtenido DECIMAL
	SELECT @codigo_obtenido = l.localidad_codigo FROM G_DE_GESTION.localidad l 
	WHERE l.localidad_nombre = @localidad_nombre 
		AND l.localidad_codigo_postal = @localidad_codigo_postal 
		AND l.provincia_codigo = G_DE_GESTION.obtener_provincia_codigo(@provincia_nombre)
	RETURN @codigo_obtenido
END
GO

CREATE FUNCTION G_DE_GESTION.obtener_categoria_codigo (@categoria_producto_tipo VARCHAR(255))
RETURNS DECIMAL(19,0)
AS
BEGIN
	DECLARE @codigo_obtenido DECIMAL
	SELECT @codigo_obtenido = cp.categoria_producto_codigo FROM G_DE_GESTION.pedido_cupon cp WHERE cp.categoria_producto_tipo = @categoria_producto_tipo;
	RETURN @codigo_obtenido
END
GO

CREATE FUNCTION G_DE_GESTION.obtener_tipo_envio_codigo (@venta_medio_envio VARCHAR(255))
RETURNS DECIMAL(19,0)
AS
BEGIN
	DECLARE @codigo_obtenido DECIMAL
	SELECT @codigo_obtenido = te.tipo_envio_codigo FROM G_DE_GESTION.horario_local te WHERE te.tipo_envio_detalle LIKE @venta_medio_envio;
	RETURN @codigo_obtenido
END
GO

CREATE FUNCTION G_DE_GESTION.obtener_tipo_medio_pago_codigo (@venta_medio_pago_detalle NVARCHAR(255))
RETURNS DECIMAL(19,0)
AS
BEGIN
	DECLARE @codigo_obtenido DECIMAL
	SELECT @codigo_obtenido = tmp.tipo_medio_pago_codigo FROM G_DE_GESTION.horario_local tmp WHERE tmp.tipo_medio_pago_Detalle LIKE @venta_medio_pago_detalle;
	RETURN @codigo_obtenido
END
GO

CREATE FUNCTION G_DE_GESTION.obtener_pago_codigo (@medio_pago_costo DECIMAL(18,2), @medio_pago_detalle NVARCHAR(255))
RETURNS DECIMAL(19,0)
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
RETURNS DECIMAL(19,0)
AS
BEGIN
    DECLARE @codigo_obtenido DECIMAL
    SELECT @codigo_obtenido = tp.tipo_variante_codigo FROM G_DE_GESTION.tipo_cupon tp WHERE tp.tipo_variante_detalle = @tipo_variante_detalle
    RETURN @codigo_obtenido
END
GO


CREATE FUNCTION G_DE_GESTION.obtener_medio_pago_codigo (@venta_medio_pago_detalle NVARCHAR(255))
RETURNS DECIMAL(19,0)
AS
BEGIN
    DECLARE @codigo_obtenido DECIMAL
    SELECT @codigo_obtenido = mp.medio_pago_codigo FROM G_DE_GESTION.medio_pago mp WHERE G_DE_GESTION.obtener_tipo_medio_pago_codigo(@venta_medio_pago_detalle) = mp.tipo_medio_pago_codigo;
    RETURN @codigo_obtenido
END
GO

CREATE FUNCTION G_DE_GESTION.obtener_proveedor_codigo (@proveedor_cuit nvarchar(50))
RETURNS DECIMAL(19,0)
AS
BEGIN
    DECLARE @codigo_obtenido DECIMAL
    SELECT @codigo_obtenido = p.proveedor_codigo FROM G_DE_GESTION.repartidor p WHERE p.proveedor_cuit = @proveedor_cuit
    RETURN @codigo_obtenido
END
GO


--- Procedures ----

CREATE PROCEDURE [G_DE_GESTION].migrar_pronvincias AS
BEGIN
	INSERT INTO G_DE_GESTION.provincia  (provincia_nombre)
	SELECT DISTINCT m.CLIENTE_PROVINCIA
	FROM gd_esquema.Maestra m 
	WHERE m.CLIENTE_PROVINCIA IS NOT NULL
	UNION 
	SELECT DISTINCT  m.PROVEEDOR_PROVINCIA
	FROM gd_esquema.Maestra m 
	WHERE m.PROVEEDOR_PROVINCIA IS NOT NULL 
END
GO

CREATE PROCEDURE [G_DE_GESTION].migrar_localidades AS
BEGIN
	INSERT INTO G_DE_GESTION.localidad (localidad_nombre, localidad_codigo_postal, provincia_codigo)
	SELECT DISTINCT m.CLIENTE_LOCALIDAD as localidad_nombre, m.CLIENTE_CODIGO_POSTAL as localidad_codigo_postal, G_DE_GESTION.obtener_provincia_codigo(m.CLIENTE_PROVINCIA) as provincia_codigo
	FROM gd_esquema.Maestra m 
	WHERE m.CLIENTE_LOCALIDAD IS NOT NULL
	UNION 
	SELECT DISTINCT  m.PROVEEDOR_LOCALIDAD, m.PROVEEDOR_CODIGO_POSTAL, G_DE_GESTION.obtener_provincia_codigo(m.PROVEEDOR_PROVINCIA) as provincia_codigo
	FROM gd_esquema.Maestra m 
	WHERE m.PROVEEDOR_LOCALIDAD IS NOT NULL 
END
GO

CREATE PROCEDURE [G_DE_GESTION].migrar_clientes AS
BEGIN
	INSERT INTO G_DE_GESTION.reclamo(cliente_dni,
	cliente_nombre, cliente_apellido, cliente_direccion, cliente_telefono, cliente_mail,
	cliente_fecha_nac, localidad_codigo)
	SELECT DISTINCT CLIENTE_DNI,CLIENTE_NOMBRE ,CLIENTE_APELLIDO, CLIENTE_DIRECCION, CLIENTE_TELEFONO,
	CLIENTE_MAIL, CLIENTE_FECHA_NAC, G_DE_GESTION.obtener_localidad_codigo(CLIENTE_LOCALIDAD, CLIENTE_CODIGO_POSTAL, CLIENTE_PROVINCIA) FROM gd_esquema.Maestra m
	WHERE CLIENTE_DNI IS NOT NULL
END
GO

CREATE PROCEDURE [G_DE_GESTION].migrar_proveedores AS
BEGIN
	INSERT INTO G_DE_GESTION.repartidor (proveedor_cuit, proveedor_domicilio, proveedor_mail, proveedor_razon_social, localidad_codigo)
	SELECT DISTINCT m.PROVEEDOR_CUIT, m.PROVEEDOR_DOMICILIO, m.PROVEEDOR_MAIL, m.PROVEEDOR_RAZON_SOCIAL,
							G_DE_GESTION.obtener_localidad_codigo(PROVEEDOR_LOCALIDAD, PROVEEDOR_CODIGO_POSTAL, PROVEEDOR_PROVINCIA)
	FROM gd_esquema.Maestra m WHERE m.PROVEEDOR_CUIT IS NOT NULL
END
GO

CREATE PROCEDURE [G_DE_GESTION].migrar_descuento_compra AS
BEGIN
	INSERT INTO G_DE_GESTION.envio_mensajeria (descuento_compra_codigo, descuento_compra_valor)
	SELECT DISTINCT m.DESCUENTO_COMPRA_CODIGO, m.DESCUENTO_COMPRA_VALOR
	FROM gd_esquema.Maestra m WHERE m.DESCUENTO_COMPRA_CODIGO IS NOT NULL AND m.DESCUENTO_COMPRA_VALOR IS NOT NULL
END
GO

CREATE PROCEDURE [G_DE_GESTION].migrar_categorias_productos AS
BEGIN
	INSERT INTO G_DE_GESTION.pedido_cupon (categoria_producto_tipo)
	SELECT DISTINCT m.PRODUCTO_CATEGORIA 
	FROM gd_esquema.Maestra m WHERE m.PRODUCTO_CATEGORIA IS NOT NULL 
END
GO

CREATE PROCEDURE [G_DE_GESTION].migrar_tipo_canal AS
BEGIN
    INSERT INTO G_DE_GESTION.operador_reclamo(tipo_canal_detalle)
    SELECT distinct m.VENTA_CANAL 
    FROM gd_esquema.Maestra m 
    WHERE m.VENTA_CANAL IS NOT NULL
END
GO

CREATE PROCEDURE [G_DE_GESTION].migrar_canal AS
BEGIN
	INSERT INTO G_DE_GESTION.tipo_reclamo(tipo_canal_codigo, canal_costo)
	SELECT distinct t.tipo_canal_codigo, m.VENTA_CANAL_COSTO
	FROM gd_esquema.Maestra m join G_DE_GESTION.operador_reclamo t on t.tipo_canal_detalle = m.VENTA_CANAL
END
GO

CREATE PROCEDURE [G_DE_GESTION].migrar_tipo_envio AS
BEGIN
	INSERT INTO G_DE_GESTION.horario_local (tipo_envio_detalle)
	SELECT DISTINCT m.VENTA_MEDIO_ENVIO FROM gd_esquema.Maestra m WHERE m.VENTA_MEDIO_ENVIO IS NOT NULL
END
GO

CREATE PROCEDURE [G_DE_GESTION].migrar_envio AS
BEGIN
	INSERT INTO G_DE_GESTION.tarjeta (envio_precio, tipo_envio_codigo)
	SELECT DISTINCT m.VENTA_ENVIO_PRECIO, G_DE_GESTION.obtener_tipo_envio_codigo(m.VENTA_MEDIO_ENVIO) as tipo_envio_codigo 
	FROM gd_esquema.Maestra m
	WHERE m.VENTA_MEDIO_ENVIO IS NOT NULL
END
GO

--- dudoso. 
CREATE PROCEDURE [G_DE_GESTION].migrar_tipo_envio_localidad AS
BEGIN
	INSERT INTO G_DE_GESTION.usuario (localidad_codigo, tipo_envio_codigo)
	SELECT DISTINCT G_DE_GESTION.obtener_localidad_codigo(m.CLIENTE_LOCALIDAD, m.CLIENTE_CODIGO_POSTAL, m.CLIENTE_PROVINCIA )as localidad_codigo, G_DE_GESTION.obtener_tipo_envio_codigo(m.VENTA_MEDIO_ENVIO) as tipo_envio_codigo
	FROM gd_esquema.Maestra m
	WHERE m.CLIENTE_LOCALIDAD IS NOT NULL AND m.VENTA_MEDIO_ENVIO IS NOT NULL
END
GO


CREATE PROCEDURE [G_DE_GESTION].migrar_tipo_descuento AS
BEGIN
	INSERT INTO G_DE_GESTION.cupon_reclamo (tipo_descuento_detalle)
	SELECT DISTINCT VENTA_DESCUENTO_CONCEPTO FROM gd_esquema.Maestra WHERE VENTA_DESCUENTO_CONCEPTO IS NOT NULL
END
GO


CREATE PROCEDURE [G_DE_GESTION].migrar_tipo_medio_pago AS
BEGIN 
	INSERT INTO G_DE_GESTION.horario_local(tipo_medio_pago_Detalle)
	SELECT DISTINCT VENTA_MEDIO_PAGO FROM gd_esquema.Maestra WHERE VENTA_MEDIO_PAGO IS NOT NULL
	UNION SELECT DISTINCT COMPRA_MEDIO_PAGO FROM gd_esquema.Maestra WHERE COMPRA_MEDIO_PAGO IS NOT NULL
END
GO



CREATE PROCEDURE [G_DE_GESTION].migrar_medio_pago AS
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

CREATE PROCEDURE [G_DE_GESTION].migrar_tipo_variante AS
BEGIN
    INSERT INTO G_DE_GESTION.tipo_cupon(tipo_variante_detalle) 
    SELECT distinct m.PRODUCTO_TIPO_VARIANTE
    FROM gd_esquema.Maestra m 
    WHERE m.PRODUCTO_TIPO_VARIANTE IS NOT NULL
END
GO

CREATE PROCEDURE [G_DE_GESTION].migrar_variante AS
BEGIN
    INSERT INTO G_DE_GESTION.local (variante_codigo, tipo_variante_codigo,variante_descripcion) 
    SELECT distinct m.PRODUCTO_VARIANTE_CODIGO, G_DE_GESTION.obtener_tipo_variante_codigo(m.PRODUCTO_TIPO_VARIANTE), m.PRODUCTO_VARIANTE
    FROM gd_esquema.Maestra m 
    WHERE m.PRODUCTO_VARIANTE_CODIGO IS NOT NULL
END
GO

CREATE PROCEDURE [G_DE_GESTION].migrar_venta AS
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

CREATE PROCEDURE [G_DE_GESTION].migrar_venta_descuento AS
BEGIN
	INSERT INTO G_DE_GESTION.direccion (venta_descuento_importe, venta_codigo, tipo_descuento_codigo)
	SELECT DISTINCT m.VENTA_DESCUENTO_IMPORTE, m.venta_codigo,td.tipo_descuento_codigo
	FROM gd_esquema.Maestra m
	JOIN G_DE_GESTION.cupon_reclamo td ON m.VENTA_DESCUENTO_CONCEPTO LIKE td.tipo_descuento_detalle
	WHERE VENTA_CODIGO IS NOT NULL
END
GO

CREATE PROCEDURE [G_DE_GESTION].migrar_cupones AS 
BEGIN
	INSERT INTO G_DE_GESTION.cupon (cupon_codigo, cupon_fecha_desde, cupon_fecha_hasta, cupon_tipo, cupon_valor)
	SELECT DISTINCT VENTA_CUPON_CODIGO, VENTA_CUPON_FECHA_DESDE, VENTA_CUPON_FECHA_HASTA, VENTA_CUPON_TIPO, VENTA_CUPON_VALOR FROM gd_esquema.Maestra
	WHERE VENTA_CUPON_CODIGO IS NOT NULL
END
GO

CREATE PROCEDURE [G_DE_GESTION].migrar_venta_cupon AS
BEGIN
	INSERT INTO G_DE_GESTION.tipo_direccion (cupon_codigo, venta_codigo, venta_cupon_importe)
	SELECT c.cupon_codigo , v.venta_codigo, m.VENTA_CUPON_IMPORTE FROM gd_esquema.Maestra m
	JOIN G_DE_GESTION.marca_tarjeta v ON v.venta_codigo = m.VENTA_CODIGO
	JOIN G_DE_GESTION.cupon c ON m.VENTA_CUPON_CODIGO = c.cupon_codigo
	WHERE m.VENTA_CODIGO IS NOT NULL AND m.VENTA_CUPON_CODIGO IS NOT NULL
END
GO

CREATE PROCEDURE [G_DE_GESTION].migrar_producto AS
BEGIN
    INSERT INTO G_DE_GESTION.producto(producto_codigo, categoria_producto_codigo, producto_descripcion, producto_marca, producto_material, 
        producto_nombre, producto_variante_codigo) 
    SELECT distinct m.PRODUCTO_CODIGO, G_DE_GESTION.obtener_categoria_codigo(m.PRODUCTO_CATEGORIA) , m.PRODUCTO_DESCRIPCION, m.PRODUCTO_MARCA, m.PRODUCTO_MATERIAL, m.PRODUCTO_NOMBRE, m.PRODUCTO_VARIANTE_CODIGO
    FROM gd_esquema.Maestra m 
    WHERE m.PRODUCTO_CODIGO IS NOT NULL
END
GO

CREATE PROCEDURE [G_DE_GESTION].migrar_venta_producto AS
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
CREATE PROCEDURE [G_DE_GESTION].migrar_compra AS
BEGIN
    INSERT INTO G_DE_GESTION.localidad_repartidor(compra_numero, compra_fecha, compra_total, descuento_compra_codigo, medio_pago_codigo, proveedor_codigo)
    SELECT distinct m.COMPRA_NUMERO, m.COMPRA_FECHA, m.COMPRA_TOTAL, m.DESCUENTO_COMPRA_CODIGO, 
    G_DE_GESTION.obtener_medio_pago_codigo(m.COMPRA_MEDIO_PAGO), G_DE_GESTION.obtener_proveedor_codigo(m.PROVEEDOR_CUIT)
    FROM gd_esquema.Maestra m 
    WHERE m.COMPRA_NUMERO is not null and m.DESCUENTO_COMPRA_CODIGO is not null
END
GO

CREATE PROCEDURE [G_DE_GESTION].migrar_compra_producto AS
BEGIN
	INSERT INTO G_DE_GESTION.pedido (compra_numero, producto_codigo, compra_producto_cantidad, compra_producto_precio)
	SELECT DISTINCT c.compra_numero, p.producto_codigo , SUM(m.COMPRA_PRODUCTO_CANTIDAD) as compra_producto_cantidad, SUM(m.COMPRA_PRODUCTO_PRECIO) as compra_producto_precio
	FROM gd_esquema.Maestra m
	JOIN G_DE_GESTION.producto p ON m.PRODUCTO_CODIGO LIKE p.producto_codigo
	JOIN G_DE_GESTION.localidad_repartidor c ON m.COMPRA_NUMERO = c.compra_numero
	GROUP BY c.compra_numero, p.producto_codigo
END
GO
-- Migracion

EXECUTE G_DE_GESTION.migrar_pronvincias
EXECUTE G_DE_GESTION.migrar_localidades
EXECUTE G_DE_GESTION.migrar_clientes
EXECUTE G_DE_GESTION.migrar_proveedores
EXECUTE G_DE_GESTION.migrar_descuento_compra
EXECUTE G_DE_GESTION.migrar_categorias_productos
EXECUTE G_DE_GESTION.migrar_tipo_envio
EXECUTE G_DE_GESTION.migrar_envio 
EXECUTE G_DE_GESTION.migrar_tipo_envio_localidad
EXECUTE G_DE_GESTION.migrar_tipo_descuento
EXECUTE G_DE_GESTION.migrar_tipo_medio_pago
EXECUTE G_DE_GESTION.migrar_medio_pago

EXECUTE G_DE_GESTION.migrar_variante


EXECUTE G_DE_GESTION.migrar_tipo_canal
EXECUTE G_DE_GESTION.migrar_canal
EXECUTE G_DE_GESTION.migrar_tipo_variante
EXECUTE G_DE_GESTION.migrar_venta

EXECUTE G_DE_GESTION.migrar_cupones
EXECUTE G_DE_GESTION.migrar_venta_cupon
EXECUTE G_DE_GESTION.migrar_venta_descuento
EXECUTE G_DE_GESTION.migrar_producto
EXECUTE G_DE_GESTION.migrar_venta_producto
EXECUTE G_DE_GESTION.migrar_compra
EXECUTE G_DE_GESTION.migrar_compra_producto
GO

-- Eliminaciones para despues correr el test

DROP FUNCTION G_DE_GESTION.obtener_provincia_codigo
DROP FUNCTION G_DE_GESTION.obtener_localidad_codigo
DROP FUNCTION G_DE_GESTION.obtener_categoria_codigo
DROP FUNCTION G_DE_GESTION.obtener_tipo_envio_codigo
DROP FUNCTION G_DE_GESTION.obtener_tipo_medio_pago_codigo
DROP FUNCTION G_DE_GESTION.obtener_pago_codigo
DROP FUNCTION G_DE_GESTION.obtener_tipo_variante_codigo
DROP FUNCTION G_DE_GESTION.obtener_proveedor_codigo
DROP FUNCTION G_DE_GESTION.obtener_medio_pago_codigo

DROP PROCEDURE [G_DE_GESTION].migrar_proveedores
DROP PROCEDURE [G_DE_GESTION].migrar_pronvincias
DROP PROCEDURE [G_DE_GESTION].migrar_localidades
DROP PROCEDURE [G_DE_GESTION].migrar_clientes
DROP PROCEDURE [G_DE_GESTION].migrar_descuento_compra
DROP PROCEDURE [G_DE_GESTION].migrar_categorias_productos
DROP PROCEDURE [G_DE_GESTION].migrar_tipo_envio
DROP PROCEDURE [G_DE_GESTION].migrar_envio 
DROP PROCEDURE [G_DE_GESTION].migrar_tipo_envio_localidad
DROP PROCEDURE [G_DE_GESTION].migrar_tipo_descuento
DROP PROCEDURE [G_DE_GESTION].migrar_tipo_medio_pago
DROP PROCEDURE [G_DE_GESTION].migrar_medio_pago
DROP PROCEDURE [G_DE_GESTION].migrar_venta
DROP PROCEDURE [G_DE_GESTION].migrar_venta_descuento

DROP PROCEDURE [G_DE_GESTION].migrar_venta_cupon
DROP PROCEDURE [G_DE_GESTION].migrar_variante

DROP PROCEDURE [G_DE_GESTION].migrar_tipo_canal
DROP PROCEDURE [G_DE_GESTION].migrar_canal
DROP PROCEDURE [G_DE_GESTION].migrar_tipo_variante
DROP PROCEDURE [G_DE_GESTION].migrar_cupones
DROP PROCEDURE [G_DE_GESTION].migrar_compra
DROP PROCEDURE [G_DE_GESTION].migrar_producto
DROP PROCEDURE [G_DE_GESTION].migrar_venta_producto
DROP PROCEDURE [G_DE_GESTION].migrar_compra_producto

GO