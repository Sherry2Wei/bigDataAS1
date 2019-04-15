SELECT
	* 
FROM
	comp.g_funda 
	LIMIT 500;
SELECT
	* 
FROM
	comp.funda 
	LIMIT 500;
SELECT
	SUBSTRING( cusip, 0, 8 ) 
FROM
	com.g_funda 
	LIMIT 100;
CREATE TABLE Y_stock_listed AS SELECT YEAR
,
permno,
COUNT( * ) AS count_YS 
FROM
	msf_shrcd_use 
WHERE
	ret IS NOT NULL 
	AND shrcd IS NOT NULL 
GROUP BY
	YEAR,
	permno;
SELECT YEAR
	,
	COUNT( * ) AS count_stockPerYear 
FROM
	Y_stock_listed 
GROUP BY
YEAR 
ORDER BY
	count_stockPerYear;
SELECT
	permno,
	YEAR,
	COUNT( * ) 
FROM
	msf_shrcd_use GROUP BYYEAR;

HAVING
	COUNT( * ) = 1;
CREATE TABLE msf_use_removeDup AS 
HAVING
	COUNT( * ) = 1;
SELECT YEAR
	,
	COUNT( * ) 
FROM
	msf_use_removeDup SHOW TABLES IN temp_u3554218;
SELECT YEAR
	,
	permno,
	COUNT( * ) 
FROM
	msf_shrcd_use 
WHERE
	ret IS NOT NULL 
	AND shrcd IS NOT NULL 
GROUP BY
	YEAR,
	permno 
	LIMIT 5;
SELECT
	* 
FROM
	msf_shrcd_use 
WHERE
	YEAR = 1997;
SELECT
	a.permno,
	a.altprcdt,
	a.prc,
	a.shrout,
	a.ret,
	a.retx,
	b.shrcd,
	b.namedt,
	b.nameendt 
FROM
	crsp.msf a
	JOIN dsenames b ON a.permno = b.permno 
	LIMIT 5;
SELECT
	a.price,
	b.A 
FROM
	aTable a
	JOIN bTable b ON a.price = b.price