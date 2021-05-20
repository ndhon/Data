from flask import Flask, config
from flask_cors import CORS, cross_origin
from flask import request
from flask_restful import Resource
import pandas as pd

import sys
sys.path.append('..\config')
from config import Engine
sys.path.append('..\service')
from service import getGooddata, insertdata, save_bad_record
# from config.config import engine

#Khoi tao Flask Server BE
app = Flask(__name__)

#apply Flask CORS
CORS(app)
app.config['CORS_HEADERS'] = 'Content_Type'

# Output data
@app.route('/post',methods=['POST'])
@cross_origin(origin='*')

def post():

    try:
        file = request.files.get('file')
        df = pd.read_csv(file)
        
        # Good data after process df: dataframe,
        result = getGooddata(df)
        
        # Insert Validated data into table on postgresql
        insertdata(df = result[0], table = 'car', engine = Engine())

        # Save bad record
        save_bad_record(df)

        return {
            "message" : "ok",
            "status" : 200,
            "data" : result[0].to_dict()
        }
    except TypeError as error:
        print("Cann't perform post method")
        print("Have a error: " + str(error))
        




#Star BE
if __name__=='__main__':

    app.run(host='0.0.0.0', port =  3000, debug=True)