-- Create database for auto repair shop
CREATE DATABASE TallerMecanico;
GO

USE TallerMecanico;
GO

-- Create Clientes (Customers) table
CREATE TABLE Clientes (
    DNI VARCHAR(20) PRIMARY KEY,
    Apellidos VARCHAR(100) NOT NULL,
    Nombre VARCHAR(100) NOT NULL,
    Direccion VARCHAR(200),
    CP VARCHAR(10),
    Poblacion VARCHAR(100),
    Telefono VARCHAR(20),
    Telefono2 VARCHAR(20)
);
GO

-- Create Coches (Cars) table
CREATE TABLE Coches (
    Matricula VARCHAR(20) PRIMARY KEY,
    DNIPropietario VARCHAR(20) NOT NULL,
    Marca VARCHAR(50),
    Modelo VARCHAR(50),
    Color VARCHAR(30),
    Km INT,
    CONSTRAINT FK_Coches_Clientes FOREIGN KEY (DNIPropietario) REFERENCES Clientes(DNI)
);
GO

-- Create Reparaciones (Repairs) table
CREATE TABLE Reparaciones (
    NumReparacion INT IDENTITY(1,1) PRIMARY KEY,
    Matricula VARCHAR(20) NOT NULL,
    Descripcion VARCHAR(500),
    FechaEntrada DATE NOT NULL,
    FechaSalida DATE,
    Horas DECIMAL(6,2),
    CONSTRAINT FK_Reparaciones_Coches FOREIGN KEY (Matricula) REFERENCES Coches(Matricula)
);
GO

-- Create Piezas (Parts) table
CREATE TABLE Piezas (
    Referencia VARCHAR(50) PRIMARY KEY,
    Descripcion VARCHAR(200) NOT NULL,
    Precio MONEY NOT NULL,
    Stock INT NOT NULL
);
GO

-- Create DetallesReparacion (Repair Details) table
CREATE TABLE DetallesReparacion (
    NumReparacion INT,
    Referencia VARCHAR(50),
    Unidades INT NOT NULL,
    PRIMARY KEY (NumReparacion, Referencia),
    CONSTRAINT FK_DetallesReparacion_Reparaciones FOREIGN KEY (NumReparacion) REFERENCES Reparaciones(NumReparacion),
    CONSTRAINT FK_DetallesReparacion_Piezas FOREIGN KEY (Referencia) REFERENCES Piezas(Referencia)
);
GO

-- Create some indexes to improve performance
CREATE INDEX IX_Coches_DNIPropietario ON Coches(DNIPropietario);
CREATE INDEX IX_Reparaciones_Matricula ON Reparaciones(Matricula);
CREATE INDEX IX_DetallesReparacion_Referencia ON DetallesReparacion(Referencia);
GO

-- Insert sample data
INSERT INTO Clientes (DNI, Apellidos, Nombre, Direccion, CP, Poblacion, Telefono, Telefono2)
VALUES 
('12345678A', 'García Martínez', 'Antonio', 'Calle Mayor 12', '28001', 'Madrid', '600123456', NULL),
('23456789B', 'López Gómez', 'María', 'Avenida Libertad 34', '41001', 'Sevilla', '611234567', '954123456');
GO

INSERT INTO Coches (Matricula, DNIPropietario, Marca, Modelo, Color, Km)
VALUES 
('1234ABC', '12345678A', 'Seat', 'León', 'Rojo', 75000),
('5678DEF', '23456789B', 'Ford', 'Focus', 'Azul', 42000);
GO

INSERT INTO Reparaciones (Matricula, Descripcion, FechaEntrada, FechaSalida, Horas)
VALUES 
('1234ABC', 'Cambio de aceite y filtros', '2025-03-15', '2025-03-15', 1.5),
('5678DEF', 'Revisión completa y cambio de frenos', '2025-03-20', NULL, 4.0);
GO

