-- ==================================================
-- CREACIÓN DE BASE DE DATOS
-- ==================================================

DROP DATABASE IF EXISTS gestion_alojamientos;

CREATE DATABASE gestion_alojamientos



-- ==================================================
-- CREACIÓN DE TABLAS
-- ==================================================

DROP TABLE IF EXISTS pagos CASCADE;
DROP TABLE IF EXISTS resenas CASCADE;
DROP TABLE IF EXISTS reservas CASCADE;
DROP TABLE IF EXISTS huespedes CASCADE;
DROP TABLE IF EXISTS alojamientos CASCADE;
DROP TABLE IF EXISTS propietarios CASCADE;

-- Tabla: propietarios
CREATE TABLE propietarios (
    id_propietario SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    telefono VARCHAR(20),
    fecha_registro DATE DEFAULT CURRENT_DATE
);

-- Tabla: alojamientos
CREATE TABLE alojamientos (
    id_alojamiento SERIAL PRIMARY KEY,
    id_propietario INTEGER NOT NULL,
    nombre VARCHAR(200) NOT NULL,
    descripcion TEXT,
    tipo VARCHAR(50) NOT NULL,
    direccion VARCHAR(250) NOT NULL,
    ciudad VARCHAR(100) NOT NULL,
    pais VARCHAR(100) NOT NULL,
    precio_noche DECIMAL(10,2) NOT NULL,
    capacidad_personas INTEGER NOT NULL,
    num_habitaciones INTEGER NOT NULL,
    num_banos INTEGER NOT NULL,
    activo BOOLEAN DEFAULT true,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_propietario) REFERENCES propietarios(id_propietario) ON DELETE CASCADE
);

-- Tabla: huespedes
CREATE TABLE huespedes (
    id_huesped SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    telefono VARCHAR(20),
    nacionalidad VARCHAR(100) NOT NULL,
    fecha_registro DATE DEFAULT CURRENT_DATE
);

-- Tabla: reservas
CREATE TABLE reservas (
    id_reserva SERIAL PRIMARY KEY,
    id_alojamiento INTEGER NOT NULL,
    id_huesped INTEGER NOT NULL,
    fecha_entrada DATE NOT NULL,
    fecha_salida DATE NOT NULL,
    num_personas INTEGER NOT NULL,
    precio_total DECIMAL(10,2) NOT NULL,
    estado VARCHAR(50) DEFAULT 'confirmada',
    fecha_reserva TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_alojamiento) REFERENCES alojamientos(id_alojamiento) ON DELETE CASCADE,
    FOREIGN KEY (id_huesped) REFERENCES huespedes(id_huesped) ON DELETE CASCADE,
    CHECK (fecha_salida > fecha_entrada)
);

-- Tabla: pagos
CREATE TABLE pagos (
    id_pago SERIAL PRIMARY KEY,
    id_reserva INTEGER NOT NULL,
    monto DECIMAL(10,2) NOT NULL,
    metodo_pago VARCHAR(50) NOT NULL,
    estado_pago VARCHAR(50) DEFAULT 'completado',
    fecha_pago TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_reserva) REFERENCES reservas(id_reserva) ON DELETE CASCADE
);

-- Tabla: resenas
CREATE TABLE resenas (
    id_resena SERIAL PRIMARY KEY,
    id_alojamiento INTEGER NOT NULL,
    id_huesped INTEGER NOT NULL,
    id_reserva INTEGER NOT NULL,
    calificacion INTEGER NOT NULL CHECK (calificacion BETWEEN 1 AND 5),
    comentario TEXT,
    fecha_resena TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_alojamiento) REFERENCES alojamientos(id_alojamiento) ON DELETE CASCADE,
    FOREIGN KEY (id_huesped) REFERENCES huespedes(id_huesped) ON DELETE CASCADE,
    FOREIGN KEY (id_reserva) REFERENCES reservas(id_reserva) ON DELETE CASCADE
);

