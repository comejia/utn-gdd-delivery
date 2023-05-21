USE GD1C2023
GO

IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name LIKE 'G_DE_GESTION')
BEGIN 
	EXEC('CREATE SCHEMA G_DE_GESTION')
END
GO

--- asi se pueden buscar las tablas y despues eliminarlas
--- Es para poder ir testeando
IF OBJECT_ID('LOS_MAGIOS.venta_cupon') IS NOT NULL DROP TABLE LOS_MAGIOS.venta_cupon
IF OBJECT_ID('LOS_MAGIOS.venta_descuento') IS NOT NULL DROP TABLE LOS_MAGIOS.venta_descuento
IF OBJECT_ID('LOS_MAGIOS.venta_producto') IS NOT NULL DROP TABLE LOS_MAGIOS.venta_producto
IF OBJECT_ID('LOS_MAGIOS.tipo_envio_localidad') IS NOT NULL DROP TABLE LOS_MAGIOS.tipo_envio_localidad
IF OBJECT_ID('LOS_MAGIOS.venta') IS NOT NULL DROP TABLE LOS_MAGIOS.venta
IF OBJECT_ID('LOS_MAGIOS.envio') IS NOT NULL DROP TABLE LOS_MAGIOS.envio
IF OBJECT_ID('LOS_MAGIOS.tipo_envio') IS NOT NULL DROP TABLE LOS_MAGIOS.tipo_envio
IF OBJECT_ID('LOS_MAGIOS.compra_producto') IS NOT NULL DROP TABLE LOS_MAGIOS.compra_producto
IF OBJECT_ID('LOS_MAGIOS.compra') IS NOT NULL DROP TABLE LOS_MAGIOS.compra
IF OBJECT_ID('LOS_MAGIOS.proveedor') IS NOT NULL DROP TABLE LOS_MAGIOS.proveedor
IF OBJECT_ID('LOS_MAGIOS.cliente') IS NOT NULL DROP TABLE LOS_MAGIOS.cliente
IF OBJECT_ID('LOS_MAGIOS.localidad') IS NOT NULL DROP TABLE LOS_MAGIOS.localidad
IF OBJECT_ID('LOS_MAGIOS.provincia') IS NOT NULL DROP TABLE LOS_MAGIOS.provincia
IF OBJECT_ID('LOS_MAGIOS.producto') IS NOT NULL DROP TABLE LOS_MAGIOS.producto
IF OBJECT_ID('LOS_MAGIOS.canal') IS NOT NULL DROP TABLE LOS_MAGIOS.canal
IF OBJECT_ID('LOS_MAGIOS.tipo_canal') IS NOT NULL DROP TABLE LOS_MAGIOS.tipo_canal
IF OBJECT_ID('LOS_MAGIOS.medio_pago') IS NOT NULL DROP TABLE LOS_MAGIOS.medio_pago
IF OBJECT_ID('LOS_MAGIOS.tipo_descuento') IS NOT NULL DROP TABLE LOS_MAGIOS.tipo_descuento
IF OBJECT_ID('LOS_MAGIOS.cupon') IS NOT NULL DROP TABLE LOS_MAGIOS.cupon
IF OBJECT_ID('LOS_MAGIOS.categoria_producto') IS NOT NULL DROP TABLE LOS_MAGIOS.categoria_producto
IF OBJECT_ID('LOS_MAGIOS.descuento_compra') IS NOT NULL DROP TABLE LOS_MAGIOS.descuento_compra
IF OBJECT_ID('LOS_MAGIOS.variante') IS NOT NULL DROP TABLE LOS_MAGIOS.variante
IF OBJECT_ID('LOS_MAGIOS.tipo_variante') IS NOT NULL DROP TABLE LOS_MAGIOS.tipo_variante
IF OBJECT_ID('LOS_MAGIOS.tipo_medio_pago') IS NOT NULL DROP TABLE LOS_MAGIOS.tipo_medio_pago
GO

--- Creacion de Tablas ----
CREATE TABLE LOS_MAGIOS.provincia(
provincia_codigo DECIMAL(19,0) IDENTITY (1,1) PRIMARY KEY,
provincia_nombre NVARCHAR(255) NOT NULL
);
GO

CREATE TABLE LOS_MAGIOS.localidad(
localidad_codigo DECIMAL(19,0) IDENTITY (1,1) PRIMARY KEY,
localidad_nombre NVARCHAR(255) NOT NULL,
localidad_codigo_postal DECIMAL(18,0) NOT NULL,
provincia_codigo DECIMAL(19,0) REFERENCES LOS_MAGIOS.provincia
);
GO

-- Pensar el codigo vs cuit
CREATE TABLE LOS_MAGIOS.proveedor(
proveedor_codigo DECIMAL(19,0) IDENTITY(1,1) PRIMARY KEY,
proveedor_razon_social NVARCHAR(50) NOT NULL,
proveedor_cuit NVARCHAR(50) NOT NULL,
proveedor_domicilio NVARCHAR(50) NOT NULL,
proveedor_mail NVARCHAR(50) NOT NULL,
localidad_codigo DECIMAL(19,0) REFERENCES LOS_MAGIOS.localidad
);
GO

