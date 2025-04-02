USE TallerMecanico;
GO

-- Clear existing data first
DELETE FROM DetallesReparacion;
DELETE FROM Reparaciones;
DELETE FROM Piezas;
DELETE FROM Coches;
DELETE FROM Clientes;
GO

-- Reset identity for Reparaciones
DBCC CHECKIDENT ('Reparaciones', RESEED, 0);
GO

-- Insert 10 Clientes (Customers)
INSERT INTO Clientes (DNI, Apellidos, Nombre, Direccion, CP, Poblacion, Telefono, Telefono2)
VALUES 
('12345678A', 'García Martínez', 'Antonio', 'Calle Mayor 12', '28001', 'Madrid', '600123456', NULL),
('23456789B', 'López Gómez', 'María', 'Avenida Libertad 34', '41001', 'Sevilla', '611234567', '954123456'),
('34567890C', 'Fernández Ruiz', 'Carlos', 'Plaza España 5', '08001', 'Barcelona', '622345678', NULL),
('45678901D', 'Martínez Sánchez', 'Laura', 'Calle Gran Vía 78', '46001', 'Valencia', '633456789', '963456789'),
('56789012E', 'Rodríguez Díaz', 'Javier', 'Avenida Diagonal 120', '08029', 'Barcelona', '644567890', NULL),
('67890123F', 'Pérez López', 'Ana', 'Calle Serrano 45', '28006', 'Madrid', '655678901', NULL),
('78901234G', 'González Fernández', 'Miguel', 'Paseo Castellana 200', '28046', 'Madrid', '666789012', '915678901'),
('89012345H', 'Sánchez Moreno', 'Isabel', 'Plaza Mayor 3', '37001', 'Salamanca', '677890123', NULL),
('90123456I', 'Díaz Romero', 'Pedro', 'Calle Sierpes 22', '41004', 'Sevilla', '688901234', NULL),
('01234567J', 'Moreno García', 'Elena', 'Rambla Catalunya 44', '08007', 'Barcelona', '699012345', '934567890');
GO

-- Insert 10 Coches (Cars)
INSERT INTO Coches (Matricula, DNIPropietario, Marca, Modelo, Color, Km)
VALUES 
('1234ABC', '12345678A', 'Seat', 'León', 'Rojo', 75000),
('5678DEF', '23456789B', 'Ford', 'Focus', 'Azul', 42000),
('9012GHI', '34567890C', 'Volkswagen', 'Golf', 'Negro', 52000),
('3456JKL', '45678901D', 'Renault', 'Clio', 'Blanco', 31500),
('7890MNO', '56789012E', 'Toyota', 'Corolla', 'Gris', 65000),
('2345PQR', '67890123F', 'Nissan', 'Qashqai', 'Azul', 48000),
('6789STU', '78901234G', 'Citroën', 'C4', 'Rojo', 95000),
('0123VWX', '89012345H', 'Opel', 'Astra', 'Negro', 28000),
('4567YZA', '90123456I', 'Peugeot', '308', 'Verde', 37500),
('8901BCD', '01234567J', 'Hyundai', 'i30', 'Plateado', 19800);
GO

-- Insert 10 Piezas (Parts)
INSERT INTO Piezas (Referencia, Descripcion, Precio, Stock)
VALUES 
('FIL-001', 'Filtro de aceite', 15.50, 45),
('ACE-002', 'Aceite motor 5L', 32.75, 20),
('FRE-010', 'Pastillas freno delanteras', 65.90, 12),
('FRE-011', 'Pastillas freno traseras', 58.25, 15),
('BAT-005', 'Batería 60Ah', 95.50, 8),
('AMO-020', 'Amortiguadores delanteros (par)', 178.90, 6),
('BUJ-030', 'Bujías (juego 4)', 28.60, 25),
('COR-015', 'Correa distribución', 45.30, 18),
('EMB-025', 'Kit embrague', 215.75, 5),
('RAD-007', 'Radiador refrigeración', 132.40, 7);
GO

-- Insert 10 Reparaciones (Repairs)
INSERT INTO Reparaciones (Matricula, Descripcion, FechaEntrada, FechaSalida, Horas)
VALUES 
('1234ABC', 'Cambio de aceite y filtros', '2025-01-15', '2025-01-15', 1.5),
('5678DEF', 'Revisión completa y cambio de frenos', '2025-01-20', '2025-01-21', 4.0),
('9012GHI', 'Cambio de batería', '2025-01-28', '2025-01-28', 0.5),
('3456JKL', 'Cambio de bujías', '2025-02-03', '2025-02-03', 1.0),
('7890MNO', 'Reparación sistema eléctrico', '2025-02-10', '2025-02-12', 5.5),
('2345PQR', 'Cambio de amortiguadores', '2025-02-15', '2025-02-16', 3.0),
('6789STU', 'Revisión general pre-ITV', '2025-02-22', '2025-02-23', 2.5),
('0123VWX', 'Cambio de correa distribución', '2025-03-05', '2025-03-06', 4.0),
('4567YZA', 'Cambio de embrague', '2025-03-10', '2025-03-12', 6.0),
('8901BCD', 'Reparación sistema refrigeración', '2025-03-18', '2025-03-19', 3.5);
GO

-- Insert 10+ DetallesReparacion (Repair Details)
INSERT INTO DetallesReparacion (NumReparacion, Referencia, Unidades)
VALUES 
-- Repair 1: Oil change
(1, 'FIL-001', 1),
(1, 'ACE-002', 1),

-- Repair 2: Complete check and brake change
(2, 'FRE-010', 1),
(2, 'FRE-011', 1),

-- Repair 3: Battery change
(3, 'BAT-005', 1),

-- Repair 4: Spark plugs
(4, 'BUJ-030', 1),

-- Repair 5: Electrical system repair (reusing parts)
(5, 'BAT-005', 1),

-- Repair 6: Shock absorbers
(6, 'AMO-020', 1),

-- Repair 7: Pre-inspection check
(7, 'FIL-001', 1),
(7, 'ACE-002', 1),
(7, 'BUJ-030', 1),

-- Repair 8: Timing belt
(8, 'COR-015', 1),

-- Repair 9: Clutch replacement
(9, 'EMB-025', 1),

-- Repair 10: Cooling system repair
(10, 'RAD-007', 1);
GO

-- Additional repair details to have more than 10 records
INSERT INTO DetallesReparacion (NumReparacion, Referencia, Unidades)
VALUES 
(1, 'BUJ-030', 1),  -- Additional spark plugs in repair 1
(2, 'ACE-002', 1),  -- Oil in repair 2
(2, 'FIL-001', 1),  -- Oil filter in repair 2
(5, 'BUJ-030', 1),  -- Spark plugs in repair 5
(10, 'ACE-002', 1); -- Oil in repair 10
GO