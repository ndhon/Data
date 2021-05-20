import os
from sqlalchemy import create_engine

import pandas as pd
import time

# Check NA
def checkNA(df, col):
    try:
        data_NA = pd.isnull(df[col])
        dfNA = df.dropna(subset=[col])
        NA_baddata = df[data_NA]
        return dfNA, NA_baddata
    except TypeError as error:
        print("Cann't perform check NA")
        print("Error: "+ str(error))

# Check length
def checkLen(df, colums):
    indexs = df[df[colums].str.len()>5].index
    len_baddata = df.loc[indexs]
    df.drop(indexs , inplace=True)
    dflen = df
    return dflen, len_baddata

# Check Not Interger
def checkInt(df, select_cols):
    # select_cols = ['Height', 'Width', 'Length', 'Engine-size', 'Bore', 'Stroke', 'Price']
    notint = []
    for i in select_cols:
        if df[i].dtypes != 'int':
            notint.append(i)
    notint_baddata = df[notint]
    dfint = df.drop(notint, axis = 1)
    return dfint, notint_baddata

# Check duplicates
def checkDup(df):
    Dup_record = df[df.duplicated()]
    dfdup = df.drop_duplicates()
    return dfdup, Dup_record

# Rename
def rename(df, dict):
    dfrename = df.rename(columns=dict)
    return dfrename

# Anonimize
def anonimize(df, col, day): 
    df[col] = df[col].astype('datetime64')
    dfano = df[col].apply(lambda dt: dt.replace(day=day))
    df[col] = dfano.values
    return df


# Good data; engine: is to connect with db to insert data by to_sql
def getGooddata(df):
    #check NA
    dfNA  = checkNA(df,'Price')
    NA_baddata = dfNA[1]

    # Check length
    dflen  =checkLen(dfNA[0],'Drive-wheels')
    len_baddata =dflen[1]
    
    #check not Interger
    dfint = checkInt(dflen[0], select_cols = ['Height', 'Width', 'Length', 'Engine-size', 'Bore', 'Stroke', 'Price'])
    notint_baddata = dfint[1]
    
    #check duplicate
    dfdup = checkDup(dfint[0])
    Dup_badtata = dfdup[1]
    #Rename
    dic = {"Fuel-type":"type", "Num-of-cylinders":"Num_cylinders"}
    dfrename = rename(dfdup[0], dic)
    
    # Anonimize
    gooddata = anonimize(dfrename, 'Load-date',day=1)

    # Output Good data
    return gooddata, NA_baddata, len_baddata, notint_baddata, Dup_badtata
    
# Insert Validated data into table on postgresql
def insertdata(df, table, engine):
    df.to_sql(table, engine, if_exists = 'append')

# Convert dataframe to csv and save
def save_record(df, file_name_csv):
    # String Cunrent day
    current_day = time.strftime("%Y\%m\%d\\")
    # String current time
    current_time = time.strftime("%Hh%Mm%Ss")
    # Create a new path if not exist to save file
    path = "D:\Projects\migration_data\\bad_record\\" + current_day
    if not os.path.exists(path):
        os.makedirs(path)
    # Path and file name csv to save file csv
    file_name = path + file_name_csv + "_" + current_time + ".csv"

    df.to_csv(file_name, index = False, header=True)

# Save bad record
def save_bad_record(df):
    # Select bad record
    badrecord = getGooddata(df)
    NA_badrecord = badrecord[1]
    Len_badrecord = badrecord[2]
    Notint_badrecord = badrecord[3]
    Dup_badrecord = badrecord[4]
    save_record(NA_badrecord, "NA")
    save_record(Len_badrecord, "Len")
    save_record(Notint_badrecord,"NotIN")
    save_record(Dup_badrecord,"Dup") 