CREATE TABLE LOS_MAGIOS.cliente(
cliente_codigo DECIMAL(19,0) IDENTITY(1,1) PRIMARY KEY,
cliente_dni DECIMAL(18,0) NOT NULL,
cliente_nombre NVARCHAR(255) NOT NULL,
cliente_apellido NVARCHAR(255) NOT NULL,
cliente_direccion NVARCHAR(255) NOT NULL,
cliente_telefono DECIMAL(18,0) NOT NULL,
cliente_mail NVARCHAR(255) NOT NULL,
cliente_fecha_nac DATE NOT NULL,
localidad_codigo DECIMAL(19,0) REFERENCES LOS_MAGIOS.localidad
);
GO


CREATE TABLE LOS_MAGIOS.tipo_envio(
tipo_envio_codigo DECIMAL(19,0) IDENTITY(1,1) PRIMARY KEY,
tipo_envio_detalle NVARCHAR(255) NOT NULL
);
GO

CREATE TABLE LOS_MAGIOS.tipo_envio_localidad(
localidad_codigo DECIMAL(19,0) REFERENCES LOS_MAGIOS.localidad,
tipo_envio_codigo DECIMAL(19,0) REFERENCES LOS_MAGIOS.tipo_envio,
PRIMARY KEY (localidad_codigo, tipo_envio_codigo),
);
GO

CREATE TABLE LOS_MAGIOS.envio(
envio_codigo DECIMAL(19,0) IDENTITY(1,1) PRIMARY KEY,
envio_precio DECIMAL(18,2) NOT NULL,
tipo_envio_codigo DECIMAL(19,0) REFERENCES LOS_MAGIOS.tipo_envio
);
GO

CREATE TABLE LOS_MAGIOS.tipo_canal (
tipo_canal_codigo DECIMAL(19,0) IDENTITY(1,1) PRIMARY KEY,
tipo_canal_detalle NVARCHAR(255) NOT NULL
);
GO

CREATE TABLE LOS_MAGIOS.canal (
canal_codigo DECIMAL(19,0) IDENTITY(1,1) PRIMARY KEY,
canal_costo DECIMAL(18,2) NOT NULL,
tipo_canal_codigo DECIMAL(19,0) REFERENCES LOS_MAGIOS.tipo_canal
);
GO


CREATE TABLE LOS_MAGIOS.tipo_medio_pago(
tipo_medio_pago_codigo DECIMAL(19,0) IDENTITY(1,1) PRIMARY KEY,
tipo_medio_pago_Detalle NVARCHAR(255) NOT NULL,
tipo_medio_pago_descuento DECIMAL(18,2)
);
GO

CREATE TABLE LOS_MAGIOS.medio_pago(
medio_pago_codigo DECIMAL(19,0) IDENTITY(1,1) PRIMARY KEY,
medio_pago_costo DECIMAL(18,2),
tipo_medio_pago_codigo DECIMAL(19,0) REFERENCES LOS_MAGIOS.tipo_medio_pago
);
GO

CREATE TABLE LOS_MAGIOS.descuento_compra(
descuento_compra_codigo DECIMAL(19,0) PRIMARY KEY,
descuento_compra_valor DECIMAL(18,2) NOT NULL
);
GO

CREATE TABLE LOS_MAGIOS.compra(
compra_numero DECIMAL(19,0) PRIMARY KEY,
compra_fecha DATE NOT NULL,
compra_total DECIMAL(18,2) NOT NULL,
medio_pago_codigo DECIMAL(19,0) REFERENCES LOS_MAGIOS.medio_pago,
descuento_compra_codigo DECIMAL(19,0) REFERENCES LOS_MAGIOS.descuento_compra,
proveedor_codigo DECIMAL(19,0) REFERENCES LOS_MAGIOS.proveedor
);
GO

CREATE TABLE LOS_MAGIOS.categoria_producto(
categoria_producto_codigo DECIMAL(19,0) IDENTITY(1,1) PRIMARY KEY,
categoria_producto_tipo NVARCHAR(255) NOT NULL
);
GO

CREATE TABLE LOS_MAGIOS.tipo_variante(
tipo_variante_codigo DECIMAL(19,0) IDENTITY(1,1) PRIMARY KEY,
tipo_variante_detalle NVARCHAR(255) NOT NULL
);
GO

CREATE TABLE LOS_MAGIOS.variante(
variante_codigo NVARCHAR(50) PRIMARY KEY,
variante_descripcion NVARCHAR(50) NOT NULL,
tipo_variante_codigo DECIMAL(19,0) REFERENCES LOS_MAGIOS.tipo_variante
);
GO

