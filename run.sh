docker build -t inject_data:v001 .

url="https://github.com/DataTalksClub/nyc-tlc-data/releases/download/green/green_tripdata_2019-10.csv.gz"


# loading data
# docker run --network 2_docker_sql_pg-network \
#   inject_data:v001 \
#   --user postgres \
#   --password postgres \
#   --host db \
#   --port 5432 \
#   --db ny_taxi \
#   --table_name green_trip_data \
#   --url ${url} 

# cheking pip version
docker run -it \
    inject_data:v001 \
    /bin/bash



