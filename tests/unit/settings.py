import os

from pydantic import BaseSettings


class TestSettings(BaseSettings):
    pg_host: str
    pg_port: int
    pg_dbname: str
    pg_user: str
    pg_pass: str


pg_settings = {
    'pg_host': os.getenv('POSTGRES_HOST'),
    'pg_port': os.getenv('POSTGRES_PORT'),
    'pg_dbname': os.getenv('POSTGRES_DB'),
    'pg_user': os.getenv('POSTGRES_USER'),
    'pg_pass': os.getenv('POSTGRES_PASSWORD')
}
config = TestSettings.parse_obj(pg_settings)
