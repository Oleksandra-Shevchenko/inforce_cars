from typing import Sequence

from sqlalchemy import create_engine, text, RowMapping


def run_query_from_file_with_params(file_path: str, params: dict) -> list[dict]:
    with open(file_path, "r") as f:
        query = f.read()

    engine = create_engine(
        "postgresql+psycopg2://hansel_beyond:sZgZZxM990jB@cars-and-beyond-database.cruaiycmszbx.us-west-1.rds"
        ".amazonaws.com:5432/cars_and_beyond"
    )

    with engine.connect() as conn:
        result = conn.execute(text(query), params)
        return [dict(row) for row in result]


def run_query_without_params(file_path: str) -> Sequence[RowMapping]:
    with open(file_path, "r") as f:
        query = f.read()

    engine = create_engine(
        "postgresql+psycopg2://hansel_beyond:sZgZZxM990jB@cars-and-beyond-database.cruaiycmszbx.us-west-1.rds"
        ".amazonaws.com:5432/cars_and_beyond"
    )

    with engine.connect() as conn:
        result = conn.execute(text(query))
        return result.mappings().all()
