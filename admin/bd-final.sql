CREATE DATABASE almacen;
USE almacen;

CREATE TABLE productos (
    id_product INT AUTO_INCREMENT PRIMARY KEY,  -- Уникальный идентификатор продукта
    p_nombre VARCHAR(255) NOT NULL,             -- Название продукта
    p_descripcion VARCHAR(255),                 -- Описание продукта
    p_ancho DECIMAL(10, 2) NOT NULL,            -- Ширина продукта
    p_longitud DECIMAL(10, 2) NOT NULL,         -- Длина продукта
    p_altura DECIMAL(10, 2) NOT NULL,           -- Высота продукта
    p_peso DECIMAL(10, 2) NOT NULL,             -- Вес продукта
    p_foto VARCHAR(255),                        -- Ссылка на фото продукта (или путь к файлу)
    p_cantidad_almacen INT NOT NULL,            -- Количество продукта на складе
    p_cantidad_entrega INT NOT NULL,            -- Количество продукта в пути
    p_cantidad_reservado INT NOT NULL,          -- Количество продукта зарезервировано
    p_cantidad_enviado INT NOT NULL,            -- Количество продукта отправленного
    p_precio_compra DECIMAL(10, 2) NOT NULL,    -- Цена закупки
    p_precio_venta DECIMAL(10, 2) NOT NULL,     -- Цена продажи
    fecha_ingreso DATE                          -- Дата ввода продукта в базу данных
);

CREATE TABLE usuarios (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,  -- Уникальный идентификатор пользователя
    u_nombre VARCHAR(255) NOT NULL,             -- Имя пользователя
    u_login VARCHAR(100) NOT NULL UNIQUE,       -- Логин пользователя, должен быть уникальным
    u_password VARCHAR(255) NOT NULL,           -- Пароль пользователя
    u_role ENUM('admin', 'manager','cliente', 'vendedor','receptor', 'recogedor') NOT NULL  -- Роль пользователя
);

CREATE TABLE facturas_entrega (
    fe_id INT AUTO_INCREMENT PRIMARY KEY,       -- Уникальный идентификатор фактуры
    fe_id_vendor INT NOT NULL,                  -- Идентификатор пользователя-продавца, ссылается на таблицу usuarios
    fe_fecha DATE NOT NULL,                     -- Дата фактуры отправки
    fe_suma DECIMAL(10, 2) NOT NULL,            -- Сумма фактуры отправленной с двумя знаками после запятой
    fe_id_receptor INT NOT NULL,                -- Идентификатор пользователя-приемщика, ссылается на таблицу usuarios
    fe_fecha_recepcion DATE NOT NULL,           -- Дата фактуры приема
    fe_suma_recepcion DECIMAL(10, 2) NOT NULL,  -- Сумма фактуры принятой с двумя знаками после запятой
    fe_aceptado BOOLEAN NOT NULL,               -- Флаг принятия заказа(true или false)
    FOREIGN KEY (fe_id_vendor) REFERENCES usuarios(id_usuario),   -- Связь с таблицей usuarios
    FOREIGN KEY (fe_id_receptor) REFERENCES usuarios(id_usuario)  -- Связь с таблицей usuarios
);

CREATE TABLE productos_entrega (
    pe_id_facturas INT NOT NULL,                      -- Идентификатор фактуры, связан с таблицей facturas_entrega
    pe_id_productos INT NOT NULL,                     -- Идентификатор продукта, связан с таблицей productos
    pe_cantidad_entregada INT NOT NULL,               -- Количество отгруженного товара
    pe_cantidad_aceptada INT NOT NULL,                -- Количество принятого товара
    pe_suma_entregada DECIMAL(10, 2) NOT NULL,        -- Сумма за отгруженный товар
    pe_suma_aceptada DECIMAL(10, 2) NOT NULL,         -- Сумма за принятый товар
    pe_aceptado BOOLEAN NOT NULL,                     -- Флаг принятия (true или false)
    pe_fecha_entrega DATE NOT NULL,                   -- Дата отгрузки товара
    pe_fecha_aceptacion DATE NOT NULL,                -- Дата принятия товара
    PRIMARY KEY (pe_id_facturas, pe_id_productos),    -- Уникальный составной ключ на основе пары id_facturas и id_productos
    FOREIGN KEY (pe_id_facturas) REFERENCES facturas_entrega(fe_id),   -- Связь с таблицей facturas_entrega
    FOREIGN KEY (pe_id_productos) REFERENCES productos(id_product)    -- Связь с таблицей productos
);

CREATE TABLE facturas_recogida (
    fr_id INT AUTO_INCREMENT PRIMARY KEY,      -- Уникальный идентификатор фактуры
    fr_id_cliente INT NOT NULL,                -- Идентификатор пользователя-клиента, ссылается на таблицу usuarios
    fr_fecha_pedido DATE NOT NULL,             -- Дата фактуры-заказа
    fr_suma_pedido DECIMAL(10, 2) NOT NULL,    -- Сумма фактуры-заказа с двумя знаками после запятой
    fr_id_recogedor INT NOT NULL,              -- Идентификатор пользователя-сборщика, ссылается на таблицу usuarios
    fr_fecha_recogida DATE NOT NULL,           -- Дата фактуры-сборки
    fr_suma_recogida DECIMAL(10, 2) NOT NULL,  -- Сумма фактуры-сборки с двумя знаками после запятой
    fr_aceptado BOOLEAN NOT NULL,              -- Флаг принятия (true или false)
    FOREIGN KEY (fr_id_cliente) REFERENCES usuarios(id_usuario),    -- Связь с таблицей usuarios
    FOREIGN KEY (fr_id_recogedor) REFERENCES usuarios(id_usuario)   -- Связь с таблицей usuarios
);

CREATE TABLE productos_recogida (
    pr_id_facturas INT NOT NULL,                     -- Идентификатор фактуры, связан с таблицей facturas_recogida
    pr_id_productos INT NOT NULL,                    -- Идентификатор продукта, связан с таблицей productos
    pr_cantidad_pedida INT NOT NULL,                 -- Количество заказанного товара
    pr_cantidad_recogida INT NOT NULL,               -- Количество принятого товара
    pr_suma_pedida DECIMAL(10, 2) NOT NULL,          -- Сумма за отгруженный товар
    pr_suma_recogida DECIMAL(10, 2) NOT NULL,        -- Сумма за принятый товар
    pr_aceptado BOOLEAN NOT NULL,                    -- Флаг принятия (true или false)
    pr_fecha_pedida DATE NOT NULL,                   -- Дата заказа товара
    pr_fecha_recogida DATE NOT NULL,                 -- Дата сбора товара
    PRIMARY KEY (pr_id_facturas, pr_id_productos),   -- Уникальный составной ключ на основе пары id_facturas и id_productos
    FOREIGN KEY (pr_id_facturas) REFERENCES facturas_recogida(fr_id),    -- Связь с таблицей facturas_recogida
    FOREIGN KEY (pr_id_productos) REFERENCES productos(id_product)       -- Связь с таблицей productos
);

INSERT INTO usuarios (u_nombre, u_login, u_password, u_role) 
VALUES 
('Oleg', 'oleg', 'securepassword1', 'admin'),
('María García', 'maria.garcia', 'securepassword2', 'manager'),
('Carlos Rodríguez', 'carlos.rodriguez', 'securepassword3', 'cliente'),
('Ana López', 'ana.lopez', 'securepassword4', 'vendedor'),
('José Fernández', 'jose.fernandez', 'securepassword5', 'receptor'),
('Elena Gómez', 'elena.gomez', 'securepassword6', 'recogedor');
