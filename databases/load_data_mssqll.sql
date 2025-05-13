CREATE DATABASE Dwhtest ;
GO ;
USE Dwhtest ;
GO
-- take the data from raw model into logical model , describe the data for reporting 
-- dynamic table when have any modification for this tables attribute
CREATE OR ALTER PROCEDURE dwh_load AS
BEGIN
        DECLARE @start_begin_time DATETIME ;
        DECLARE @end_begin_time DATETIME;
    BEGIN TRY
        SET @start_begin_time = GETDATE() ;
        PRINT 'NOW LOAD THE DATA FROM CSV INTO MY TABLES' ;
        IF OBJECT_ID('product_info' , 'U') IS NOT NULL 
        DROP TABLE IF EXISTS product_info ; 
        PRINT '#####################################################' ;
        PRINT 'LOAD THE DATA FROM CSV INTO PRODUCT_INFO TABLE' ;
        CREATE TABLE product_info(
            prd_id INT  , 
            prd_key nvarchar(50), 
            prd_nm nvarchar(50) ,
            prd_cost INT , 
            prd_line nvarchar(20) ,
            prd_start_dt DATE ,
            prd_end_dt DATE 
        );
        BULK INSERT product_info 
        FROM '/usr/datasets/source_crm/prd_info.csv'
        WITH(
            FIRSTROW = 2 ,
            FIELDTERMINATOR = ',' ,
            TABLOCK
        );

       

        IF OBJECT_ID('cust_gen') IS NOT NULL 
        DROP TABLE IF EXISTS cust_gen ;
        CREATE TABLE cust_gen(
            CID nvarchar(30) , 
            BDATE DATE ,
            GEN nvarchar(20)
        );

        BULK INSERT cust_gen
        FROM '/usr/datasets/source_erp/CUST_AZ12.csv'
        WITH(
            FIRSTROW = 2 ,
            FIELDTERMINATOR = ',' ,
            TABLOCK
        );

        

        SET @end_begin_time  = GETDATE() ;

        PRINT 'THE TIME DIFFERENCE BETWEEN START DATE AND END DATE ' + CAST(DATEDIFF(second,@start_begin_time ,@end_begin_time ) AS NVARCHAR)+ 'seconds';
    END TRY
    BEGIN CATCH
        PRINT 'THE ERROR MESSAGE' + ERROR_MESSAGE() ;
    END CATCH
END

EXEC dbo.dwh_load ;

SELECT * FROM dbo.cust_gen ;
SELECT * FROM dbo.product_info ;