import duckdb

con = duckdb.connect("db/unit-1-4-assignment.db")

# download csv file with the name "Resale flat prices based on registration date from Jan-2017 onwards"
# from the data.gov.sg website
# https://beta.data.gov.sg/datasets/189/resources/d_8b84c4ee58e3cfc0ece0d773c8ca6abc/view
# then store the file (ResaleflatpricesbasedonregistrationdatefromJan2017onwards.csv) in this folder

con.sql(
    "CREATE TABLE resale_flat_prices_2017 AS SELECT * FROM read_csv_auto('db/ResaleflatpricesbasedonregistrationdatefromJan2017onwards.csv', HEADER=TRUE);"
)
