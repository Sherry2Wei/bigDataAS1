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

### ·        
### 3. Based on what you created above, please normalize the table into a few new tables. Please place keys where appropriate.

#### Input: temp_hochon.craptable

##### Create sub tables from the craptable.

#### Code:

```mysql
CREATE TABLE temp_hochon.main_table AS SELECT
Date,
Permno,
ret,
bidlo,
askhi,
prc,
vol,
retx,
row_names,
YEAR 
FROM
	temp_hochon.craptable;
CREATE TABLE temp_hochon.annual AS SELECT DISTINCT
gvkey,
YEAR,
datadate,
annual_age_approx,
annual_ni_at,
annual_debt_at,
annual_research_at,
annual_tangibility,
annual_tobinsq,
annual_log_asset,
annual_capx_at 
FROM
	temp_hochon.craptable;
CREATE TABLE temp_hochon.company AS SELECT DISTINCT
Permno,
Cusip,
comnam,
hexcd,
hsiccd,
ticker,
shrcd,
ncusip,
tsymbol 
FROM
	temp_hochon.craptable;
CREATE TABLE temp_hochon.gvkey AS SELECT DISTINCT
date,
permno,
gvkey 
FROM
	temp_hochon.craptable;
```

### 3.I Please draw a schema diagram.

![1556364783729](C:\Users\sherrywei\AppData\Roaming\Typora\typora-user-images\1556364783729.png)

### 3.II how many space do you have



### 3. III Show me that inner join statement that recovers the original table It must produce the same # of rows.

#### Input: temp_hochon.main_table, temp_hochon.company, temp_hochon.gvkey, temp_hochon.annual.

#### Code: 

```mysql
SELECT
	count( * ) AS Recover_Count 
FROM
	temp_hochon.main_table AS a
	INNER JOIN temp_hochon.company AS b
	INNER JOIN temp_hochon.gvkey AS c
	INNER JOIN temp_hochon.annual AS d ON a.permno = b.permno 
	AND a.date = c.date 
	AND a.permno = c.permno 
	AND a.YEAR = d.YEAR 
	AND c.gvkey = d.gvkey;
SELECT
	count( * ) AS Original_Count 
FROM
	temp_hochon.craptable;
```

#### Result:

| Orignal_Count | Recover_Count |
| ------------- | ------------- |
| 164784        | 164784        |



### 3.IV Show me the table structure (SHOW CREATE TABLE) of the
four new tables.

#### Input: temp_hochon.main_table, temp_hochon.company, temp_hochon.gvkey, temp_hochon.annual.

#### Code:

```mysql
SHOW CREATE TABLE temp_hochon.main_table;
SHOW CREATE TABLE temp_hochon.company;
SHOW CREATE TABLE temp_hochon.gvkey;
SHOW CREATE TABLE temp_hochon.annual;
```

#### Result:

| Table      | Create Table                                                 |
| ---------- | ------------------------------------------------------------ |
| main_table | CREATE TABLE `main_table` (<br/>  `Date` date NOT NULL,<br/>  `Permno` bigint(20) NOT NULL,<br/>  `ret` decimal(17,10) DEFAULT NULL,<br/>  `bidlo` decimal(65,10) DEFAULT NULL,<br/>  `askhi` decimal(65,10) DEFAULT NULL,<br/>  `prc` decimal(65,10) DEFAULT NULL,<br/>  `vol` decimal(42,3) DEFAULT NULL,<br/>  `retx` double DEFAULT NULL,<br/>  `row_names` text,<br/>  `year` double NOT NULL,<br/>  PRIMARY KEY (`year`,`Date`,`Permno`)<br/>) ENGINE=InnoDB DEFAULT CHARSET=latin1 |

| Table   | Create Table                                                 |
| ------- | ------------------------------------------------------------ |
| company | CREATE TABLE `company` (<br/>  `Permno` bigint(20) NOT NULL,<br/>  `Cusip` text,<br/>  `comnam` varchar(198) DEFAULT NULL,<br/>  `hexcd` varchar(256) DEFAULT NULL,<br/>  `hsiccd` decimal(12,3) DEFAULT NULL,<br/>  `ticker` varchar(260) DEFAULT NULL,<br/>  `shrcd` decimal(51,3) DEFAULT NULL,<br/>  `ncusip` varchar(234) DEFAULT NULL,<br/>  `tsymbol` varchar(243) DEFAULT NULL,<br/>  PRIMARY KEY (`Permno`)<br/>) ENGINE=InnoDB DEFAULT CHARSET=latin1 |

| Table | Create Table                                                 |
| ----- | ------------------------------------------------------------ |
| gvkey | CREATE TABLE `gvkey` (<br/>  `date` date NOT NULL,<br/>  `permno` bigint(20) NOT NULL,<br/>  `gvkey` bigint(20) DEFAULT NULL,<br/>  PRIMARY KEY (`date`,`permno`)<br/>) ENGINE=InnoDB DEFAULT CHARSET=latin1" |

