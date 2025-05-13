-- Active: 1746980537093@@mysql_db@3306@mysql
CREATE DATABASE DWH_Test ;
USE DWH_Test ;

-- Now with using medllian architecture to create data management for bronz layer create data ingestion 
-- using snake_case 
DROP TABLE IF EXISTS cust_info ;
CREATE TABLE IF NOT EXISTS cust_info (
    cst_id varchar(20) ,
    vst_key varchar(30) , 
    cst_firstname varchar(30) , 
    cst_lastname varchar(30) , 
    cst_marital_status varchar(30) ,
    cst_gndr varchar(20) ,
    cst_create_date varchar(20)
);

TABLE cust_info ;
SHOW VARIABLES LIKE 'local_infile';
-- now load the data from customer_information in csv files 
LOAD DATA INFILE '/usr/datasets/source_crm/cust_info.csv'
INTO TABLE cust_info
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS ;


SELECT * FROM cust_info ;


-- load the sales inforamtion in mysql rdbms 
DROP TABLE IF EXISTS sales_details ;
CREATE TABLE IF NOT EXISTS sales_details(
    sls_ord_num varchar(30) ,
    sls_prd_key varchar(30) , 
    sls_cust_id varchar(20) ,
    sls_order_dt INT ,
    sls_ship_dt INT , 
    sls_due_dt INT  , 
    sls_sales VARCHAR(20)  ,
    sls_quantity INT  , 
    sls_price varchar(20)

);

LOAD DATA INFILE '/usr/datasets/source_crm/sales_details.csv'
INTO TABLE sales_details
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS ;

SELECT * FROM sales_details ;