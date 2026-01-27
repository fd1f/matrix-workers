-- Core Tables
CREATE TABLE users (
    user_id PK,
    password_hash,
    localpart,
    display_name,
    avatar_url,
    is_guest,
    is_deactivated,
    admin,
    created_at,
    updated_at
);
CREATE TABLE rooms (
    room_id PK,
    version,
    is_public,
    creator_id,
    created_at,
    tombstone_event_id
);
CREATE TABLE events (
    event_id PK,
    room_id,
    event_type,
    state_key,
    sender,
    content,
    origin_server_ts,
    depth,
    stream_ordering,
    auth_events,
    prev_events
);
CREATE TABLE room_memberships (
    room_id,
    user_id,
    membership,
    event_id,
    display_name,
    avatar_url
);
CREATE TABLE room_state (room_id, event_type, state_key, event_id);
CREATE TABLE account_data (user_id, room_id, event_type, content);
CREATE TABLE account_data_changes (user_id, room_id, event_type, stream_position);
-- E2EE Tables
CREATE TABLE devices (
    user_id,
    device_id,
    display_name,
    keys,
    signatures,
    created_at
);
CREATE TABLE cross_signing_keys (user_id, key_type, key_id, key_data, signatures);
CREATE TABLE cross_signing_signatures (
    user_id,
    key_id,
    signer_user_id,
    signer_key_id,
    signature
);
CREATE TABLE key_backup_versions (
    version PK,
    user_id,
    algorithm,
    auth_data,
    etag,
    count
);
CREATE TABLE key_backup_keys (
    user_id,
    version,
    room_id,
    session_id,
    first_message_index,
    forwarded_count,
    is_verified,
    session_data
);
CREATE TABLE one_time_keys (user_id, device_id, key_id, algorithm, claimed, key_data);
CREATE TABLE fallback_keys (
    user_id,
    device_id,
    key_id,
    algorithm,
    key_data,
    used
);
-- Sync & Messaging
CREATE TABLE access_tokens (
    token_id PK,
    token_hash,
    user_id,
    device_id,
    created_at
);
CREATE TABLE sync_tokens (user_id, device_id, since_token, room_positions);
CREATE TABLE to_device_messages (
    id,
    recipient_user_id,
    recipient_device_id,
    sender_user_id,
    event_type,
    content,
    delivered,
    message_id,
    stream_position
);
CREATE TABLE typing (room_id, user_id, timeout_at);
CREATE TABLE receipts (room_id, user_id, event_id, receipt_type, ts);
-- Push
CREATE TABLE pushers (
    user_id,
    pushkey,
    kind,
    app_id,
    app_display_name,
    device_display_name,
    profile_tag,
    lang,
    data
);
CREATE TABLE push_rules (
    user_id,
    kind,
    rule_id,
    conditions,
    actions,
    enabled,
    priority
);