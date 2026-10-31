# techstore-ventas-sql

Repo del curso **Data Analytics de Coderhouse** (comisión 94870). Alumno: Alejandro Palahi.

Proyecto: base de ventas de **TechStore / RetailPro**, una distribuidora de tecnología. La base `Ventas_Tech_DB` está en SQL Server, normalizada en 3FN, y después la llevé a Power BI.

## La base

| Tabla | Qué guarda |
|---|---|
| `categorias` | Categorías de producto. |
| `clientes` | Clientes, con ciudad. |
| `productos` | Catálogo, cada producto con su categoría. |
| `ventas` | Una fila por venta: cliente, producto, cantidad, precio y fecha. |

## Qué hay en el repo

```text
techstore-ventas-sql/
├── ventas_tech_db.sql
├── m4_consultas_negocio.sql
├── m5_consultas_joins.sql
├── modulo-06/Pipeline_ETL_Palahi_Alejandro.pbix
├── modulo-08/Palahi_Alejandro_Checkpoint2.pbix
├── modulo-10/pe10_validacion_estadistica.sql
└── README.md
```

| Archivo | Entrega | Qué hace |
|---|---|---|
| `ventas_tech_db.sql` | Pre-entrega 3 | Crea las 4 tablas con PK, FK, UNIQUE y DEFAULT, carga los 25 registros y valida con 4 SELECT. Se puede correr varias veces. |
| `m4_consultas_negocio.sql` | Pre-entrega 4 | Facturación por mes, top 5 productos, clientes con más de un pedido y cada producto contra el promedio por producto (CASE WHEN). |
| `m5_consultas_joins.sql` | Pre-entrega 5 | Vista base con INNER JOIN, clientes y productos sin ventas (LEFT JOIN + IS NULL) y comparación de canales con UNION ALL. |
| `modulo-06/...pbix` | Pre-entrega 6 | Pipeline ETL en Power Query (4 tablas limpias). |
| `modulo-08/...pbix` | Pre-entrega 8 | Modelo estrella con Dim_Fechas, tabla _Medidas y las medidas DAX. |
| `modulo-10/...sql` | Pre-entrega 10 | Media, desvío, cuartiles e IQR para encontrar outliers. |

## Herramientas

SQL Server Express, SSMS, Power BI Desktop y GitHub.