| Table  | Create Table                                                 |
| ------ | ------------------------------------------------------------ |
| annual | CREATE TABLE `annual` (<br/>  `gvkey` bigint(20) NOT NULL,<br/>  `year` double NOT NULL,<br/>  `datadate` text,<br/>  `annual_age_approx` decimal(41,3) DEFAULT NULL,<br/>  `annual_ni_at` decimal(41,9) DEFAULT NULL,<br/>  `annual_debt_at` decimal(43,9) DEFAULT NULL,<br/>  `annual_research_at` decimal(44,8) DEFAULT NULL,<br/>  `annual_tangibility` decimal(43,7) DEFAULT NULL,<br/>  `annual_tobinsq` decimal(42,10) DEFAULT NULL,<br/>  `annual_log_asset` decimal(41,10) DEFAULT NULL,<br/>  `annual_capx_at` decimal(14,8) DEFAULT NULL,<br/>  PRIMARY KEY (`year`,`gvkey`)<br/>) ENGINE=InnoDB DEFAULT CHARSET=latin1 |

### 4. Create a copy of crsp.dsf in a SQLite, MonetDBLite, or Apache Drill database

o   This is a really, really big table

o   You are well-advised to do a streaming read or to write a loop that iterates on crsp.dsf by date or permno

o   At the end, verify you have the same number of observations, unique dates, unique firms, and (roughly) sum(round(ret,5))

#### input: crsp.dsf

#### code:

```python
import numpy as np
import MySQLdb as mdb
import pandas as pd

conn= mdb.connect(
        host='178.128.52.12',
        port = 3306,
        user='u3554218',
        passwd='3035542186',
        db ='crsp',
        )

cur = conn.cursor()

cur.execute('explain crsp.dsf')
columns = pd.DataFrame(np.array(cur.fetchall()))[0].tolist()

cur.execute('select distinct permno from crsp.dsf')
permnos = cur.fetchall()

cur.execute('SELECT * from crsp.dsf where permno = ' + str(list(permnos[0])[0]))
results = np.array(cur.fetchall())

from tqdm import tqdm

for permno in tqdm(permnos[1:10]):
    try:
        cur.execute('SELECT * from crsp.dsf where permno = ' + str(list(permno)[0]))
        result = np.array(cur.fetchall())
        results = np.concatenate((results,result),axis = 0)
    except:
        print(permno)
        
dsf_copy = pd.DataFrame(results,columns = columns)

dsf_copy.head(5)
```

#### output：

| date_sas | cusip |   permno | permco | issuno | hexcd | hsiccd | bidlo |        askhi |          prc |           ... |  ret |           bid |  ask | shrout | cfacpr |  cfacshr |  openprc | numtrd | retx |          date |            |
| -------: | ----: | -------: | -----: | -----: | ----: | -----: | ----: | -----------: | -----------: | ------------: | ---: | ------------: | ---: | -----: | -----: | -------: | -------: | -----: | ---: | ------------: | ---------- |
|        0 |  9503 | 68391610 |  10000 |   7952 | 10396 |      3 |  3990 | 2.3750000000 | 2.7500000000 | -2.5625000000 |  ... |          None | None |   None |   3680 | 1.000000 | 1.000000 |   None | None |          None | 1986-01-07 |
|        1 |  9504 | 68391610 |  10000 |   7952 | 10396 |      3 |  3990 | 2.3750000000 | 2.6250000000 | -2.5000000000 |  ... | -0.0243902430 | None |   None |   3680 | 1.000000 | 1.000000 |   None | None | -0.0243902430 | 1986-01-08 |
|        2 |  9505 | 68391610 |  10000 |   7952 | 10396 |      3 |  3990 | 2.3750000000 | 2.6250000000 | -2.5000000000 |  ... |         0E-10 | None |   None |   3680 | 1.000000 | 1.000000 |   None | None |         0E-10 | 1986-01-09 |
|        3 |  9506 | 68391610 |  10000 |   7952 | 10396 |      3 |  3990 | 2.3750000000 | 2.6250000000 | -2.5000000000 |  ... |         0E-10 | None |   None |   3680 | 1.000000 | 1.000000 |   None | None |         0E-10 | 1986-01-10 |
|        4 |  9509 | 68391610 |  10000 |   7952 | 10396 |      3 |  3990 | 2.5000000000 | 2.7500000000 | -2.6250000000 |  ... |  0.0500000007 | None |   None |   3680 | 1.000000 | 1.000000 |   None | None |  0.0500000007 | 1986-01-13 |
|        5 |  9510 | 68391610 |  10000 |   7952 | 10396 |      3 |  3990 | 2.6250000000 | 2.8750000000 | -2.7500000000 |  ... |  0.0476190485 | None |   None |   3680 | 1.000000 |          |        |      |               |            |

```python
df_ret = dsf_copy[['ret']].dropna()
df_ret['ret'] = df_ret.astype(float)
round(df_ret,5).sum()
```

#### output : 27.144171

```python
import sqlite3
con = sqlite3.connect('example.db')
from pandas.io import sql
dsf_copy.to_sql(con = con, name = 'dsf_copy')
```

