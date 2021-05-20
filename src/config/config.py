import psycopg2

from sqlalchemy import create_engine
# Setup a connect into MySQL
def Engine():
    try:
        host="localhost"
        user="postgres"
        password="345641x@X"
        database="postgres"
        port="5432"
        Engine = create_engine('postgresql://{user}:{password}@{host}:{port}/{database}'.format(user=user, password=password, host=host, 
                                                             port=port,database=database ))
        print("Database opened successfully")
        return Engine
    except Exception as error:
        print("Try to connection have a error: " + error)
    
    

