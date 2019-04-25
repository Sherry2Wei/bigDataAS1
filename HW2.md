### 1.A.I Check the amount of space this table occupies either in HeidiSQL or using the code in Lecture 4

#### Input: temp_hochon.msf_copy

#### Code:

```sql
SELECT
	table_name AS Table_Name,
	round( data_length / power( 1024, 3 ), 2 ) AS Data_Length_GB,
	round( ( data_length + index_length ) / power( 1024, 3 ), 3 ) AS Table_Size_GB 
FROM
	information_schema.TABLES 
WHERE
	table_schema = "temp_hochon";
```

#### Result:

| Table_Name | Data_Length_GB | Table_Size_GB |
| ---------- | -------------- | ------------- |
| msf_copy   | 0.67           | 0.674         |

### 1.A.II Show me the EXPLAIN of select count(*) from ___ GROUP BY PERMNO.

#### Input: temp_hochon.msf_copy

#### Code:

```sql
SELECT
	permno AS Permno,
	count( * ) AS Count_By_Each_Permno 
FROM
	temp_hochon.msf_copy 
GROUP BY
	( permno );

```

#### Part of Result:

| Permno | Count_By_Each_Permno |
| ------ | -------------------- |
| 10000  | 19                   |
| 10001  | 381                  |
| 10002  | 327                  |
| 10003  | 121                  |
| 10005  | 68                   |
| 10006  | 703                  |
| 10007  | 59                   |
| 10008  | 36                   |
| 10009  | 180                  |
| 10010  | 117                  |

### 1.A.III Record how long it takes to run the statement.

#### Time: 6.082s

### 1.B.I Run the ALTER TABLE command to add a primary key on PERMNO, date. Now check the space again.

#### Input: temp_hochon.msf_copy

#### Code:

```sql
ALTER TABLE temp_hochon.msf_copy ADD PRIMARY KEY ( permno, date );
SELECT
	table_name AS Table_Name,
	round( data_length / power( 1024, 3 ), 2 ) AS Data_Length_GB,
	round( ( data_length + index_length ) / power( 1024, 3 ), 3 ) AS Table_Size_GB 
FROM
	information_schema.TABLES 
WHERE
	table_schema = "temp_hochon";
```

#### Result:

| Table_Name | Data_Length_GB | Table_Size_GB |
| ---------- | -------------- | ------------- |
| msf_copy   | 0.74           | 0.738         |

### 1.B.II Show me the EXPLAIN of select count(*) from ___ GROUP BY PERMNO

#### Input: temp_hochon.msf_copy

#### Code:

```sql
SELECT
	permno AS Permno,
	count( * ) AS Count_By_Each_Permno 
FROM
	temp_hochon.msf_copy 
GROUP BY
	( permno );
```

#### Part of Result:

| Permno | Count_By_Each_Permno |
| ------ | -------------------- |
| 10000  | 19                   |
| 10001  | 381                  |
| 10002  | 327                  |
| 10003  | 121                  |
| 10005  | 68                   |
| 10006  | 703                  |
| 10007  | 59                   |
| 10008  | 36                   |
| 10009  | 180                  |
| 10010  | 117                  |

### 1.B.III Record how long it takes to run the statement.

#### Time: 4.897s

### 1.C Was the second query faster? Why?

##### By adding a primary key on the msf_copy table, the table data is physically organized to do a fast look up and the table is sorted based on the primary key column instead of scanning the whole table and find the corresponding permno. Thus, the second query should be faster than the first query.

### 2. Please shorten the following fields to the minimum required:** *CUSIP, PERMNO, COMNAM, TICKER, NCUSIP, RET and “annual” variables.
#### Input: temp_hochon.craptable

##### First find out the maxium of each required columns #####

#### Code:

```sql
SELECT
	max( length( comnam ) ),
	max( length( ticker ) ),
	max( ret ),
	max( length( cusip ) ),
	max( length( permno ) ),
	max( length( ncusip ) ),
	max( annual_age_approx ),
	max( annual_ni_at ),
	max( annual_debt_at ),
	max( annual_research_at ),
	max( annual_tangibility ),
	max( annual_tobinsq ),
	max( annual_log_asset ),
	max( annual_capx_at ) 
FROM
	temp_hochon.craptable;
```

#### Result:

| max(length(comnam)) | max(length(ticker)) | max(ret) | max(length(cusip)) | max(length(permno)) | max(length(ncusip)) | max(annual_age_approx) | max(annual_ni_at) | max(annual_debt_at) | max(annual_research_at) | max(annual_tangibility) | max(annual_tobinsq) | max(annual_log_asset) | max(annual_capx_at) |
| ------------------- | ------------------- | -------- | ------------------ | ------------------- | ------------------- | ---------------------- | ----------------- | ------------------- | ----------------------- | ----------------------- | ------------------- | --------------------- | ------------------- |
| 32                  | 5                   | 15.98446 | 8                  | 5                   | 8                   | 100.5                  | 0.360802          | 3.202515            | 0.783586                | 0.988689                | 66.90146            | 14.77197              | 0.473542            |

