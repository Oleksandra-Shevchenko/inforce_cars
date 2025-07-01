from db import run_query_from_file_with_params, run_query_without_params
params = {
    "auctions": ["Copart", "IAAI"],
    "year_start": 2016,
    "year_end": 2024,
    "vehicle_type_1": "Automobiles",
    "vehicle_type_2": "SUVs",
    "make": "Honda",
    "model": "CR-V EXL",
    "sale_start": "2024-07-01",
    "sale_end": "2025-06-01",
    "vehicle_condition": None

}


top_seller = run_query_from_file_with_params("queries/top_sellers.sql", params)
print("Top sellers:", top_seller)

