-- Motor utilizado: SQL Server (T-SQL). Probado en SQL Server 2025 Express (localhost\SQLEXPRESS) el 29/10/2026
-- =====================================================================
-- Pre-entrega 5 - Consultas con JOINs para el proyecto
-- Base: Ventas_Tech_DB (la de los módulos 3 y 4)
-- Alumno: Alejandro Palahi
-- =====================================================================

-- Me paro en la base del proyecto (no uso la master)
USE Ventas_Tech_DB;
GO

-- ---------------------------------------------------------------------
-- CONSULTA 1 - Vista base de ventas (INNER JOIN)
-- Qué es: junta ventas + clientes + productos + categorias en una sola
--         vista con fecha, cliente, producto, cantidad, precio unitario y
--         total de la venta. Sumé columnas descriptivas que ya existen en
--         mi esquema: la categoría (con su descripción) y la ciudad del
--         cliente, que uso como dimensión geográfica. Como ya tengo
--         categoría y ciudad, no hizo falta agregar tablas nuevas al
--         script del módulo 3.
-- Para qué: va a ser la fuente principal para armar el dashboard en Power BI.
-- ---------------------------------------------------------------------
CREATE OR ALTER VIEW vw_ventas_detalle AS
SELECT
    v.id_venta,
    v.fecha_venta                            AS fecha,
    c.nombre                                 AS cliente,
    c.ciudad                                 AS ciudad_cliente,
    p.nombre_producto                        AS producto,
    cat.nombre_categoria                     AS categoria,
    cat.descripcion                          AS descripcion_categoria,
    v.cantidad,
    v.precio_unitario,
    v.cantidad * v.precio_unitario           AS total_venta
FROM ventas v
INNER JOIN clientes   c   ON v.id_cliente   = c.id_cliente
INNER JOIN productos  p   ON v.id_producto  = p.id_producto
INNER JOIN categorias cat ON p.id_categoria = cat.id_categoria;
GO

SELECT *
FROM vw_ventas_detalle
ORDER BY fecha, id_venta;
GO
-- Hallazgo: salen las 10 ventas, ninguna se perdió por el INNER JOIN (integridad OK);
-- el total de la vista suma $6.444,00.

-- ---------------------------------------------------------------------
-- CONSULTA 2 - Clientes sin ventas (LEFT JOIN ... IS NULL)
-- Qué es: los clientes registrados que nunca compraron.
-- Para qué: armar una lista para CRM (campañas de primera compra).
-- Los traigo todos con LEFT JOIN y me quedo con los que no tienen match.
-- ---------------------------------------------------------------------
SELECT
    c.nombre,
    c.email,
    c.fecha_registro
FROM clientes c
LEFT JOIN ventas v ON c.id_cliente = v.id_cliente
WHERE v.id_venta IS NULL;
GO
-- Hallazgo: 0 registros. Los 5 clientes compraron al menos una vez, así que CRM
-- no tiene clientes "dormidos" para reactivar; el foco es fidelizar y captar nuevos.

-- ---------------------------------------------------------------------
-- CONSULTA 3 - Productos sin ventas (LEFT JOIN ... IS NULL)
-- Qué es: los productos del catálogo que nunca se vendieron.
-- Para qué: que el área de Producto vea qué hay que revisar (precio,
--           stock o si conviene sacarlo del catálogo).
-- ---------------------------------------------------------------------
SELECT
    p.nombre_producto,
    cat.nombre_categoria                     AS categoria,
    p.precio
FROM productos p
LEFT JOIN ventas v      ON p.id_producto  = v.id_producto
LEFT JOIN categorias cat ON p.id_categoria = cat.id_categoria
WHERE v.id_venta IS NULL;
GO
-- Hallazgo: 0 registros. Los 6 productos se vendieron al menos una vez, así que
-- Producto no tiene stock "muerto" para liquidar (ojo: son solo 10 ventas de marzo 2024).