CREATE TABLE LOS_MAGIOS.producto(
producto_codigo NVARCHAR(50) PRIMARY KEY,
producto_nombre NVARCHAR(50) NOT NULL,
producto_descripcion NVARCHAR(50) NOT NULL,
producto_material NVARCHAR(50) NOT NULL,
producto_marca NVARCHAR(255) NOT NULL,
categoria_producto_codigo DECIMAL(19,0) REFERENCES LOS_MAGIOS.categoria_producto,
producto_variante_codigo NVARCHAR(50) REFERENCES LOS_MAGIOS.variante
);
GO

CREATE TABLE LOS_MAGIOS.compra_producto(
compra_numero DECIMAL(19,0) REFERENCES LOS_MAGIOS.compra,
producto_codigo NVARCHAR(50) REFERENCES LOS_MAGIOS.producto,
compra_producto_cantidad DECIMAL(18,0) NOT NULL,
compra_producto_precio DECIMAL(18,2) NOT NULL,
PRIMARY KEY(compra_numero, producto_codigo)
);
GO

CREATE TABLE LOS_MAGIOS.venta(
venta_codigo DECIMAL(19,0) PRIMARY KEY,
venta_fecha DATE NOT NULL,
venta_total DECIMAL(18,2) NOT NULL,
cliente_codigo DECIMAL(19,0) REFERENCES LOS_MAGIOS.cliente,
canal_codigo DECIMAL(19,0) REFERENCES LOS_MAGIOS.canal,
medio_pago_codigo DECIMAL(19,0) REFERENCES LOS_MAGIOS.medio_pago,
envio_codigo DECIMAL(19,0) REFERENCES LOS_MAGIOS.envio
);
GO

CREATE TABLE LOS_MAGIOS.tipo_descuento (
tipo_descuento_codigo DECIMAL(19,0) IDENTITY(1,1) PRIMARY KEY,
tipo_descuento_detalle NVARCHAR(255) NOT NULL
);
GO


CREATE TABLE LOS_MAGIOS.venta_descuento(
venta_descuento_codigo DECIMAL(19,0) IDENTITY(1,1) PRIMARY KEY,
venta_descuento_importe DECIMAL(18,2) NOT NULL,
venta_codigo DECIMAL(19,0) REFERENCES LOS_MAGIOS.venta,
tipo_descuento_codigo DECIMAL(19,0) REFERENCES LOS_MAGIOS.tipo_descuento
);
GO

CREATE TABLE LOS_MAGIOS.venta_producto(
producto_codigo NVARCHAR(50) REFERENCES LOS_MAGIOS.producto,
venta_codigo DECIMAL(19,0) REFERENCES LOS_MAGIOS.venta,
venta_producto_cantidad DECIMAL(18,0) NOT NULL,
venta_producto_precio DECIMAL(18,2) NOT NULL,
PRIMARY KEY (producto_codigo, venta_codigo)
);
GO

CREATE TABLE LOS_MAGIOS.cupon(
cupon_codigo NVARCHAR(255) PRIMARY KEY,
cupon_fecha_desde DATE NOT NULL,
cupon_fecha_hasta DATE NOT NULL,
cupon_valor DECIMAL(18,2) NOT NULL,
cupon_tipo NVARCHAR(50) NOT NULL
);

GO

CREATE TABLE LOS_MAGIOS.venta_cupon(
cupon_codigo NVARCHAR(255) REFERENCES LOS_MAGIOS.cupon,
venta_codigo DECIMAL(19,0) REFERENCES LOS_MAGIOS.venta,
venta_cupon_importe DECIMAL(18,2) NOT NULL,
);

GO

-- Funciones ----

CREATE FUNCTION LOS_MAGIOS.obtener_provincia_codigo (@provincia_nombre VARCHAR(255))
RETURNS DECIMAL(19,0)
AS
BEGIN
	DECLARE @codigo_obtenido DECIMAL
	SELECT @codigo_obtenido = lp.provincia_codigo FROM LOS_MAGIOS.provincia lp WHERE lp.provincia_nombre = @provincia_nombre;
	RETURN @codigo_obtenido
END
GO

CREATE FUNCTION LOS_MAGIOS.obtener_localidad_codigo (@localidad_nombre VARCHAR(255), @localidad_codigo_postal DECIMAL(19,0), @provincia_nombre VARCHAR(255))
RETURNS DECIMAL(19,0)
AS
BEGIN
	DECLARE @codigo_obtenido DECIMAL
	SELECT @codigo_obtenido = l.localidad_codigo FROM LOS_MAGIOS.localidad l 
	WHERE l.localidad_nombre = @localidad_nombre 
		AND l.localidad_codigo_postal = @localidad_codigo_postal 
		AND l.provincia_codigo = LOS_MAGIOS.obtener_provincia_codigo(@provincia_nombre)
	RETURN @codigo_obtenido
END
GO

CREATE FUNCTION LOS_MAGIOS.obtener_categoria_codigo (@categoria_producto_tipo VARCHAR(255))
RETURNS DECIMAL(19,0)
AS
BEGIN
	DECLARE @codigo_obtenido DECIMAL
	SELECT @codigo_obtenido = cp.categoria_producto_codigo FROM LOS_MAGIOS.categoria_producto cp WHERE cp.categoria_producto_tipo = @categoria_producto_tipo;
	RETURN @codigo_obtenido
