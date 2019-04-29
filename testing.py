import time
import mysql.connector as msc
import pandas as pd
import os
from multiprocessing import Pool
os.chdir(r"c:\Users\ChonWai\Desktop\big_data")


def querypermno(permno):
    con = msc.connect(
        host='178.128.52.12',
        port=3306,
        user='hochon',
        passwd='3035543025',
        db='crsp',
    )
    curs = con.cursor()
    curs.execute("select * from crsp.dsf " +
                 "where permno = " + str(permno))
    result = curs.fetchall()
    return result


if __name__ == '__main__':
    start_time = time.time()
    results = []
    conn = msc.connect(
        host='178.128.52.12',
        port=3306,
        user='hochon',
        passwd='3035543025',
        db='crsp',
    )
    cur = conn.cursor()
    cur.execute("select distinct permno from crsp.dsf")
    permnos = [i[0] for i in cur.fetchall()]
    cur.execute("explain crsp.dsf")
    column = [i[0] for i in cur.fetchall()]
    p = Pool(processes=7)
    data = p.map(querypermno, permnos)
    print("done")
    for permno_list in data:
        for row in permno_list:
            results.append(row)
    df = pd.DataFrame(results, columns=column)
    df.to_csv("bigdata_question4.csv", index=False)
    print(df)
    print("--- %s seconds ---" % (time.time() - start_time))




















