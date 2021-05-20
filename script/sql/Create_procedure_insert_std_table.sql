--  Create procedure to insert data into subtable
CREATE OR REPLACE PROCEDURE insert_satelline_tb( )
LANGUAGE plpgsql
AS $$
BEGIN
	INSERT INTO symboling ("symboling")
    (SELECT DISTINCT "Symboling" FROM car GROUP BY 1)
	ON CONFLICT (symboling) 
	DO NOTHING;
	
	INSERT INTO make ("make")
	(SELECT DISTINCT "Make" FROM car)
	ON CONFLICT (make) 
	DO NOTHING;
	
	INSERT INTO type ("type")
	(SELECT DISTINCT "type" FROM car)
	ON CONFLICT (type) 
	DO NOTHING;
	INSERT INTO aspiration ("aspiration")
	(SELECT DISTINCT "Aspiration" FROM car)
	ON CONFLICT (aspiration) 
	DO NOTHING;

	INSERT INTO num_of_doors ("num_of_doors")
	(SELECT DISTINCT "Num-of-doors" FROM car)
	ON CONFLICT (num_of_doors) 
	DO NOTHING;

	INSERT INTO body_style ("body_style")
	(SELECT DISTINCT "Body-style" FROM car)
	ON CONFLICT (body_style) 
	DO NOTHING;

	INSERT INTO drive_wheels ("drive_wheels")
	(SELECT DISTINCT "Drive-wheels" FROM car)
	ON CONFLICT (drive_wheels) 
	DO NOTHING;

	INSERT INTO engine_location ("engine_location")
	(SELECT DISTINCT "Engine-location" FROM car)
	ON CONFLICT (engine_location) 
	DO NOTHING;

	INSERT INTO engine_type ("engine_type")
	(SELECT DISTINCT "Engine-type" FROM car)
	ON CONFLICT (engine_type) 
	DO NOTHING;

	INSERT INTO num_cylinders ("num_cylinders")
	(SELECT DISTINCT "Num_cylinders" FROM car)
	ON CONFLICT (num_cylinders) 
	DO NOTHING;

	INSERT INTO fuel_system ("fuel_system")
	(SELECT DISTINCT "Fuel-system" FROM car)
	ON CONFLICT (fuel_system) 
	DO NOTHING;

END;
$$;

--  Insert standardized data from native tb into std table
CREATE OR REPLACE PROCEDURE insert_std_tb( )
LANGUAGE plpgsql
AS $$
BEGIN
	INSERT INTO std_car("No"
						,"id_symboling"
						,"normalized_losses"
						,"id_make"
						,"id_type"
						,"id_aspiration" 
						,"id_num_of_doors"
						,"id_body_style"
						,"id_drive_wheels"
						,"id_engine_location"
						,"wheel_base"
						,"curb_weight"
						,"id_engine_type"
						,"id_num_cylinders" 
						,"id_fuel_system"
						,"compression_ratio"
						,"horsepower"
						,"peak_rpm"
						,"city_mpg"
						,"highway_mpg"
						,"load_date")
		(SELECT	ca."No"
		 		,sy."id"
		 		,ca."Normalized-losses"
		 		,ma."id"
		 		,ty."id"
				,asp."id"
				,nu."id"
				,bo."id"
				,dr."id"
				,el."id"
		 		,ca."Wheel-base"
				,ca."Curb-weight"
				,et."id"
				,nc."id"
				,fu."id"
				,ca."Compression-ratio"
				,ca."Horsepower"
				,ca."peak-rpm"
				,ca."city-mpg"
				,ca."highway-mpg"
				,ca."Load-date"
		FROM PUBLIC.car ca
		JOIN PUBLIC.symboling sy ON ca."Symboling" = sy."symboling"
		JOIN PUBLIC.make ma ON ca."Make" = ma."make"
		JOIN PUBLIC.type ty ON ca."type" = ty."type"
		JOIN PUBLIC.aspiration asp ON ca."Aspiration" = asp."aspiration"
		JOIN PUBLIC.num_of_doors nu ON ca."Num-of-doors" = nu."num_of_doors"
		JOIN PUBLIC.body_style bo ON ca."Body-style" = bo."body_style"
		JOIN PUBLIC.drive_wheels dr ON ca."Drive-wheels" = dr."drive_wheels"
		JOIN PUBLIC.engine_location el ON ca."Engine-location" = el."engine_location"
		JOIN PUBLIC.engine_type et ON ca."Engine-type" = et."engine_type"
		JOIN PUBLIC.num_cylinders nc ON ca."Num_cylinders" = nc."num_cylinders"
		JOIN PUBLIC.fuel_system fu ON ca."Fuel-system" = fu."fuel_system"
		)
	ON CONFLICT	("No") 
	DO NOTHING;
END;
$$;

-- Function to insert data into subtable
CREATE OR REPLACE FUNCTION Upload_data() 
   RETURNS TRIGGER 
   LANGUAGE PLPGSQL
AS $$
BEGIN
	CALL insert_satelline_tb();
	CALL insert_std_tb();
	RETURN NEW;
END;
$$;
-- Auto trigger into subtable AFTER Insert
DROP TRIGGER IF EXISTS car_trigger ON car;
CREATE TRIGGER car_trigger
  AFTER INSERT
  ON car
  FOR EACH STATEMENT
  EXECUTE PROCEDURE Upload_data();
  