END
GO

CREATE FUNCTION LOS_MAGIOS.obtener_tipo_envio_codigo (@venta_medio_envio VARCHAR(255))
RETURNS DECIMAL(19,0)
AS
BEGIN
	DECLARE @codigo_obtenido DECIMAL
	SELECT @codigo_obtenido = te.tipo_envio_codigo FROM LOS_MAGIOS.tipo_envio te WHERE te.tipo_envio_detalle LIKE @venta_medio_envio;
	RETURN @codigo_obtenido
END
GO

CREATE FUNCTION LOS_MAGIOS.obtener_tipo_medio_pago_codigo (@venta_medio_pago_detalle NVARCHAR(255))
RETURNS DECIMAL(19,0)
AS
BEGIN
	DECLARE @codigo_obtenido DECIMAL
	SELECT @codigo_obtenido = tmp.tipo_medio_pago_codigo FROM LOS_MAGIOS.tipo_medio_pago tmp WHERE tmp.tipo_medio_pago_Detalle LIKE @venta_medio_pago_detalle;
	RETURN @codigo_obtenido
END
GO

CREATE FUNCTION LOS_MAGIOS.obtener_pago_codigo (@medio_pago_costo DECIMAL(18,2), @medio_pago_detalle NVARCHAR(255))
RETURNS DECIMAL(19,0)
AS
BEGIN
	DECLARE @codigo_obtenido DECIMAL
	SELECT @codigo_obtenido = mp.tipo_medio_pago_codigo
	FROM LOS_MAGIOS.medio_pago mp JOIN LOS_MAGIOS.tipo_medio_pago tmp ON mp.tipo_medio_pago_codigo = tmp.tipo_medio_pago_codigo
	WHERE mp.medio_pago_costo = @medio_pago_costo AND tmp.tipo_medio_pago_Detalle = @medio_pago_detalle
	RETURN @codigo_obtenido
END
GO

CREATE FUNCTION LOS_MAGIOS.obtener_tipo_variante_codigo (@tipo_variante_detalle nvarchar(50))
RETURNS DECIMAL(19,0)
AS
BEGIN
    DECLARE @codigo_obtenido DECIMAL
    SELECT @codigo_obtenido = tp.tipo_variante_codigo FROM LOS_MAGIOS.tipo_variante tp WHERE tp.tipo_variante_detalle = @tipo_variante_detalle
    RETURN @codigo_obtenido
END
GO


CREATE FUNCTION LOS_MAGIOS.obtener_medio_pago_codigo (@venta_medio_pago_detalle NVARCHAR(255))
RETURNS DECIMAL(19,0)
AS
BEGIN
    DECLARE @codigo_obtenido DECIMAL
    SELECT @codigo_obtenido = mp.medio_pago_codigo FROM LOS_MAGIOS.medio_pago mp WHERE LOS_MAGIOS.obtener_tipo_medio_pago_codigo(@venta_medio_pago_detalle) = mp.tipo_medio_pago_codigo;
    RETURN @codigo_obtenido
END
GO

CREATE FUNCTION LOS_MAGIOS.obtener_proveedor_codigo (@proveedor_cuit nvarchar(50))
RETURNS DECIMAL(19,0)
AS
BEGIN
    DECLARE @codigo_obtenido DECIMAL
    SELECT @codigo_obtenido = p.proveedor_codigo FROM LOS_MAGIOS.proveedor p WHERE p.proveedor_cuit = @proveedor_cuit
    RETURN @codigo_obtenido
END
GO


--- Procedures ----

CREATE PROCEDURE [LOS_MAGIOS].migrar_pronvincias AS
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

CREATE PROCEDURE [LOS_MAGIOS].migrar_localidades AS
BEGIN
	INSERT INTO LOS_MAGIOS.localidad (localidad_nombre, localidad_codigo_postal, provincia_codigo)
	SELECT DISTINCT m.CLIENTE_LOCALIDAD as localidad_nombre, m.CLIENTE_CODIGO_POSTAL as localidad_codigo_postal, LOS_MAGIOS.obtener_provincia_codigo(m.CLIENTE_PROVINCIA) as provincia_codigo
	FROM gd_esquema.Maestra m 
	WHERE m.CLIENTE_LOCALIDAD IS NOT NULL
	UNION 
	SELECT DISTINCT  m.PROVEEDOR_LOCALIDAD, m.PROVEEDOR_CODIGO_POSTAL, LOS_MAGIOS.obtener_provincia_codigo(m.PROVEEDOR_PROVINCIA) as provincia_codigo
	FROM gd_esquema.Maestra m 
	WHERE m.PROVEEDOR_LOCALIDAD IS NOT NULL 
END
GO

