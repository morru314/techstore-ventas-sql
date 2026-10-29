# techstore-ventas-sql

Repo del curso **Data Analytics de Coderhouse** (comisión 94870). Alumno: Alejandro Palahi.

Proyecto: base de ventas de **TechStore / RetailPro** (distribuidora de tecnología) en SQL Server y su modelo en Power BI.

## Qué hay

| Archivo | Entrega | Qué hace |
|---|---|---|
| `ventas_tech_db.sql` | Pre-entrega 3 | Crea la base `Ventas_Tech_DB` (categorias, clientes, productos, ventas) con PK, FK, UNIQUE y DEFAULT, carga los 25 registros y valida con 4 SELECT. Se puede correr varias veces. |
| `m4_consultas_negocio.sql` | Pre-entrega 4 | 4 consultas de negocio (facturación por mes, top 5 productos, clientes con más de un pedido, mes vs promedio) y hallazgos. |
| `m5_consultas_joins.sql` | Pre-entrega 5 | Vista con INNER JOIN, clientes y productos sin ventas (LEFT JOIN + IS NULL) y comparación de canales con UNION ALL. |
| `modulo-06/Pipeline_ETL_Palahi_Alejandro.pbix` | Pre-entrega 6 | Pipeline ETL en Power Query (4 tablas limpias: 11 / 12 / 50 / 4 filas). |
| `modulo-08/Palahi_Alejandro_Checkpoint2.pbix` | Pre-entrega 8 | Modelo estrella con Dim_Fechas, tabla _Medidas y las 5 medidas DAX, más la página Validación. |
| `modulo-10/pe10_validacion_estadistica.sql` | Pre-entrega 10 | Medidas de tendencia y dispersión, cuartiles e IQR para encontrar outliers. |

## Cómo correrlo

1. SQL Server Express (`localhost\SQLEXPRESS`) + SSMS.
2. Abrir y ejecutar (F5) en este orden: `ventas_tech_db.sql`, `m4_consultas_negocio.sql`, `m5_consultas_joins.sql`.
3. Los `.pbix` se abren con Power BI Desktop. El de la PE6 lee el Excel desde `C:\Users\Alejandro\CoderHouse\PE6\Pipeline_ETL_Dataset.xlsx`; si lo abrís en otra PC, cambiá la ruta en el paso `Origen` de cada consulta.

Todo probado en SQL Server 2025 Express y Power BI Desktop (octubre 2026).
