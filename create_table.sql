-- =====================================================================
-- Script DDL para la Creación del Esquema de Estrella en Amazon Redshift
-- Proyecto: TAREA 3 - INTELIGENCIA DE NEGOCIOS
-- Autor: Julio Arevalo
-- =====================================================================

-- --- 1. Creación de las Tablas de Dimensión ---

-- Se eliminan las tablas si ya existen para permitir una re-ejecución limpia del script.
-- El orden es inverso a la creación y dependencias.
DROP TABLE IF EXISTS fact_sales;
DROP TABLE IF EXISTS dim_date;
DROP TABLE IF EXISTS dim_orders;
DROP TABLE IF EXISTS dim_sellers;
DROP TABLE IF EXISTS dim_products;
DROP TABLE IF EXISTS dim_customers;


-- Dimensión de Clientes
CREATE TABLE dim_customers (
    customer_key BIGINT PRIMARY KEY,
    customer_id_original VARCHAR(255),
    customer_unique_id VARCHAR(255),
    customer_city VARCHAR(255),
    customer_state VARCHAR(5)
);

-- Dimensión de Productos
CREATE TABLE dim_products (
    product_key BIGINT PRIMARY KEY,
    product_id_original VARCHAR(255),
    product_category_name_english VARCHAR(255)
    -- Se omiten las columnas de tamaño/peso para este modelo,
    -- pero podrían añadirse si fueran necesarias para el análisis.
);

-- Dimensión de Vendedores
CREATE TABLE dim_sellers (
    seller_key BIGINT PRIMARY KEY,
    seller_id_original VARCHAR(255),
    seller_city VARCHAR(255),
    seller_state VARCHAR(5)
);

-- Dimensión de Órdenes
CREATE TABLE dim_orders (
    order_key BIGINT PRIMARY KEY,
    order_id_original VARCHAR(255),
    order_status VARCHAR(50)
);

-- Dimensión de Tiempo (Calendario)
CREATE TABLE dim_date (
    date_key INTEGER PRIMARY KEY,
    full_date DATE,
    year INTEGER,
    month INTEGER,
    day INTEGER,
    quarter INTEGER,
    month_name VARCHAR(20),
    day_name VARCHAR(20),
    day_of_week INTEGER,
    is_weekend INTEGER
);


-- --- 2. Creación de la Tabla de Hechos ---

CREATE TABLE fact_sales (
    sales_key BIGINT PRIMARY KEY,
    order_key BIGINT REFERENCES dim_orders(order_key),
    customer_key BIGINT REFERENCES dim_customers(customer_key),
    product_key BIGINT REFERENCES dim_products(product_key),
    seller_key BIGINT REFERENCES dim_sellers(seller_key),
    purchase_date_key INTEGER REFERENCES dim_date(date_key),
    -- delivered_date_key INTEGER REFERENCES dim_date(date_key), -- Se puede añadir si se calcula
    price DECIMAL(10, 2),
    freight_value DECIMAL(10, 2),
    order_item_id INTEGER
);