CREATE PROCEDURE [LOS_MAGIOS].migrar_clientes AS
BEGIN
	INSERT INTO LOS_MAGIOS.cliente(cliente_dni,
	cliente_nombre, cliente_apellido, cliente_direccion, cliente_telefono, cliente_mail,
	cliente_fecha_nac, localidad_codigo)
	SELECT DISTINCT CLIENTE_DNI,CLIENTE_NOMBRE ,CLIENTE_APELLIDO, CLIENTE_DIRECCION, CLIENTE_TELEFONO,
	CLIENTE_MAIL, CLIENTE_FECHA_NAC, LOS_MAGIOS.obtener_localidad_codigo(CLIENTE_LOCALIDAD, CLIENTE_CODIGO_POSTAL, CLIENTE_PROVINCIA) FROM gd_esquema.Maestra m
	WHERE CLIENTE_DNI IS NOT NULL
END
GO

CREATE PROCEDURE [LOS_MAGIOS].migrar_proveedores AS
BEGIN
	INSERT INTO LOS_MAGIOS.proveedor (proveedor_cuit, proveedor_domicilio, proveedor_mail, proveedor_razon_social, localidad_codigo)
	SELECT DISTINCT m.PROVEEDOR_CUIT, m.PROVEEDOR_DOMICILIO, m.PROVEEDOR_MAIL, m.PROVEEDOR_RAZON_SOCIAL,
							LOS_MAGIOS.obtener_localidad_codigo(PROVEEDOR_LOCALIDAD, PROVEEDOR_CODIGO_POSTAL, PROVEEDOR_PROVINCIA)
	FROM gd_esquema.Maestra m WHERE m.PROVEEDOR_CUIT IS NOT NULL
END
GO

CREATE PROCEDURE [LOS_MAGIOS].migrar_descuento_compra AS
BEGIN
	INSERT INTO LOS_MAGIOS.descuento_compra (descuento_compra_codigo, descuento_compra_valor)
	SELECT DISTINCT m.DESCUENTO_COMPRA_CODIGO, m.DESCUENTO_COMPRA_VALOR
	FROM gd_esquema.Maestra m WHERE m.DESCUENTO_COMPRA_CODIGO IS NOT NULL AND m.DESCUENTO_COMPRA_VALOR IS NOT NULL
END
GO

CREATE PROCEDURE [LOS_MAGIOS].migrar_categorias_productos AS
BEGIN
	INSERT INTO LOS_MAGIOS.categoria_producto (categoria_producto_tipo)
	SELECT DISTINCT m.PRODUCTO_CATEGORIA 
	FROM gd_esquema.Maestra m WHERE m.PRODUCTO_CATEGORIA IS NOT NULL 
END
GO

CREATE PROCEDURE [LOS_MAGIOS].migrar_tipo_canal AS
BEGIN
    INSERT INTO LOS_MAGIOS.tipo_canal(tipo_canal_detalle)
    SELECT distinct m.VENTA_CANAL 
    FROM gd_esquema.Maestra m 
    WHERE m.VENTA_CANAL IS NOT NULL
END
GO

CREATE PROCEDURE [LOS_MAGIOS].migrar_canal AS
BEGIN
	INSERT INTO LOS_MAGIOS.canal(tipo_canal_codigo, canal_costo)
	SELECT distinct t.tipo_canal_codigo, m.VENTA_CANAL_COSTO
	FROM gd_esquema.Maestra m join LOS_MAGIOS.tipo_canal t on t.tipo_canal_detalle = m.VENTA_CANAL
END
GO

CREATE PROCEDURE [LOS_MAGIOS].migrar_tipo_envio AS
BEGIN
	INSERT INTO LOS_MAGIOS.tipo_envio (tipo_envio_detalle)
	SELECT DISTINCT m.VENTA_MEDIO_ENVIO FROM gd_esquema.Maestra m WHERE m.VENTA_MEDIO_ENVIO IS NOT NULL
END
GO

CREATE PROCEDURE [LOS_MAGIOS].migrar_envio AS
BEGIN
	INSERT INTO LOS_MAGIOS.envio (envio_precio, tipo_envio_codigo)
	SELECT DISTINCT m.VENTA_ENVIO_PRECIO, LOS_MAGIOS.obtener_tipo_envio_codigo(m.VENTA_MEDIO_ENVIO) as tipo_envio_codigo 
	FROM gd_esquema.Maestra m
	WHERE m.VENTA_MEDIO_ENVIO IS NOT NULL
END
GO

--- dudoso. 
CREATE PROCEDURE [LOS_MAGIOS].migrar_tipo_envio_localidad AS
BEGIN
	INSERT INTO LOS_MAGIOS.tipo_envio_localidad (localidad_codigo, tipo_envio_codigo)
	SELECT DISTINCT LOS_MAGIOS.obtener_localidad_codigo(m.CLIENTE_LOCALIDAD, m.CLIENTE_CODIGO_POSTAL, m.CLIENTE_PROVINCIA )as localidad_codigo, LOS_MAGIOS.obtener_tipo_envio_codigo(m.VENTA_MEDIO_ENVIO) as tipo_envio_codigo
	FROM gd_esquema.Maestra m
	WHERE m.CLIENTE_LOCALIDAD IS NOT NULL AND m.VENTA_MEDIO_ENVIO IS NOT NULL
