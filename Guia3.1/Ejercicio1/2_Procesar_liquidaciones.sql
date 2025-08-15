

USE GUIA2_1_Ejercicio1_DB;

GO

CREATE OR ALTER PROCEDURE ProcesarLiquidaciones
(
	@ANIO INT,
	@MES INT,
	@Id_Empresa INT
)
AS
BEGIN

	SET NOCOUNT ON; 

	-- consigo los valores de las tblas de busqueda
	DECLARE @Porc_Antiguedad DECIMAL(18, 2);
	SELECT TOP 1 @Porc_Antiguedad=Valor FROM Valores_Previsionales WHERE Nombre='Porcentaje Antiguedad';
	PRINT @Porc_Antiguedad;

	DECLARE @Porc_Obra_Social DECIMAL(18, 2);
	SELECT TOP 1 @Porc_Obra_Social=Valor FROM Valores_Previsionales WHERE Nombre='Porcentaje Obra Social';

	DECLARE @Porc_Jubilacion DECIMAL(18, 2);
	SELECT TOP 1 @Porc_Jubilacion=Valor FROM Valores_Previsionales WHERE Nombre='Porcentaje Jubilación';

	DECLARE @Porc_Gremial DECIMAL(18, 2);
	SELECT TOP 1 @Porc_Gremial=Valor FROM Valores_Previsionales WHERE Nombre='Porcentaje Gremial';

	DECLARE @Porc_Productividad DECIMAL(18, 2);
	SELECT TOP 1 @Porc_Productividad=Valor FROM Valores_Previsionales WHERE Nombre='Porcentaje Productividad';

	-- datos de entrada del proceso
	DECLARE Empleado_Cursor CURSOR FOR SELECT 
		ID, 
		DNI, 
		Nombre, 
		Apellido, 
		Anio_Contrato,
		Monto_Basico_Nominal, 
		Horas_Extras50, 
		Horas_Extras100 FROM Empleados;

	OPEN Empleado_Cursor;

	-- variables para almacenar los datos del cursor
	DECLARE @Id_Empleado INT, 
		@DNI INT, 
		@Nombre VARCHAR(100), 
		@Apellido VARCHAR(100), 
		@Anio_Contrato INT,
		@Monto_Basico_Nominal DECIMAL(18,2), 
		@Horas_Extras50 INT, 
		@Horas_Extras100 INT;

	-- obtenengo la primera fila del cursor
	FETCH NEXT FROM Empleado_Cursor INTO 
					@Id_Empleado, 
					@DNI, 
					@Nombre, 
					@Apellido, 
					@Anio_Contrato,
					@Monto_Basico_Nominal, 
					@Horas_Extras50, 
					@Horas_Extras100;
					

	WHILE @@FETCH_STATUS = 0
	BEGIN

		-- Nominal y montos parciales para el nominal  - mirar tabla de pancho

		DECLARE @Monto_Antiguedad DECIMAL(18, 2) = @Monto_Basico_Nominal * @Porc_Antiguedad / 100.0;
		DECLARE @Monto_Extras50 DECIMAL(18, 2) = @Horas_Extras50 * (@Monto_Basico_Nominal / 40) * 1.5;
		DECLARE @Monto_Extras100 DECIMAL(18, 2) = @Horas_Extras100 * (@Monto_Basico_Nominal / 40) * 2;		
		
		DECLARE @Monto_Nominal DECIMAL(18, 2) = @Monto_Basico_Nominal + @Monto_Antiguedad + @Monto_Extras50 + @Monto_Extras100;

		-- Calculo de los montos previsionales
		DECLARE @Monto_Obra_Social DECIMAL(18, 2) = @Monto_Nominal * @Porc_Obra_Social/100.0; 
		DECLARE @Monto_Jubilacion DECIMAL(18, 2) = @Monto_Nominal * @Porc_Jubilacion/100.0; 
		DECLARE @Monto_Gremial DECIMAL(18, 2) = @Monto_Nominal * @Porc_Gremial/100.0; 

		DECLARE @Monto_Neto DECIMAL(18, 2) = @Monto_Nominal - @Monto_Obra_Social - @Monto_Jubilacion - @Monto_Gremial;

		-- productividad sobre el neto
		DECLARE @Monto_Productividad DECIMAL(18, 2) = @Monto_Neto*@Porc_Productividad/100.0;

		DECLARE @Monto_Total DECIMAL(18, 2) = @Monto_Neto + @Monto_Productividad;

		INSERT INTO Liquidaciones( 
			Anio, 
			Mes, 
			Monto_Basico, 
			Horas_Extras50, 
			Horas_Extras100, 
			--
			Porc_Antiguedad, 
			Porc_Obrasocial, 
			Porc_Jubilacion, 
			Porc_Gremial, 
			--
			Monto_Antiguedad, 			
			Monto_Extras50, 			
			Monto_Extras100, 
			Monto_Nominal, 			
			Monto_Obra_Social, 			
			Monto_Jubilacion, 			
			Monto_Gremial, 	
			--
			Monto_Neto, 
			Monto_Productividad,
			Monto_Total,
			--
			Id_Empleado
			--
		) VALUES (
			@ANIO,
			@MES,
			@Monto_Basico_Nominal,
			@Horas_Extras50,
			@Horas_Extras100,
			--
			@Porc_Antiguedad,
			@Porc_Obra_Social,
			@Porc_Jubilacion,
			@Porc_Gremial,
			--
			@Monto_Antiguedad,			
			@Monto_Extras50,
			@Monto_Extras100,
			@Monto_Nominal,
			@Monto_Obra_Social,
			@Monto_Jubilacion,
			@Monto_Gremial,
			--
			@Monto_Neto,
			@Monto_Productividad,
			@Monto_Total,
			--
			@Id_Empleado
		);

		-- obtenengo la siguiente fila del cursor
		FETCH NEXT FROM Empleado_Cursor INTO 
					@Id_Empleado, 
					@DNI, 
					@Nombre, 
					@Apellido, 
					@Anio_Contrato,
					@Monto_Basico_Nominal, 
					@Horas_Extras50, 
					@Horas_Extras100;
	END
	CLOSE Empleado_Cursor;
	DEALLOCATE Empleado_Cursor;

END

GO

USE master;



