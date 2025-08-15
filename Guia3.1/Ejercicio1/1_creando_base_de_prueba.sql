
USE master;

GO

ALTER DATABASE GUIA2_1_Ejercicio1_DB
SET SINGLE_USER
WITH ROLLBACK IMMEDIATE;

GO

DROP DATABASE IF EXISTS GUIA2_1_Ejercicio1_DB;

GO

CREATE DATABASE GUIA2_1_Ejercicio1_DB

GO

USE GUIA2_1_Ejercicio1_DB;

GO

CREATE TABLE Empresas(
	Id INT PRIMARY KEY IDENTITY(1,1),	
	Nombre VARCHAR(100) NOT NULL,
);

GO

CREATE TABLE Empleados 
(
	Id INT PRIMARY KEY IDENTITY(1,1),
	DNI INT NOT NULL UNIQUE,
	Nombre NVARCHAR(50) NOT NULL,
	Apellido NVARCHAR(50) NOT NULL,
	Fecha_Contrato DATE NOT NULL,
	Monto_Basico DECIMAL(18, 2) NOT NULL,
	--
	Id_Empresa INT NOT NULL,
	CONSTRAINT FK_Empleados_Empresa FOREIGN KEY (Id_Empresa) REFERENCES Empresas(Id)
);

GO

CREATE TABLE Registro_Horas_Extras
(
	Id INT PRIMARY KEY IDENTITY(1,1),
	Fecha DATE NOT NULL,
	Hora_Entrada TIME NOT NULL,
	Hora_Salida TIME NOT NULL,
	--
	Id_Empleado INT NOT NULL,
	CONSTRAINT FK_Empleados_Registro_Laboral FOREIGN KEY (Id_Empleado) REFERENCES Empleados(Id)
);

GO

CREATE TABLE Liquidaciones(
	Id INT PRIMARY KEY IDENTITY(1,1),
	Anio INT NOT NULL,
	Mes DECIMAL(18, 2) NOT NULL,
	Monto_Basico DECIMAL(18,2) NOT NULL,
	--
	Porcentaje_Antiguedad DECIMAL(18, 2) NOT NULL,
	Monto_Antiguedad DECIMAL(18, 2) NOT NULL,
	Horas_Extras50 DECIMAL(18, 2) NOT NULL,
	Monto_Extras50 DECIMAL(18, 2) NOT NULL,
	Horas_Extras100 DECIMAL(18, 2) NOT NULL,
	Monto_Extras100 DECIMAL(18, 2) NOT NULL,
	Monto_Nominal DECIMAL(18, 2) NOT NULL,	
	Porcentaje_Obrasocial DECIMAL(18, 2) NOT NULL,
	Monto_Obra_Social DECIMAL(18, 2) NOT NULL,
	Porcentaje_Jubilacion DECIMAL(18, 2) NOT NULL,
	Monto_Jubilacion DECIMAL(18, 2) NOT NULL,
	Porcentaje_Gremial DECIMAL(18, 2) NOT NULL,
	Monto_Gremial DECIMAL(18, 2) NOT NULL,
	Monto_Neto DECIMAL(18, 2) NOT NULL,
	Monto_Productividad DECIMAL(18, 2) NOT NULL,
	Monto_Total DECIMAL(18, 2) NOT NULL,
	--
	Id_Empleado INT NOT NULL,
	CONSTRAINT FK_Empleados_Empleado FOREIGN KEY (Id_Empleado) REFERENCES Empleados(Id)
);

GO

CREATE TABLE Valores_Previsionales(
	Id INT PRIMARY KEY IDENTITY(1,1),
	Nombre NVARCHAR(100) NOT NULL UNIQUE,
	Valor DECIMAL(18, 2) NOT NULL,
);


GO

DECLARE @Resultado TABLE(Id INT);
DECLARE @Id_Empresa INT;

INSERT INTO Empresas (Nombre) 
OUTPUT INSERTED.Id INTO @Resultado --clausula OUTPUT 
VALUES ('El gato');

SELECT TOP 1 @Id_Empresa = Id FROM @Resultado;

PRINT 'Empresa creada con ID: ' + CONVERT(VARCHAR, @Id_Empresa);

-- Tablas lut (o  de busquedas o de configuración)
-- Me guardo todas las constantes de sistema y luego utilizo
-- como clave  el Nombre
-- en este caso particular, utilizo los valores previsionales, pero en realidad estos valores deberian asociarse a una fecha.
INSERT INTO Valores_Previsionales (Nombre, Valor) VALUES 
('Porcentaje Antiguedad', 10.0),
('Porcentaje Obra Social', 3),
('Porcentaje Jubilación', 18),
('Porcentaje Gremial', 1.5),
('Porcentaje Productividad', 30);

-- Empleados de prueba
INSERT INTO Empleados (DNI, Nombre, Apellido, Anio_Contrato, Monto_Basico_Nominal, Horas_Extras50, Horas_Extras100, Id_Empresa) VALUES 
(45455232, 'Cecilia', 'Benitez', 2020, 50000.00, 10, 5, @Id_Empresa),
(25245551, 'José', 'Hernandez', 2019, 60000.00, 8, 3, @Id_Empresa),
(34554485, 'Excequiel', 'Casas', 2021, 55000.00, 12, 4, @Id_Empresa),
(24554485, 'Armando', 'Casas', 2021, 55000.00, 12, 4, @Id_Empresa);


USE master;