##### Change data type base on the maximum value of each column

#### Code:

```sql
ALTER TABLE temp_hochon.craptable_after MODIFY COLUMN cusip VARCHAR ( 8 ),
MODIFY COLUMN permno MEDIUMINT,
MODIFY COLUMN comnam VARCHAR ( 32 ),
MODIFY COLUMN ticker VARCHAR ( 5 ),
MODIFY COLUMN ncusip VARCHAR ( 8 ),
MODIFY COLUMN ret DECIMAL ( 12, 10 ),
MODIFY COLUMN annual_age_approx DECIMAL ( 6, 3 ),
MODIFY COLUMN annual_ni_at DECIMAL ( 10, 9 ),
MODIFY COLUMN annual_debt_at DECIMAL ( 10, 9 ),
MODIFY COLUMN annual_research_at DECIMAL ( 9, 8 ),
MODIFY COLUMN annual_tangibility DECIMAL ( 8, 7 ),
MODIFY COLUMN annual_tobinsq DECIMAL ( 12, 10 ),
MODIFY COLUMN annual_log_asset DECIMAL ( 12, 10 ),
MODIFY COLUMN annual_capx_at DECIMAL ( 9, 8 );
```

##### Check if there are any data lose on columns after changing the data type

#### Code:

```sql
SELECT
	avg( length( a.cusip ) - length( b.cusip ) ) AS Average_Length_Diff_Cusip,
	avg( length( a.comnam ) - length( b.comnam ) ) AS Average_Length_Diff_Comnam,
	avg( length( a.ticker ) - length( b.ticker ) ) AS Average_Length_Diff_Ticker,
	avg( length( a.ncusip ) - length( b.ncusip ) ) AS Average_length_Diff_Ncusip,
	avg( a.permno - b.permno ) AS Average_Diff_Permno,
	avg( a.ret - b.ret ) AS Average_Diff_Ret,
	avg( a.annual_age_approx - b.annual_age_approx ) AS Average_Diff_Age,
	avg( a.annual_ni_at - b.annual_ni_at ) AS Average_Diff_Ni,
	avg( a.annual_debt_at - b.annual_debt_at ) AS Average_Diff_Debt,
	avg( a.annual_research_at - b.annual_research_at ) AS Average_Diff_Rearch,
	avg( a.annual_tangibility - b.annual_tangibility ) AS Average_Diff_Tangibility,
	avg( a.annual_tobinsq - b.annual_tobinsq ) AS Average_Diff_Tobinsq,
	avg( a.annual_log_asset - b.annual_log_asset ) AS Average_Diff_Log,
	avg( a.annual_capx_at - b.annual_capx_at ) AS Average_Diff_Capx 
FROM
	temp_hochon.craptable AS a
	INNER JOIN temp_hochon.craptable_after AS b ON a.permno = b.permno 
	AND a.date = b.date;
```

#### Result:

| Average_Length_Diff_Cusip | Average_Length_Diff_Comnam | Average_Length_Diff_Ticker | Average_length_Diff_Ncusip | Average_Diff_Permno | Average_Diff_Ret | Average_Diff_Age | Average_Diff_Ni | Average_Diff_Debt | Average_Diff_Rearch | Average_Diff_Tangibility | Average_Diff_Tobinsq | Average_Diff_Log | Average_Diff_Capx |
| ------------------------- | -------------------------- | -------------------------- | -------------------------- | ------------------- | ---------------- | ---------------- | --------------- | ----------------- | ------------------- | ------------------------ | -------------------- | ---------------- | ----------------- |
| 0                         | 0                          | 0                          | 0                          | 0                   | 0                | 0                | 0               | 0                 | 0                   | 0                        | 0                    | 0                | 0                 |

##### Compare data length and table size after the change on data type on each column

#### Code:

```sql
SELECT
	table_name AS Table_Name,
	round( data_length / power( 1024, 3 ), 2 ) AS Data_Length_GB,
	round( ( data_length + index_length ) / power( 1024, 3 ), 3 ) AS Table_Size_GB 
FROM
	information_schema.TABLES 
WHERE
	table_schema = "temp_hochon" 
	AND table_name IN ( "craptable", "craptable_after" );
```

#### Result:

| Table_Name      | Data_Length_GB | Table_Size_GB |
| --------------- | -------------- | ------------- |
| craptable       | 0.07           | 0.067         |
| craptable_after | 0.05           | 0.052         |

```

```





