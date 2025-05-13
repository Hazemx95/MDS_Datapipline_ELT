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
    FROM {{source('sliver_data', 'cust_info')}}as crm 
)t
WHERE t.rn = 1 AND t.cst_create_date IS NOT NULL
