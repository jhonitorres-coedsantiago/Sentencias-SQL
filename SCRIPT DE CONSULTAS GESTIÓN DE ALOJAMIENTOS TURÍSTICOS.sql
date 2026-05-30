-- SCRIPT DE CONSULTAS: GESTIÓN DE ALOJAMIENTOS TURÍSTICOS

-- 01 INSERT: Insertar propietario (Agregar un nuevo propietario)
INSERT INTO propietarios (nombre, apellido, email, telefono) 
VALUES ('Roberto', 'Cisneros', 'roberto.cisneros@email.com', '+503-7999-0000');

-- 02 INSERT: Insertar alojamiento (Crear alojamiento vinculado)

INSERT INTO alojamientos (id_propietario, nombre, descripcion, tipo, direccion, ciudad, pais, precio_noche, capacidad_personas, num_habitaciones, num_banos, activo) 
VALUES (6, 'Cabaña El Boquerón', 'Acogedora cabaña con clima fresco', 'casa', 'Km 18, El Boquerón', 'San Salvador', 'El Salvador', 60.00, 4, 2, 1, true);

-- 03 INSERT: Huésped y reserva (Registrar huésped y su reserva)
INSERT INTO huespedes (nombre, apellido, email, telefono, nacionalidad) 
VALUES ('Lucía', 'Méndez', 'lucia.mendez@email.com', '+503-6888-7777', 'El Salvador');

-- Asumiendo que el id_huesped generado es 11 y reservará el alojamiento 1
INSERT INTO reservas (id_alojamiento, id_huesped, fecha_entrada, fecha_salida, num_personas, precio_total, estado) 
VALUES (1, 11, '2026-07-10', '2026-07-15', 2, 225.00, 'confirmada');

-- 04 INSERT: Insertar pago (Registrar pago)
INSERT INTO pagos (id_reserva, monto, metodo_pago, estado_pago) 
VALUES (14, 225.00, 'transferencia', 'completado');

-- 05 SELECT: Alojamientos activos (Filtrar activos)
SELECT id_alojamiento, nombre, ciudad, precio_noche 
FROM alojamientos 
WHERE activo = true;

-- 06 SELECT: Huéspedes por país (Filtrar por nacionalidad)
SELECT nombre, apellido, email, nacionalidad 
FROM huespedes 
WHERE nacionalidad = 'Estados Unidos';

-- 07 SELECT: Reservas por fechas (Uso de BETWEEN)
SELECT id_reserva, fecha_entrada, fecha_salida, precio_total 
FROM reservas 
WHERE fecha_entrada BETWEEN '2025-07-01' AND '2025-08-31';

-- 08 UPDATE: Actualizar precio (Modificar precio)
UPDATE alojamientos 
SET precio_noche = 50.00 
WHERE id_alojamiento = 1;

-- 09 UPDATE: Estado reserva (Actualizar estado)
UPDATE reservas 
SET estado = 'cancelada' 
WHERE id_reserva = 14;

-- 10 DELETE: Eliminar reseña (DELETE WHERE)
DELETE FROM resenas 
WHERE id_resena = 8;

-- 11 JOIN: Reservas + huésped (INNER JOIN)
SELECT r.id_reserva, r.fecha_entrada, r.fecha_salida, h.nombre, h.apellido, h.nacionalidad
FROM reservas r
INNER JOIN huespedes h ON r.id_huesped = h.id_huesped;

-- 12 JOIN: Alojamiento completo (INNER JOIN múltiple)
SELECT a.nombre AS nombre_alojamiento, p.nombre AS nombre_propietario, p.apellido AS apellido_propietario, r.fecha_entrada, r.estado
FROM alojamientos a
INNER JOIN propietarios p ON a.id_propietario = p.id_propietario
INNER JOIN reservas r ON a.id_alojamiento = r.id_alojamiento;

-- 13 JOIN: Pagos + reservas (JOIN combinado)
SELECT p.id_pago, p.monto, p.metodo_pago, r.fecha_entrada, r.estado
FROM pagos p
INNER JOIN reservas r ON p.id_reserva = r.id_reserva;

-- 14 LEFT JOIN: Sin reseñas (Incluye nulls)
SELECT a.id_alojamiento, a.nombre, res.calificacion, res.comentario
FROM alojamientos a
LEFT JOIN resenas res ON a.id_alojamiento = res.id_alojamiento;

-- 15 LEFT JOIN: Sin reservas (Filtrar null)
SELECT a.id_alojamiento, a.nombre, a.tipo
FROM alojamientos a
LEFT JOIN reservas r ON a.id_alojamiento = r.id_alojamiento
WHERE r.id_reserva IS NULL;

-- 16 AGG: Total ingresos (Uso de SUM)
SELECT SUM(monto) AS total_ingresos_completados
FROM pagos
WHERE estado_pago = 'completado';

-- 17 AGG: Promedio rating (Uso de AVG)
SELECT id_alojamiento, ROUND(AVG(calificacion), 2) AS promedio_calificacion
FROM resenas
GROUP BY id_alojamiento;

-- 18 AGG: Top alojamientos (COUNT + LIMIT)
SELECT id_alojamiento, COUNT(id_reserva) AS total_reservas
FROM reservas
GROUP BY id_alojamiento
ORDER BY total_reservas DESC
LIMIT 3;

-- 19 HAVING: Más de 3 reservas (GROUP BY + HAVING)
SELECT id_alojamiento, COUNT(id_reserva) AS total_reservas
FROM reservas
GROUP BY id_alojamiento
HAVING COUNT(id_reserva) > 3;

-- 20 Subconsulta: Alojamiento más caro (Subquery)
SELECT id_alojamiento, nombre, ciudad, precio_noche
FROM alojamientos
WHERE precio_noche = (SELECT MAX(precio_noche) FROM alojamientos);