END
GO


CREATE PROCEDURE [LOS_MAGIOS].migrar_tipo_descuento AS
BEGIN
	INSERT INTO LOS_MAGIOS.tipo_descuento (tipo_descuento_detalle)
	SELECT DISTINCT VENTA_DESCUENTO_CONCEPTO FROM gd_esquema.Maestra WHERE VENTA_DESCUENTO_CONCEPTO IS NOT NULL
END
GO


CREATE PROCEDURE [LOS_MAGIOS].migrar_tipo_medio_pago AS
BEGIN 
	INSERT INTO LOS_MAGIOS.tipo_medio_pago(tipo_medio_pago_Detalle)
	SELECT DISTINCT VENTA_MEDIO_PAGO FROM gd_esquema.Maestra WHERE VENTA_MEDIO_PAGO IS NOT NULL
	UNION SELECT DISTINCT COMPRA_MEDIO_PAGO FROM gd_esquema.Maestra WHERE COMPRA_MEDIO_PAGO IS NOT NULL
END
GO



CREATE PROCEDURE [LOS_MAGIOS].migrar_medio_pago AS
BEGIN
	INSERT INTO LOS_MAGIOS.medio_pago (medio_pago_costo, tipo_medio_pago_codigo)
	SELECT DISTINCT m.VENTA_MEDIO_PAGO_COSTO, LOS_MAGIOS.obtener_tipo_medio_pago_codigo(m.VENTA_MEDIO_PAGO) as tipo_medio_pago_codigo
	FROM gd_esquema.Maestra m
	WHERE m.VENTA_MEDIO_PAGO_COSTO IS NOT NULL
	UNION 
	SELECT DISTINCT m.VENTA_MEDIO_PAGO_COSTO, LOS_MAGIOS.obtener_tipo_medio_pago_codigo(m.COMPRA_MEDIO_PAGO) as tipo_medio_pago_codigo 
	FROM gd_esquema.Maestra m
	WHERE m.VENTA_MEDIO_PAGO_COSTO IS NULL

END
GO

CREATE PROCEDURE [LOS_MAGIOS].migrar_tipo_variante AS
BEGIN
    INSERT INTO LOS_MAGIOS.tipo_variante(tipo_variante_detalle) 
    SELECT distinct m.PRODUCTO_TIPO_VARIANTE
    FROM gd_esquema.Maestra m 
    WHERE m.PRODUCTO_TIPO_VARIANTE IS NOT NULL
END
GO

CREATE PROCEDURE [LOS_MAGIOS].migrar_variante AS
BEGIN
    INSERT INTO LOS_MAGIOS.variante (variante_codigo, tipo_variante_codigo,variante_descripcion) 
    SELECT distinct m.PRODUCTO_VARIANTE_CODIGO, LOS_MAGIOS.obtener_tipo_variante_codigo(m.PRODUCTO_TIPO_VARIANTE), m.PRODUCTO_VARIANTE
    FROM gd_esquema.Maestra m 
    WHERE m.PRODUCTO_VARIANTE_CODIGO IS NOT NULL
END
GO

CREATE PROCEDURE [LOS_MAGIOS].migrar_venta AS
BEGIN
	INSERT INTO LOS_MAGIOS.venta (venta_codigo, venta_fecha, venta_total, cliente_codigo, canal_codigo, medio_pago_codigo, envio_codigo)
	SELECT DISTINCT m.VENTA_CODIGO, m.VENTA_FECHA, m.VENTA_TOTAL, c.cliente_codigo, canal.canal_codigo,
		mp.medio_pago_codigo, en.envio_codigo
	FROM gd_esquema.Maestra m JOIN LOS_MAGIOS.cliente c
			ON c.cliente_nombre = m.CLIENTE_NOMBRE AND c.cliente_dni = m.CLIENTE_DNI 
			AND c.cliente_apellido = m.CLIENTE_APELLIDO AND c.cliente_telefono = m.CLIENTE_TELEFONO
		JOIN LOS_MAGIOS.tipo_canal tc ON tc.tipo_canal_detalle = m.VENTA_CANAL
		JOIN LOS_MAGIOS.canal ON canal.canal_codigo = tc.tipo_canal_codigo
		JOIN LOS_MAGIOS.tipo_envio tpe ON tpe.tipo_envio_detalle = m.VENTA_MEDIO_ENVIO
		JOIN LOS_MAGIOS.envio en ON tpe.tipo_envio_codigo = en.tipo_envio_codigo AND en.envio_precio = m.VENTA_ENVIO_PRECIO
		JOIN LOS_MAGIOS.tipo_medio_pago tmp ON tmp.tipo_medio_pago_Detalle = m.VENTA_MEDIO_PAGO
		JOIN LOS_MAGIOS.medio_pago mp ON tmp.tipo_medio_pago_codigo = mp.medio_pago_codigo
	WHERE m.VENTA_CODIGO IS NOT NULL
END
GO	