-- ==================================================
-- INSERTAR DATOS DE PRUEBA
-- ==================================================

INSERT INTO propietarios (nombre, apellido, email, telefono) VALUES
('Carlos', 'Mendoza', 'carlos.mendoza@email.com', '+503-7123-4567'),
('María', 'González', 'maria.gonzalez@email.com', '+503-7234-5678'),
('José', 'Ramírez', 'jose.ramirez@email.com', '+503-7345-6789'),
('Ana', 'López', 'ana.lopez@email.com', '+503-7456-7890'),
('Pedro', 'Martínez', 'pedro.martinez@email.com', '+503-7567-8901');

INSERT INTO alojamientos (id_propietario, nombre, descripcion, tipo, direccion, ciudad, pais, precio_noche, capacidad_personas, num_habitaciones, num_banos, activo) VALUES
(1, 'Apartamento Centro Histórico', 'Hermoso apartamento en el corazón de San Salvador', 'apartamento', 'Calle Arce #245', 'San Salvador', 'El Salvador', 45.00, 4, 2, 1, true),
(1, 'Casa de Playa El Tunco', 'Casa completa frente al mar', 'casa', 'Boulevard El Tunco', 'La Libertad', 'El Salvador', 120.00, 8, 4, 3, true),
(2, 'Villa Lago de Coatepeque', 'Villa de lujo con vista al lago', 'villa', 'Carretera al Lago km 5', 'Santa Ana', 'El Salvador', 200.00, 10, 5, 4, true),
(2, 'Habitación Privada San Miguel', 'Habitación cómoda en zona segura', 'habitacion', 'Colonia Jardín #123', 'San Miguel', 'El Salvador', 25.00, 2, 1, 1, true),
(3, 'Apartamento Zona Rosa', 'Moderno apartamento en zona exclusiva', 'apartamento', 'Boulevard del Hipódromo', 'San Salvador', 'El Salvador', 65.00, 4, 2, 2, true),
(3, 'Casa Ruta de las Flores', 'Casa tradicional en pueblo pintoresco', 'casa', 'Calle Principal Juayúa', 'Sonsonate', 'El Salvador', 80.00, 6, 3, 2, true),
(4, 'Estudio Escalón', 'Estudio minimalista totalmente equipado', 'apartamento', 'Paseo Escalón #567', 'San Salvador', 'El Salvador', 40.00, 2, 1, 1, false),
(4, 'Cabaña Montaña Cerro Verde', 'Cabaña rústica en área natural', 'casa', 'Parque Nacional Cerro Verde', 'Santa Ana', 'El Salvador', 55.00, 4, 2, 1, true),
(5, 'Loft Moderno Santa Tecla', 'Loft industrial renovado', 'apartamento', 'Calle Nueva #789', 'La Libertad', 'El Salvador', 75.00, 3, 1, 1, true),
(5, 'Penthouse San Benito', 'Penthouse de lujo con terraza', 'apartamento', 'Colonia San Benito', 'San Salvador', 'El Salvador', 150.00, 6, 3, 3, true);

INSERT INTO huespedes (nombre, apellido, email, telefono, nacionalidad) VALUES
('Laura', 'Smith', 'laura.smith@email.com', '+1-555-0101', 'Estados Unidos'),
('Juan', 'Pérez', 'juan.perez@email.com', '+503-6123-4567', 'El Salvador'),
('Sophie', 'Dubois', 'sophie.dubois@email.com', '+33-6-12-34-56-78', 'Francia'),
('Marco', 'Rossi', 'marco.rossi@email.com', '+39-333-123-4567', 'Italia'),
('Emma', 'Johnson', 'emma.johnson@email.com', '+1-555-0202', 'Estados Unidos'),
('Diego', 'Fernández', 'diego.fernandez@email.com', '+52-55-1234-5678', 'México'),
('Yuki', 'Tanaka', 'yuki.tanaka@email.com', '+81-90-1234-5678', 'Japón'),
('Hans', 'Mueller', 'hans.mueller@email.com', '+49-176-12345678', 'Alemania'),
('Isabella', 'Costa', 'isabella.costa@email.com', '+55-11-98765-4321', 'Brasil'),
('Oliver', 'Brown', 'oliver.brown@email.com', '+44-7700-900123', 'Reino Unido');