-- ---------------------------------------------------------------------
-- CONSULTA 4 - Consolidado por canal (UNION ALL)
-- Qué es: dos SELECT sobre ventas que le agregan una columna literal
--         'canal' (no existe en la tabla, la creo en la consulta) y los
--         uno con UNION ALL. Después agrupo por canal para ver cuántas
--         ventas, unidades y facturación tiene cada uno.
-- Supuesto: el esquema no tiene canal de venta, así que lo armo de forma
--           simulada con la cantidad por venta: 3 unidades o más =
--           'Mayorista' y menos de 3 = 'Minorista'.
-- Para qué: comparar el peso de cada canal en la facturación.
-- Los dos SELECT tienen las mismas columnas y los mismos tipos.
-- ---------------------------------------------------------------------
SELECT
    canal,
    COUNT(*)                                 AS cantidad_ventas,
    SUM(cantidad)                            AS unidades_vendidas,
    SUM(total_venta)                         AS total_facturado
FROM (
    SELECT
        'Mayorista'                          AS canal,
        id_venta,
        cantidad,
        cantidad * precio_unitario           AS total_venta
    FROM ventas
    WHERE cantidad >= 3

    UNION ALL

    SELECT
        'Minorista'                          AS canal,
        id_venta,
        cantidad,
        cantidad * precio_unitario           AS total_venta
    FROM ventas
    WHERE cantidad < 3
) AS ventas_por_canal
GROUP BY canal
ORDER BY total_facturado DESC;
GO
-- Hallazgo: el canal Minorista (menos de 3 unidades) factura $5.310,00 en 6 ventas
-- y el Mayorista $1.134,00 en 4 (aunque mueve más unidades: 20 vs 9). Ojo: canal simulado.

-- =====================================================================
-- BLOQUE APARTE - DATOS DE PRUEBA para C2 y C3
-- Las consultas de arriba quedan tal cual. Con los 25 registros de la PE3
-- todos los clientes y productos tienen ventas, así que C2 y C3 dan 0 filas.
-- Para mostrar que el LEFT JOIN ... IS NULL funciona, cargo 2 clientes y
-- 2 productos DE PRUEBA, sin ventas, marcados como "(PRUEBA)".
-- No toca el script de la PE3. Se puede correr varias veces (borra y recarga).
-- =====================================================================
DELETE FROM clientes  WHERE id_cliente  IN (901, 902);
DELETE FROM productos WHERE id_producto IN (901, 902);
GO
INSERT INTO clientes (id_cliente, nombre, email, ciudad, fecha_registro) VALUES
    (901, N'Cliente Prueba Uno (PRUEBA)', 'prueba1@mail.com', N'Salta',   '2024-03-20'),
    (902, N'Cliente Prueba Dos (PRUEBA)', 'prueba2@mail.com', N'Neuquén', '2024-03-25');
INSERT INTO productos (id_producto, nombre_producto, id_categoria, precio, stock, activo) VALUES
    (901, N'Webcam HD (PRUEBA)',      2,  75.00, 10, 1),
    (902, N'Parlante Mini (PRUEBA)',  3,  45.00, 20, 1);
GO

-- C2 con datos de prueba: clientes sin ventas
SELECT
    c.nombre,
    c.email,
    c.fecha_registro
FROM clientes c
LEFT JOIN ventas v ON c.id_cliente = v.id_cliente
WHERE v.id_venta IS NULL;
GO
-- Hallazgo (prueba): aparecen los 2 clientes de prueba y ninguno de los 5 reales.
-- La consulta detecta bien a quien se registró y no compró: esa lista va a CRM para primera compra.

-- C3 con datos de prueba: productos sin ventas
SELECT
    p.nombre_producto,
    cat.nombre_categoria                     AS categoria,
    p.precio
FROM productos p
LEFT JOIN ventas v      ON p.id_producto  = v.id_producto
LEFT JOIN categorias cat ON p.id_categoria = cat.id_categoria
WHERE v.id_venta IS NULL;
GO
-- Hallazgo (prueba): aparecen los 2 productos de prueba (Accesorios y Audio).
-- Con datos reales, esta lista le dice a Producto qué revisar (precio, stock o sacarlo del catálogo).
