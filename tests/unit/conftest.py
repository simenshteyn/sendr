import psycopg2
import pytest
from psycopg2.extras import DictCursor

from tests.unit.settings import config

dsl = {'dbname': config.pg_dbname,
       'user': config.pg_user,
       'password': config.pg_pass,
       'host': config.pg_host,
       'port': config.pg_port}


@pytest.fixture(scope='session')
def pg_conn():
    pg_conn = psycopg2.connect(**dsl, cursor_factory=DictCursor)
    yield pg_conn
    pg_conn.close()


@pytest.fixture
def pg_curs(pg_conn):
    pg_curs = pg_conn.cursor()
    yield pg_curs
    pg_curs.close()
