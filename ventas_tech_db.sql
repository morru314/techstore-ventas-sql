-- Motor utilizado: SQL Server (T-SQL). Probado en SQL Server 2025 Express (localhost\SQLEXPRESS) el 29/10/2026
-- =====================================================================
-- Pre-entrega 3 - Esquema normalizado y datos iniciales
-- Caso: TechStore | Base de datos: Ventas_Tech_DB | Modelo en 3FN
-- Alumno: Alejandro Palahi
-- =====================================================================

-- ---------------------------------------------------------------------
-- 0. PREPARACIÓN: creo la base (si no existe) y me paro en ella.
--    Así no trabajo en la master y puedo correr el script las veces que quiera.
-- ---------------------------------------------------------------------
IF DB_ID('Ventas_Tech_DB') IS NULL
    CREATE DATABASE Ventas_Tech_DB;
GO

USE Ventas_Tech_DB;
GO

-- ---------------------------------------------------------------------
-- 1. DROP TABLES
--    Las borro en orden inverso a las dependencias: primero la que tiene
--    más FK (ventas) y al final las que no dependen de nadie (categorias).
--    Con esto el script es repetible.
-- ---------------------------------------------------------------------
DROP TABLE IF EXISTS ventas;
DROP TABLE IF EXISTS productos;
DROP TABLE IF EXISTS clientes;
DROP TABLE IF EXISTS categorias;
GO

-- ---------------------------------------------------------------------
-- 2. CREATE TABLES
--    Orden: primero las tablas "padre" y después las que tienen FK.
--    Uso DECIMAL(10,2) para plata (nunca FLOAT) y BIT para el flag activo.
-- ---------------------------------------------------------------------

-- 2.1 categorias (no depende de nadie)
CREATE TABLE categorias (
    id_categoria     INT          NOT NULL,
    nombre_categoria VARCHAR(50)  NOT NULL,
    descripcion      VARCHAR(200) NULL,
    CONSTRAINT PK_categorias PRIMARY KEY (id_categoria)
);

-- 2.2 clientes (no depende de nadie; el email no se puede repetir)
CREATE TABLE clientes (
    id_cliente     INT          NOT NULL,
    nombre         VARCHAR(100) NOT NULL,
    email          VARCHAR(100) NULL,
    ciudad         VARCHAR(50)  NULL,
    fecha_registro DATE         NOT NULL,
    CONSTRAINT PK_clientes PRIMARY KEY (id_cliente),
    CONSTRAINT UQ_clientes_email UNIQUE (email)
);

-- 2.3 productos (depende de categorias)
CREATE TABLE productos (
    id_producto     INT           NOT NULL,
    nombre_producto VARCHAR(100)  NOT NULL,
    id_categoria    INT           NULL,
    precio          DECIMAL(10,2) NOT NULL,
    stock           INT           NULL CONSTRAINT DF_productos_stock DEFAULT 0,
    activo          BIT           NULL CONSTRAINT DF_productos_activo DEFAULT 1,
    CONSTRAINT PK_productos PRIMARY KEY (id_producto),
    CONSTRAINT FK_productos_categorias FOREIGN KEY (id_categoria)
        REFERENCES categorias (id_categoria)
);

-- 2.4 ventas (depende de clientes y de productos)
CREATE TABLE ventas (
    id_venta        INT           NOT NULL,
    id_cliente      INT           NULL,
    id_producto     INT           NULL,
    cantidad        INT           NOT NULL,
    precio_unitario DECIMAL(10,2) NOT NULL,
    fecha_venta     DATE          NOT NULL,
    CONSTRAINT PK_ventas PRIMARY KEY (id_venta),
    CONSTRAINT FK_ventas_clientes  FOREIGN KEY (id_cliente)
        REFERENCES clientes (id_cliente),
    CONSTRAINT FK_ventas_productos FOREIGN KEY (id_producto)
        REFERENCES productos (id_producto)
);
GO

-- ---------------------------------------------------------------------
-- 3. INSERT (25 registros: 4 categorías, 5 clientes, 6 productos, 10 ventas)
--    Respeto el orden de carga por las FK: categorias -> clientes ->
--    productos -> ventas. Pongo las columnas de forma explícita.
-- ---------------------------------------------------------------------

-- 3.1 categorias (4)
INSERT INTO categorias (id_categoria, nombre_categoria, descripcion) VALUES
  (1, N'Computación',    N'Laptops, PCs y monitores'),
  (2, N'Accesorios',     N'Periféricos y complementos'),
  (3, N'Audio',          N'Auriculares y parlantes'),
  (4, N'Almacenamiento', N'Discos y memorias');

-- 3.2 clientes (5)
INSERT INTO clientes (id_cliente, nombre, email, ciudad, fecha_registro) VALUES
  (1, N'María López',  'maria@mail.com',  N'Buenos Aires', '2024-01-05'),
  (2, N'Carlos Ruiz',  'carlos@mail.com', N'Córdoba',      '2024-01-10'),
  (3, N'Ana Gómez',    'ana@mail.com',    N'Rosario',      '2024-02-01'),
  (4, N'Pedro Sanz',   'pedro@mail.com',  N'Mendoza',      '2024-02-15'),
  (5, N'Laura Torres', 'laura@mail.com',  N'Tucumán',      '2024-03-01');

-- 3.3 productos (6)
INSERT INTO productos (id_producto, nombre_producto, id_categoria, precio, stock, activo) VALUES
  (1, N'Laptop Pro 15',      1, 1200.00, 15, 1),
  (2, N'Mouse Inalámbrico',  2,   28.00, 80, 1),
  (3, N'Monitor 4K 27',      1,  450.00, 12, 1),
  (4, N'Auriculares BT Pro', 3,  120.00, 35, 1),
  (5, N'SSD Externo 1TB',    4,  130.00, 18, 1),
  (6, N'Teclado Mecánico',   2,   95.00, 40, 1);

-- 3.4 ventas (10)
INSERT INTO ventas (id_venta, id_cliente, id_producto, cantidad, precio_unitario, fecha_venta) VALUES
  ( 1, 1, 1, 2, 1200.00, '2024-03-05'),
  ( 2, 2, 2, 5,   28.00, '2024-03-06'),
  ( 3, 3, 3, 1,  450.00, '2024-03-07'),
  ( 4, 1, 4, 2,  120.00, '2024-03-08'),
  ( 5, 4, 5, 3,  130.00, '2024-03-10'),
  ( 6, 2, 6, 4,   95.00, '2024-03-11'),
  ( 7, 5, 1, 1, 1200.00, '2024-03-12'),
  ( 8, 3, 2, 8,   28.00, '2024-03-13'),
  ( 9, 4, 4, 1,  120.00, '2024-03-14'),
  (10, 5, 3, 2,  450.00, '2024-03-15');
GO

-- ---------------------------------------------------------------------
-- 4. VALIDACIÓN
--    Un SELECT por tabla para chequear que se cargó todo.
-- ---------------------------------------------------------------------
SELECT * FROM categorias;   -- esperado: 4 filas
SELECT * FROM clientes;     -- esperado: 5 filas
SELECT * FROM productos;    -- esperado: 6 filas
SELECT * FROM ventas;       -- esperado: 10 filas
GO