INSERT INTO reservas (id_alojamiento, id_huesped, fecha_entrada, fecha_salida, num_personas, precio_total, estado) VALUES
(1, 1, '2025-06-15', '2025-06-20', 2, 225.00, 'completada'),
(2, 2, '2025-07-01', '2025-07-07', 6, 720.00, 'confirmada'),
(3, 3, '2025-08-10', '2025-08-15', 8, 1000.00, 'confirmada'),
(4, 4, '2025-06-20', '2025-06-25', 2, 125.00, 'completada'),
(5, 5, '2025-07-15', '2025-07-18', 3, 195.00, 'confirmada'),
(6, 6, '2025-08-01', '2025-08-05', 4, 320.00, 'confirmada'),
(1, 7, '2025-09-10', '2025-09-15', 2, 225.00, 'confirmada'),
(8, 8, '2025-07-20', '2025-07-25', 4, 275.00, 'completada'),
(9, 9, '2025-08-15', '2025-08-18', 2, 225.00, 'confirmada'),
(10, 10, '2025-09-01', '2025-09-05', 4, 600.00, 'confirmada'),
(2, 1, '2025-10-01', '2025-10-07', 8, 720.00, 'confirmada'),
(3, 5, '2025-11-15', '2025-11-20', 10, 1000.00, 'confirmada'),
(5, 2, '2025-12-20', '2025-12-25', 4, 325.00, 'confirmada'),
(6, 3, '2026-01-10', '2026-01-15', 6, 400.00, 'pendiente');

INSERT INTO pagos (id_reserva, monto, metodo_pago, estado_pago) VALUES
(1, 225.00, 'tarjeta', 'completado'),
(2, 720.00, 'paypal', 'completado'),
(3, 1000.00, 'transferencia', 'completado'),
(4, 125.00, 'tarjeta', 'completado'),
(5, 195.00, 'tarjeta', 'completado'),
(6, 320.00, 'paypal', 'completado'),
(7, 225.00, 'tarjeta', 'completado'),
(8, 275.00, 'efectivo', 'completado'),
(9, 225.00, 'tarjeta', 'completado'),
(10, 600.00, 'transferencia', 'completado'),
(11, 720.00, 'tarjeta', 'completado'),
(12, 1000.00, 'paypal', 'completado'),
(13, 325.00, 'tarjeta', 'completado');

INSERT INTO resenas (id_alojamiento, id_huesped, id_reserva, calificacion, comentario) VALUES
(1, 1, 1, 5, 'Excelente ubicación y muy limpio. Altamente recomendado.'),
(2, 2, 2, 4, 'La casa es hermosa, pero el WiFi podría ser mejor.'),
(3, 3, 3, 5, 'Vista espectacular del lago. Una experiencia inolvidable.'),
(4, 4, 4, 4, 'Habitación cómoda y anfitrión muy amable.'),
(5, 5, 5, 5, 'Apartamento moderno y bien equipado. Perfecto para mi estadía.'),
(6, 6, 6, 5, 'Pueblo encantador y la casa tiene mucho carácter.'),
(1, 7, 7, 4, 'Buena experiencia en general, solo faltaba aire acondicionado.'),
(8, 8, 8, 5, 'Cabaña acogedora en medio de la naturaleza. Muy relajante.');

-- Verificación de datos
SELECT * FROM propietarios;

SELECT * FROM alojamientos

SELECT * FROM huespedes

SELECT * FROM reservas

SELECT * FROM pagos

SELECT * FROM resenas













