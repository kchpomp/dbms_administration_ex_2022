USE BikeStores
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Partitioning_DB] @num_gr INT, @path NVARCHAR(MAX), @partition_func_name NVARCHAR(MAX), @part_scheme_name NVARCHAR(MAX)
	AS BEGIN
	-- LIST OF VARIABLES: dbname, group_filename, path
		DECLARE @curr_gr INT;
		DECLARE @curr_gr_name NVARCHAR(MAX);
		DECLARE @curr_gr_filename NVARCHAR(MAX);
		DECLARE @curr_gr_filename_path NVARCHAR(MAX);
		DECLARE @gr_string NVARCHAR(MAX);

		SET @num_gr = 3;
		SET @path = 'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA'

		SET @curr_gr = 1;
		SET @gr_string = '';

		-- THIS PART OF THE STORED PROCEDURE ALLOWS TO CREATE SEVERAL FILEGROUPS AND THEN ADD FILES TO EACH GROUP
		WHILE (@curr_gr <= @num_gr)
			BEGIN
				-- CREATING NECESSARY VARIABLES
				SET @curr_gr_name = 'FG'''+@curr_gr+'''';
				SET @curr_gr_filename = @curr_gr_name + '_file';
				SET @curr_gr_filename_path = @path + @curr_gr_filename + '.NDF';

				-- CREATING FILE GROUP
				ALTER DATABASE northwind ADD FILEGROUP [@curr_gr_name];

				-- ADDING FILES TO EACH GROUP
				ALTER DATABASE northwind ADD FILE (
					NAME = [@curr_gr_filename],
					FILENAME = [@curr_gr_filename_path],
					SIZE = 5 MB,
					MAXSIZE = UNLIMITED,
					FILEGROWTH = 10 MB
				) TO FILEGROUP [@curr_gr_name];

				SET @curr_gr = @curr_gr + 1;
				SET @gr_string = @gr_string + ', ' + @curr_gr_name;
			END;

			SELECT @gr_string = SUBSTRING(@gr_string, 2, 1000);

		-- THIS PART INTRODUCES THE PARTITIONING FUNCTION
		CREATE PARTITION FUNCTION [@partition_func_name](datetime2(0)) AS RANGE RIGHT FOR VALUES ('2016-12-31', '2017-12-31','2018-12-31');

		-- THIS PART INTRODUCES THE PARTITIONING SCHEME
		CREATE PARTITION SCHEME [@part_scheme_name] AS PARTITION [@partition_func_name] TO ([@gr_string]);

		-- PART TO CREATE PARTITIONED TABLE
		CREATE TABLE sales.order_reports (
			order_date date,
			product_name varchar(255),
			amount decimal(10, 2) NOT NULL DEFAULT 0,
			PRIMARY KEY (order_date, product_name)
		) 
		ON [@part_scheme_name] (order_date);

		-- PART TO LOAD THE DATA INTO PARTITIONED TABLE
		INSERT INTO sales.order_reports (order_date, product_name, amount)
			SELECT order_date,
				   product_name,
				   SUM(i.quantity * i.list_price * (1 - discount))
			FROM sales.orders AS o INNER JOIN sales.order_items AS i
			ON i.order_id = o.order_id INNER JOIN production.products AS p
			ON p.product_id = i.product_id
			GROUP BY order_date, product_name;
	END
GO

EXEC [Partitioning_DB] @num_gr = 3, @path = 'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA', @partition_func_name = 'order_part_func', @part_scheme_name = 'order_by_year_scheme'