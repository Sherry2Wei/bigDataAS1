SELECT
	A.permno A_permno,
	B.* 
FROM
	crsp.msf A
	JOIN link.ccmxpf_linktable B ON A.permno = B.lpermno 
WHERE
	A.permno IS NOT NULL 
	AND B.gvkey IS NOT NULL 
	AND A.date BETWEEN B.linkdt 
	AND B.linkenddt 
	AND B.USEDFLAG != - 1 