CREATE PROCEDURE [LOS_MAGIOS].migrar_venta_descuento AS
BEGIN
	INSERT INTO LOS_MAGIOS.venta_descuento (venta_descuento_importe, venta_codigo, tipo_descuento_codigo)
	SELECT DISTINCT m.VENTA_DESCUENTO_IMPORTE, m.venta_codigo,td.tipo_descuento_codigo
	FROM gd_esquema.Maestra m
	JOIN LOS_MAGIOS.tipo_descuento td ON m.VENTA_DESCUENTO_CONCEPTO LIKE td.tipo_descuento_detalle
	WHERE VENTA_CODIGO IS NOT NULL
END
GO

CREATE PROCEDURE [LOS_MAGIOS].migrar_cupones AS 
BEGIN
	INSERT INTO LOS_MAGIOS.cupon (cupon_codigo, cupon_fecha_desde, cupon_fecha_hasta, cupon_tipo, cupon_valor)
	SELECT DISTINCT VENTA_CUPON_CODIGO, VENTA_CUPON_FECHA_DESDE, VENTA_CUPON_FECHA_HASTA, VENTA_CUPON_TIPO, VENTA_CUPON_VALOR FROM gd_esquema.Maestra
	WHERE VENTA_CUPON_CODIGO IS NOT NULL
END
GO

CREATE PROCEDURE [LOS_MAGIOS].migrar_venta_cupon AS
BEGIN
	INSERT INTO LOS_MAGIOS.venta_cupon (cupon_codigo, venta_codigo, venta_cupon_importe)
	SELECT c.cupon_codigo , v.venta_codigo, m.VENTA_CUPON_IMPORTE FROM gd_esquema.Maestra m
	JOIN LOS_MAGIOS.venta v ON v.venta_codigo = m.VENTA_CODIGO
	JOIN LOS_MAGIOS.cupon c ON m.VENTA_CUPON_CODIGO = c.cupon_codigo
	WHERE m.VENTA_CODIGO IS NOT NULL AND m.VENTA_CUPON_CODIGO IS NOT NULL
END
GO

CREATE PROCEDURE [LOS_MAGIOS].migrar_producto AS
BEGIN
    INSERT INTO LOS_MAGIOS.producto(producto_codigo, categoria_producto_codigo, producto_descripcion, producto_marca, producto_material, 
        producto_nombre, producto_variante_codigo) 
    SELECT distinct m.PRODUCTO_CODIGO, LOS_MAGIOS.obtener_categoria_codigo(m.PRODUCTO_CATEGORIA) , m.PRODUCTO_DESCRIPCION, m.PRODUCTO_MARCA, m.PRODUCTO_MATERIAL, m.PRODUCTO_NOMBRE, m.PRODUCTO_VARIANTE_CODIGO
    FROM gd_esquema.Maestra m 
    WHERE m.PRODUCTO_CODIGO IS NOT NULL
END
GO

CREATE PROCEDURE [LOS_MAGIOS].migrar_venta_producto AS
BEGIN
	INSERT INTO LOS_MAGIOS.venta_producto (producto_codigo, venta_codigo, venta_producto_cantidad, venta_producto_precio)
	SELECT DISTINCT p.producto_codigo, v.venta_codigo ,SUM(m.VENTA_PRODUCTO_CANTIDAD) as venta_producto_cantidad, SUM(m.VENTA_PRODUCTO_PRECIO) as venta_producto_precio FROM gd_esquema.Maestra m
	JOIN LOS_MAGIOS.producto p ON m.PRODUCTO_CODIGO = p.producto_codigo
	JOIN LOS_MAGIOS.venta v ON m.VENTA_CODIGO = v.venta_codigo
	WHERE m.VENTA_CODIGO IS NOT NULL AND m.PRODUCTO_CODIGO IS NOT NULL AND m.VENTA_PRODUCTO_PRECIO IS NOT NULL AND m.VENTA_PRODUCTO_CANTIDAD IS NOT NULL
	GROUP BY p.producto_codigo, v.venta_codigo
END
GO

--mirar
CREATE PROCEDURE [LOS_MAGIOS].migrar_compra AS
BEGIN
    INSERT INTO LOS_MAGIOS.compra(compra_numero, compra_fecha, compra_total, descuento_compra_codigo, medio_pago_codigo, proveedor_codigo)
    SELECT distinct m.COMPRA_NUMERO, m.COMPRA_FECHA, m.COMPRA_TOTAL, m.DESCUENTO_COMPRA_CODIGO, 
    LOS_MAGIOS.obtener_medio_pago_codigo(m.COMPRA_MEDIO_PAGO), LOS_MAGIOS.obtener_proveedor_codigo(m.PROVEEDOR_CUIT)
    FROM gd_esquema.Maestra m 
    WHERE m.COMPRA_NUMERO is not null and m.DESCUENTO_COMPRA_CODIGO is not null
END
GO

