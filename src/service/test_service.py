from getpass import getpass
import psycopg2
import os
from sqlalchemy import create_engine

import pandas as pd
import numpy

import time
# Check NA
def checkNA(df, col):
    # data_NA = pd.isnull(df[col])
    dfNA = df.dropna(subset=[col])
    # NA_baddata = df[data_NA]
    # return dfNA, NA_baddata
    return dfNA

# Check length
def checkLen(df, cols):
    indexs = df[df[cols].str.len()>5].index
    # len_baddata = df.loc[indexs]
    df.drop(indexs , inplace=True)
    dflen = df
    # return dflen, len_baddata
    return dflen

# Check Not Interger
def checkInt(df, select_cols):
    # select_cols = ['Height', 'Width', 'Length', 'Engine-size', 'Bore', 'Stroke', 'Price']
    notint = []
    for i in select_cols:
        if df[i].dtypes != 'int':
            notint.append(i)
    # notint_baddata = df[notint]
    dfint = df.drop(notint, axis = 1)
    # return dfint, notint_baddata
    return dfint

# Check duplicates
def checkDup(df):
    # Dup_record = df[df.duplicated()]
    dfdup = df.drop_duplicates()
    # return dfdup, Dup_record
    return dfdup

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

# Null Bad record
def Null_badrecord(df, col):
    data_NA = pd.isnull(df[col])
    NA_baddata = df[data_NA]
    return NA_baddata

# Leng Bar reacord
def Len_badrecord(df, col):
    indexs = df[df[col].str.len()>5].index
    len_baddata = df.loc[indexs]
    return len_baddata

# Not integer bad record
def Notint_badrecord(df, select_cols):
    notint = []
    for i in select_cols:
        if df[i].dtypes != 'int':
            notint.append(i)
    notint_baddata = df[notint]
    return notint_baddata
# Duplicate bad record
def Dup_badrecord(df):
    Dup_record = df[df.duplicated()]
    return Dup_record
# Good data; engine: is to connect with db to insert data by to_sql
def gooddata(df):
    #check NA
    dfNA  = checkNA(df,'Price')

    # Check length
    dflen = checkLen(dfNA,'Drive-wheels')
    
    #check not Interger
    select_cols = ['Height', 'Width', 'Length', 'Engine-size', 'Bore', 'Stroke', 'Price']
    dfint = checkInt(dflen, select_cols)
    
    #check duplicate
    dfdup = checkDup(dfint)
    #Rename
    dic = {"Fuel-type":"type", "Num-of-cylinders":"Num_cylinders"}
    dfrename = rename(dfdup, dic)
    
    # Anonimize
    gooddata = anonimize(dfrename, 'Load-date',day=1)

    # Output Good data
    return gooddata

# Bad record 
def badrecord(df):
    # Null badrecord
    col = 'Price'
    Null_badrecord = Null_badrecord(df, col)
    dfNA  = checkNA(df, col)

    # Leng badrecird
    cols = 'Drive-wheels'
    Len_badrecord = Len_badrecord(dfNA, cols)
    dflen = checkLen(dfNA, cols)
    
    # Not integer badrecord
    select_cols = ['Height', 'Width', 'Length', 'Engine-size', 'Bore', 'Stroke', 'Price']
    Notint_badrecord =Notint_badrecord(dflen, select_cols)
    dfint = checkInt(dflen, select_cols)
    
    #check duplicate
    Dup_badrecord = Dup_badrecord(dfint)

    return Null_badrecord, Len_badrecord, Notint_badrecord, Dup_badrecord

# Insert Validated data into table on postgresql
def insertdata(df, table, engine):
    df.to_sql(table, engine, if_exists = "append")

# Convert dataframe to csv and save
def save_record(df, file_name_csv):
    # String Cunrent day
    current_day = time.strftime("%Y\%m\%d\\")
    # String current time
    current_time = time.strftime("%Hh%Mm%Ss")
    # Create a new path if not exist to save file
    path = "D:\migration_data\\bad_record\\" + current_day
    if not os.path.exists(path):
        os.makedirs(path)
    # Path and file name csv to save file csv
    file_name = path + file_name_csv + "_" + current_time + ".csv"

    df.to_csv(file_name, index = False, header=True)

# Save bad record
def save_bad_record(df):
    badrecord = badrecord(df)
    NA_badrecord = badrecord[0]
    Len_badrecord = badrecord[1]
    Notint_badrecord = badrecord[2]
    Dup_badrecord = badrecord[3]
    save_record(NA_badrecord, "NA")
    save_record(Len_badrecord, "Len")
    save_record(Notint_badrecord,"NotIN")
    save_record(Dup_badrecord,"Dup")