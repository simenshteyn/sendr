from pydantic import BaseSettings


class TestSettings(BaseSettings):
    pg_host: str
    pg_port: int
    pg_dbname: str
    pg_user: str
    pg_pass: str


config = TestSettings.parse_file('/app/tests/unit/config.json')
