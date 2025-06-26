from db import run_query_from_file_with_params, run_query_without_params

params = {
    "auction_Copart": None,
    "auction_IAAI": "IAAI",
    "year_start": 2015,
    "year_end": 2022,
    "vehicle_type_1": "SUV",
    "vehicle_type_2": None,
    "make": "Toyota",
    "model": None,
    "sale_start": None,
    "sale_end": None,
    "vehicle_condition": None
}

top_seller = run_query_from_file_with_params("queries/top_sellers.sql", params)
all_sellers = run_query_without_params("queries/all.sql")
# print("Top sellers:", top_seller)
# print("All sellers:", all_sellers)