INSERT INTO Piezas (Referencia, Descripcion, Precio, Stock)
VALUES 
('FIL-001', 'Filtro de aceite', 15.50, 45),
('ACE-002', 'Aceite motor 5L', 32.75, 20),
('FRE-010', 'Pastillas freno delanteras', 65.90, 12);
GO

INSERT INTO DetallesReparacion (NumReparacion, Referencia, Unidades)
VALUES 
(1, 'FIL-001', 1),
(1, 'ACE-002', 1),
(2, 'FRE-010', 1);
GO

-- Create a view to see repair details with customer information
CREATE VIEW vw_ReparacionesCompletas AS
SELECT 
    r.NumReparacion,
    cl.DNI,
    cl.Nombre + ' ' + cl.Apellidos AS NombreCompleto,
    co.Matricula,
    co.Marca,
    co.Modelo,
    r.Descripcion AS DescripcionReparacion,
    r.FechaEntrada,
    r.FechaSalida,
    r.Horas,
    SUM(p.Precio * dr.Unidades) AS CostePiezas,
    r.Horas * 45.00 AS CosteLabor,
    (SUM(p.Precio * dr.Unidades) + (r.Horas * 45.00)) AS CosteTotal
FROM Reparaciones r
INNER JOIN Coches co ON r.Matricula = co.Matricula
INNER JOIN Clientes cl ON co.DNIPropietario = cl.DNI
LEFT JOIN DetallesReparacion dr ON r.NumReparacion = dr.NumReparacion
LEFT JOIN Piezas p ON dr.Referencia = p.Referencia
GROUP BY r.NumReparacion, cl.DNI, cl.Nombre, cl.Apellidos, co.Matricula, co.Marca, co.Modelo, r.Descripcion, r.FechaEntrada, r.FechaSalida, r.Horas;
GO

-- Create a stored procedure to create new repair
CREATE PROCEDURE sp_NuevaReparacion
    @Matricula VARCHAR(20),
    @Descripcion VARCHAR(500),
    @Horas DECIMAL(6,2) = NULL
AS
BEGIN
    INSERT INTO Reparaciones (Matricula, Descripcion, FechaEntrada, FechaSalida, Horas)
    VALUES (@Matricula, @Descripcion, GETDATE(), NULL, @Horas);
    
    RETURN SCOPE_IDENTITY();
END;
GO

-- Create a stored procedure to add parts to a repair
CREATE PROCEDURE sp_AgregarPiezaReparacion
    @NumReparacion INT,
    @Referencia VARCHAR(50),
    @Unidades INT
AS
BEGIN
    -- Check if we have enough stock
    DECLARE @StockActual INT;
    SELECT @StockActual = Stock FROM Piezas WHERE Referencia = @Referencia;
    
    IF @StockActual >= @Unidades
    BEGIN
        -- Update stock
        UPDATE Piezas SET Stock = Stock - @Unidades WHERE Referencia = @Referencia;
        
        -- Add part to repair
        IF EXISTS (SELECT 1 FROM DetallesReparacion WHERE NumReparacion = @NumReparacion AND Referencia = @Referencia)
            UPDATE DetallesReparacion SET Unidades = Unidades + @Unidades 
            WHERE NumReparacion = @NumReparacion AND Referencia = @Referencia;
        ELSE
            INSERT INTO DetallesReparacion (NumReparacion, Referencia, Unidades)
            VALUES (@NumReparacion, @Referencia, @Unidades);
            
        RETURN 0; -- Success
    END
    ELSE
        RETURN -1; -- Not enough stock
END;
GO

-- Create a stored procedure to complete a repair
CREATE PROCEDURE sp_CompletarReparacion
    @NumReparacion INT,
    @Horas DECIMAL(6,2) = NULL
AS
BEGIN
    UPDATE Reparaciones
    SET FechaSalida = GETDATE(),
        Horas = ISNULL(@Horas, Horas)
    WHERE NumReparacion = @NumReparacion;
END;
GO