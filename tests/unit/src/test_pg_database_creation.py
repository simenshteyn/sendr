import pytest


def test_database_connection(pg_cursor):
    is_connected = bool(pg_cursor and pg_cursor.closed == 0)
    assert is_connected