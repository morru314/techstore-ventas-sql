-- Motor utilizado: SQL Server (T-SQL). Probado en SQL Server 2025 Express (localhost\SQLEXPRESS) el 29/10/2026
-- =====================================================================
-- Pre-entrega 4 - Consultas SQL de negocio
-- Base: Ventas_Tech_DB (la del módulo 3) | Tabla usada: ventas
-- Alumno: Alejandro Palahi
-- =====================================================================

-- Me paro en la base del proyecto (no uso la master)
USE Ventas_Tech_DB;
GO

-- ---------------------------------------------------------------------
-- CONSULTA 1 - Resumen ejecutivo mensual
-- Qué es: por cada mes, cuánto se facturó, cuántos pedidos hubo y el
--         ticket promedio.
-- Para qué: tener la foto rápida de cómo viene el negocio mes a mes.
-- Total facturado = cantidad * precio_unitario (cada fila es un pedido).
-- ---------------------------------------------------------------------
SELECT
    MONTH(fecha_venta)                        AS mes,
    SUM(cantidad * precio_unitario)           AS total_facturado,
    COUNT(*)                                  AS cantidad_pedidos,
    AVG(cantidad * precio_unitario)           AS ticket_promedio
FROM ventas
GROUP BY MONTH(fecha_venta)
ORDER BY mes;

-- ---------------------------------------------------------------------
-- CONSULTA 2 - Top 5 productos por facturación
-- Qué es: los 5 id_producto que más plata generaron, con las unidades
--         vendidas y el total facturado.
-- Para qué: saber en qué productos se apoya la facturación.
-- ---------------------------------------------------------------------
SELECT TOP 5
    id_producto,
    SUM(cantidad)                             AS unidades_vendidas,
    SUM(cantidad * precio_unitario)           AS total_facturado
FROM ventas
GROUP BY id_producto
ORDER BY total_facturado DESC;

-- ---------------------------------------------------------------------
-- CONSULTA 3 - Clientes recurrentes
-- Qué es: los id_cliente que compraron más de una vez, con la cantidad
--         de pedidos y lo que gastaron en total.
-- Para qué: identificar a los clientes que vuelven a comprar (fidelización).
-- Uso HAVING porque la condición es sobre un agregado (COUNT).
-- ---------------------------------------------------------------------
SELECT
    id_cliente,
    COUNT(*)                                  AS cantidad_pedidos,
    SUM(cantidad * precio_unitario)           AS total_gastado
FROM ventas
GROUP BY id_cliente
HAVING COUNT(*) > 1
ORDER BY total_gastado DESC;

-- ---------------------------------------------------------------------
-- CONSULTA 4 - Facturación mensual vs. promedio mensual general
-- Qué es: el total facturado de cada mes y una etiqueta con CASE WHEN que
--         dice si ese mes está 'Por encima' o 'Por debajo' del promedio
--         mensual general (promedio de los totales de todos los meses).
-- Para qué: detectar rápido qué meses rinden más o menos que lo normal.
-- Nota: agregué un tercer caso ('En el promedio') por si un mes da
--       exactamente igual al promedio; con un solo mes de datos pasa eso.
-- ---------------------------------------------------------------------
WITH facturacion_mensual AS (
    SELECT
        MONTH(fecha_venta)              AS mes,
        SUM(cantidad * precio_unitario) AS total_facturado
    FROM ventas
    GROUP BY MONTH(fecha_venta)
)
SELECT
    mes,
    total_facturado,
    CASE
        WHEN total_facturado > (SELECT AVG(total_facturado) FROM facturacion_mensual)
            THEN 'Por encima'
        WHEN total_facturado < (SELECT AVG(total_facturado) FROM facturacion_mensual)
            THEN 'Por debajo'
        ELSE 'En el promedio'
    END                                 AS comparacion_con_promedio
FROM facturacion_mensual
ORDER BY mes;
GO

-- ---------------------------------------------------------------------
-- HALLAZGOS
-- 1) Toda la facturación está concentrada en un solo mes: las 10 ventas son
--    de marzo de 2024 y suman $6.444,00 (10 pedidos, ticket promedio de
--    $644,40). Con un solo mes no se puede ver tendencia ni estacionalidad,
--    y por eso en la consulta 4 marzo da igual al promedio ('En el promedio').
-- 2) La Laptop Pro 15 (id_producto 1) es la que sostiene el negocio: factura
--    $3.600,00, o sea cerca del 56% del total, con apenas 3 unidades. Le sigue
--    el Monitor 4K 27 (id 3) con $1.350,00. El Mouse Inalámbrico (id 2) es el
--    de más rotación en unidades (13) pero solo llega a $364,00, y los
--    Auriculares BT Pro (id 4, $360,00) quedan afuera del Top 5 por muy poco.
-- 3) Los 5 clientes compraron más de una vez, así que la base entera es
--    "recurrente" (en este período). Los que más gastaron son María López
--    (id 1, $2.640,00) y Laura Torres (id 5, $2.100,00), que juntos
--    representan cerca del 74% de lo facturado: conviene cuidarlos con
--    acciones de fidelización.
-- ---------------------------------------------------------------------
