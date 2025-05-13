-- Active: 1747165843818@@pg_db@5432@dwhsliver@public

-- just take like a test example for customer information
SELECT 
ROW_NUMBER() OVER(PARTITION BY crm.cst_id ORDER BY crm.cst_create_date DESC ) as rn,
crm.cst_id,
crm.vst_key as cst_key,
crm.cst_firstname,
crm.cst_lastname , 
crm.cst_gndr, 
crm.cst_marital_status, 
crm.cst_create_date 
FROM public.cust_info as crm ;


-- check about the replica and redandancy 
SELECT crm.cst_id , COUNT(*)  FROM public.cust_info as crm GROUP BY 1 HAVING COUNT(*) > 1 OR crm.cst_id IS NULL ;

SELECT crm.vst_key  , (SELECT COUNT(1) FROM cust_info) FROM public.cust_info as crm WHERE crm.vst_key  NOT LIKE 'AW%' ;

SELECT crm.vst_key  , COUNT(*) FROM public.cust_info as crm WHERE crm.vst_key  NOT LIKE 'AW%' GROUP BY 1 ;


SELECT DISTINCT crm.cst_gndr FROM public.cust_info as crm ;
SELECT DISTINCT crm.cst_marital_status FROM public.cust_info as crm ;



SELECT *
FROM (
    SELECT 
        ROW_NUMBER() OVER(PARTITION BY crm.cst_id ORDER BY crm.cst_create_date DESC ) as rn,
        crm.cst_id,
    CASE
        WHEN crm.vst_key NOT LIKE 'AW%' THEN 'N/A'
        ELSE crm.vst_key
    END AS cst_key ,
        UPPER(TRIM(BOTH ' ' FROM crm.cst_firstname)) as cst_first_name,
        UPPER(TRIM(BOTH ' ' FROM crm.cst_lastname)) as cst_last_name, 
    CASE UPPER(TRIM(crm.cst_gndr)) 
        WHEN 'M' THEN 'MALE'
        WHEN 'F' THEN 'FEMALE'
        ELSE 'N/A'
    END AS cst_gndr,
    CASE UPPER(TRIM( crm.cst_marital_status)) 
        WHEN 'S' THEN 'SINGLE'
        WHEN 'F' THEN 'MARRIED'
        ELSE 'NONE'
    END AS cst_marital_status
       , 
        CAST(crm.cst_create_date AS DATE) 
    FROM public.cust_info as crm 
)t
WHERE t.rn = 1 AND t.cst_create_date IS NOT NULL;
