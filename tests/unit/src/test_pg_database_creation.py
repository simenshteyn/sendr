import textwrap

import pytest


def table_exists(pg_curs, id_name: str, table_name: str,
                 scheme: str = 'content') -> bool:
    statement = textwrap.dedent(
        f'SELECT {id_name} FROM {scheme}.{table_name};'
    )
    pg_curs.execute(statement)
    if len(pg_curs.fetchall()) >= 0:
        return True
    else:
        return False


def get_enum_len(pg_curs, enum_name: str) -> int:
    statement = textwrap.dedent("""
        SELECT type.typname,
               enum.enumlabel AS value
          FROM pg_enum AS enum
          JOIN pg_type AS type
               ON (type.oid = enum.enumtypid)
         WHERE type.typname = %s
         GROUP BY enum.enumlabel, type.typname;
    """)
    pg_curs.execute(statement, (enum_name,))
    return len(pg_curs.fetchall())


def test_db_connection(pg_conn):
    is_connected = bool(pg_conn and pg_conn.closed == 0)
    assert is_connected


def test_db_enum_campaign_type_exists(pg_curs):
    assert get_enum_len(pg_curs, 'campaign_type') == 2


def test_db_enum_letter_status_exists(pg_curs):
    assert get_enum_len(pg_curs, 'letter_status') == 8


def test_db_table_response_type_exists(pg_curs):
    assert table_exists(pg_curs, 'response_type_id', 'response_type')


def test_db_table_key_status_exists(pg_curs):
    assert table_exists(pg_curs, 'key_status_id', 'key_status')


def test_db_table_campaigns_exists(pg_curs):
    assert table_exists(pg_curs, 'campaign_id', 'campaigns')


def test_db_table_messages_exists(pg_curs):
    assert table_exists(pg_curs, 'message_id', 'messages')


def test_db_table_senders_exists(pg_curs):
    assert table_exists(pg_curs, 'sender_id', 'senders')


def test_db_table_lists_exists(pg_curs):
    assert table_exists(pg_curs, 'list_id', 'lists')


def test_db_list_ownership_exists(pg_curs):
    assert table_exists(pg_curs, 'list_ownership_id', 'list_ownership')


def test_db_recipients_exists(pg_curs):
    assert table_exists(pg_curs, 'recipient_id', 'recipients')


def test_db_list_records_exists(pg_curs):
    assert table_exists(pg_curs, 'list_record_id', 'list_records')


def test_db_api_keys_exists(pg_curs):
    assert table_exists(pg_curs, 'api_key_id', 'api_keys')


def test_db_letters_exists(pg_curs):
    assert table_exists(pg_curs, 'letter_id', 'letters')


def test_db_campaign_letters_exists(pg_curs):
    assert table_exists(pg_curs, 'campaign_letter_id', 'campaign_letters')


def test_db_tracking_records_exists(pg_curs):
    assert table_exists(pg_curs, 'tracking_record_id', 'tracking_records')


def test_db_responses_exists(pg_curs):
    assert table_exists(pg_curs, 'response_id', 'responses')