CREATE PROCEDURE [LOS_MAGIOS].migrar_compra_producto AS
BEGIN
	INSERT INTO LOS_MAGIOS.compra_producto (compra_numero, producto_codigo, compra_producto_cantidad, compra_producto_precio)
	SELECT DISTINCT c.compra_numero, p.producto_codigo , SUM(m.COMPRA_PRODUCTO_CANTIDAD) as compra_producto_cantidad, SUM(m.COMPRA_PRODUCTO_PRECIO) as compra_producto_precio
	FROM gd_esquema.Maestra m
	JOIN LOS_MAGIOS.producto p ON m.PRODUCTO_CODIGO LIKE p.producto_codigo
	JOIN LOS_MAGIOS.compra c ON m.COMPRA_NUMERO = c.compra_numero
	GROUP BY c.compra_numero, p.producto_codigo
END
GO
-- Migracion

EXECUTE LOS_MAGIOS.migrar_pronvincias
EXECUTE LOS_MAGIOS.migrar_localidades
EXECUTE LOS_MAGIOS.migrar_clientes
EXECUTE LOS_MAGIOS.migrar_proveedores
EXECUTE LOS_MAGIOS.migrar_descuento_compra
EXECUTE LOS_MAGIOS.migrar_categorias_productos
EXECUTE LOS_MAGIOS.migrar_tipo_envio
EXECUTE LOS_MAGIOS.migrar_envio 
EXECUTE LOS_MAGIOS.migrar_tipo_envio_localidad
EXECUTE LOS_MAGIOS.migrar_tipo_descuento
EXECUTE LOS_MAGIOS.migrar_tipo_medio_pago
EXECUTE LOS_MAGIOS.migrar_medio_pago

EXECUTE LOS_MAGIOS.migrar_variante


EXECUTE LOS_MAGIOS.migrar_tipo_canal
EXECUTE LOS_MAGIOS.migrar_canal
EXECUTE LOS_MAGIOS.migrar_tipo_variante
EXECUTE LOS_MAGIOS.migrar_venta

EXECUTE LOS_MAGIOS.migrar_cupones
EXECUTE LOS_MAGIOS.migrar_venta_cupon
EXECUTE LOS_MAGIOS.migrar_venta_descuento
EXECUTE LOS_MAGIOS.migrar_producto
EXECUTE LOS_MAGIOS.migrar_venta_producto
EXECUTE LOS_MAGIOS.migrar_compra
EXECUTE LOS_MAGIOS.migrar_compra_producto
GO

-- Eliminaciones para despues correr el test

DROP FUNCTION LOS_MAGIOS.obtener_provincia_codigo
DROP FUNCTION LOS_MAGIOS.obtener_localidad_codigo
DROP FUNCTION LOS_MAGIOS.obtener_categoria_codigo
DROP FUNCTION LOS_MAGIOS.obtener_tipo_envio_codigo
DROP FUNCTION LOS_MAGIOS.obtener_tipo_medio_pago_codigo
DROP FUNCTION LOS_MAGIOS.obtener_pago_codigo
DROP FUNCTION LOS_MAGIOS.obtener_tipo_variante_codigo
DROP FUNCTION LOS_MAGIOS.obtener_proveedor_codigo
DROP FUNCTION LOS_MAGIOS.obtener_medio_pago_codigo

DROP PROCEDURE [LOS_MAGIOS].migrar_proveedores
DROP PROCEDURE [LOS_MAGIOS].migrar_pronvincias
DROP PROCEDURE [LOS_MAGIOS].migrar_localidades
DROP PROCEDURE [LOS_MAGIOS].migrar_clientes
DROP PROCEDURE [LOS_MAGIOS].migrar_descuento_compra
DROP PROCEDURE [LOS_MAGIOS].migrar_categorias_productos
DROP PROCEDURE [LOS_MAGIOS].migrar_tipo_envio
DROP PROCEDURE [LOS_MAGIOS].migrar_envio 
DROP PROCEDURE [LOS_MAGIOS].migrar_tipo_envio_localidad
DROP PROCEDURE [LOS_MAGIOS].migrar_tipo_descuento
DROP PROCEDURE [LOS_MAGIOS].migrar_tipo_medio_pago
DROP PROCEDURE [LOS_MAGIOS].migrar_medio_pago
DROP PROCEDURE [LOS_MAGIOS].migrar_venta
DROP PROCEDURE [LOS_MAGIOS].migrar_venta_descuento

DROP PROCEDURE [LOS_MAGIOS].migrar_venta_cupon
DROP PROCEDURE [LOS_MAGIOS].migrar_variante

DROP PROCEDURE [LOS_MAGIOS].migrar_tipo_canal
DROP PROCEDURE [LOS_MAGIOS].migrar_canal
DROP PROCEDURE [LOS_MAGIOS].migrar_tipo_variante
DROP PROCEDURE [LOS_MAGIOS].migrar_cupones
DROP PROCEDURE [LOS_MAGIOS].migrar_compra
DROP PROCEDURE [LOS_MAGIOS].migrar_producto
DROP PROCEDURE [LOS_MAGIOS].migrar_venta_producto
DROP PROCEDURE [LOS_MAGIOS].migrar_compra_producto

GO