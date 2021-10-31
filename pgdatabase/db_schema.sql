-- Schema for content. Diagram at: https://dbdiagram.io/d/6155785e825b5b01461a4121
CREATE SCHEMA IF NOT EXISTS content;

CREATE TYPE content.campaign_type AS ENUM (
    'single',
    'series'
);

CREATE TYPE content.letter_status AS ENUM (
    'draft',
    'ready',
    'planned',
    'sent',
    'received',
    'rejected',
    'opened',
    'clicked'
);

CREATE TABLE IF NOT EXISTS content.response_type (
    response_type_id    uuid        PRIMARY KEY DEFAULT gen_random_uuid(),
    response_desc       text        NOT NULL
);

CREATE TABLE IF NOT EXISTS content.key_status (
    key_status_id       uuid        PRIMARY KEY DEFAULT gen_random_uuid(),
    key_status_desc     text        NOT NULL
);


CREATE TABLE IF NOT EXISTS content.campaigns (
    campaign_id         uuid        PRIMARY KEY DEFAULT gen_random_uuid(),
    campaign_name       text        NOT NULL,
    campaign_type       content.campaign_type
                                    NOT NULL DEFAULT 'single',
    start_time          timestamp with time zone

);

CREATE TABLE IF NOT EXISTS content.messages (
    message_id          uuid        PRIMARY KEY DEFAULT gen_random_uuid(),
    message_content     text        NOT NULL,
    created_at          timestamp with time zone DEFAULT (now()),
    updated_at          timestamp with time zone DEFAULT (now())
);

CREATE TABLE IF NOT EXISTS content.senders (
    sender_id           uuid        PRIMARY KEY DEFAULT gen_random_uuid(),
    sender_profile      text        NOT NULL,
    sender_name         text        NOT NULL
);

CREATE TABLE IF NOT EXISTS content.lists (
    list_id             uuid        PRIMARY KEY DEFAULT gen_random_uuid(),
    list_name           text        NOT NULL,
    created_at          timestamp with time zone DEFAULT (now()),
    updated_at          timestamp with time zone DEFAULT (now())
);

CREATE TABLE IF NOT EXISTS content.list_ownership (
    list_ownership_id   uuid        PRIMARY KEY DEFAULT gen_random_uuid(),
    list_id             uuid        NOT NULL,
    sender_id           uuid        NOT NULL,
     UNIQUE (list_id, sender_id),
    FOREIGN KEY (list_id)
            REFERENCES content.lists
            ON DELETE CASCADE
            ON UPDATE CASCADE,
    FOREIGN KEY (sender_id)
            REFERENCES content.senders
            ON DELETE CASCADE
            ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS content.recipients (
    recipient_id        uuid        PRIMARY KEY DEFAULT gen_random_uuid(),
    recipient_profile   text        NOT NULL,
    recipient_fname     text        NOT NULL,
    recipient_lname     text        NOT NULL
);

CREATE TABLE IF NOT EXISTS content.list_records (
    list_record_id      uuid        PRIMARY KEY DEFAULT gen_random_uuid(),
    recipient_id        uuid        NOT NULL,
    list_id             uuid        NOT NULL,
     UNIQUE (recipient_id, list_id),
    FOREIGN KEY (recipient_id)
            REFERENCES content.recipients
            ON DELETE CASCADE
            ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS content.api_keys (
    api_key_id          uuid        PRIMARY KEY DEFAULT gen_random_uuid(),
    sender_id           uuid        NOT NULL,
    value               text,
    expires_at          timestamp with time zone
                                    NOT NULL,
    counter             integer,
    key_status_id       uuid        NOT NULL,
     UNIQUE (sender_id, value),
    FOREIGN KEY (sender_id)
            REFERENCES content.senders
            ON DELETE CASCADE
            ON UPDATE CASCADE,
    FOREIGN KEY (key_status_id)
            REFERENCES content.key_status
            ON DELETE CASCADE
            ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS content.letters (
    letter_id           uuid        PRIMARY KEY DEFAULT gen_random_uuid(),
    sender_id           uuid        NOT NULL,
    recipient_id        uuid        NOT NULL,
    message_id          uuid        NOT NULL,
    letter_status       content.letter_status
                                    NOT NULL DEFAULT 'draft',
     UNIQUE (sender_id, recipient_id, message_id),
    FOREIGN KEY (sender_id)
            REFERENCES content.senders
            ON DELETE CASCADE
            ON UPDATE CASCADE,
    FOREIGN KEY (recipient_id)
            REFERENCES content.recipients
            ON DELETE CASCADE
            ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS content.campaign_letters (
    campaign_letter_id  uuid        PRIMARY KEY DEFAULT gen_random_uuid(),
    campaign_id         uuid        NOT NULL,
    letter_id           uuid        NOT NULL,
    letter_offset       integer     NOT NULL,
     UNIQUE (campaign_id, letter_id, letter_offset),
    FOREIGN KEY (campaign_id)
            REFERENCES content.campaigns
            ON DELETE CASCADE
            ON UPDATE CASCADE,
    FOREIGN KEY (letter_id)
            REFERENCES content.letters
            ON DELETE CASCADE
            ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS content.tracking_records (
    tracking_record_id  uuid        PRIMARY KEY DEFAULT gen_random_uuid(),
    letter_id           uuid        NOT NULL,
    tracking_time       timestamp with time zone DEFAULT (now()),
    tracking_event      content.letter_status,
     UNIQUE (letter_id, tracking_time, tracking_event),
    FOREIGN KEY (letter_id)
            REFERENCES content.letters
            ON DELETE CASCADE
            ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS content.responses (
    response_id         uuid        PRIMARY KEY DEFAULT gen_random_uuid(),
    letter_id           uuid        NOT NULL,
    response_time       timestamp with time zone DEFAULT (now()),
    response_type_id    uuid        NOT NULL,
     UNIQUE (letter_id, response_time, response_type_id),
    FOREIGN KEY (letter_id)
            REFERENCES content.letters
            ON DELETE CASCADE
            ON UPDATE CASCADE,
    FOREIGN KEY (response_type_id)
            REFERENCES content.response_type
            ON DELETE CASCADE
            ON UPDATE CASCADE
);