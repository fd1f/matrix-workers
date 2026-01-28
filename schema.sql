-- Core Tables
CREATE TABLE users (
    user_id PRIMARY KEY,
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
CREATE TABLE user_threepids (
    user_id,
    medium,
    address,
    validated_at,
    added_at,
    -- this constraint is my own personal addition, because why have duplicate 3PIDs?
    UNIQUE(user_id, medium, address)
);
CREATE TABLE rooms (
    room_id PRIMARY KEY,
    room_version,
    is_public,
    creator_id,
    created_at,
    tombstone_event_id
);
CREATE TABLE events (
    event_id PRIMARY KEY,
    room_id,
    sender,
    event_type,
    state_key,
    content,
    origin_server_ts,
    unsigned,
    depth,
    auth_events,
    prev_events,
    hashes,
    signatures,
    stream_ordering
);
CREATE TABLE room_memberships (
    room_id,
    user_id,
    membership,
    event_id,
    display_name,
    avatar_url
);
CREATE TABLE room_state (
    room_id,
    event_type,
    state_key,
    event_id,
    UNIQUE(room_id, event_type, state_key)
);
CREATE TABLE room_aliases (alias, room_id, creator_id, created_at);
CREATE TABLE account_data (
    user_id,
    room_id,
    event_type,
    content,
    UNIQUE(user_id, room_id, event_type)
);
CREATE TABLE account_data_changes (user_id, room_id, event_type, stream_position);
CREATE TABLE presence (
    user_id PRIMARY KEY,
    presence,
    status_msg,
    last_active_ts
);
CREATE TABLE content_reports (
    reporter_user_id,
    room_id,
    event_id,
    reason,
    score,
    created_at
);
CREATE TABLE transaction_ids (
    user_id,
    txn_id,
    event_id,
    response,
    UNIQUE(user_id, txn_id)
);
-- Federation
CREATE TABLE server_keys (
    key_id,
    public_key,
    private_key,
    valid_from,
    valid_until,
    is_current
);
-- Media
CREATE TABLE media (
    media_id,
    user_id,
    content_type,
    content_length,
    filename,
    created_at
);
-- E2EE Tables
CREATE TABLE devices (
    user_id,
    device_id,
    display_name,
    keys,
    signatures,
    created_at
);
CREATE TABLE device_key_changes (user_id, device_id, change_type, stream_position);
CREATE TABLE cross_signing_keys (
    user_id,
    key_type,
    key_id,
    key_data,
    signatures,
    UNIQUE(user_id, key_type)
);
CREATE TABLE cross_signing_signatures (
    user_id PRIMARY KEY,
    key_id,
    signer_user_id,
    signer_key_id,
    signature,
    UNIQUE(user_id, key_id, signer_user_id, signer_key_id)
);
CREATE TABLE key_backup_versions (
    version PRIMARY KEY,
    user_id,
    algorithm,
    auth_data,
    etag,
    deleted,
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
    session_data,
    UNIQUE(user_id, version, room_id, session_id)
);
CREATE TABLE one_time_keys (
    user_id,
    device_id,
    key_id,
    algorithm,
    claimed,
    key_data,
    UNIQUE(user_id, device_id, key_id, algorithm)
);
CREATE TABLE fallback_keys (
    user_id,
    device_id,
    algorithm,
    key_id,
    key_data,
    used,
    UNIQUE(user_id, device_id, algorithm)
);
-- Sync & Messaging
CREATE TABLE access_tokens (
    token_id PRIMARY KEY,
    token_hash,
    user_id,
    device_id,
    created_at
);
CREATE TABLE sync_tokens (user_id, device_id, since_token, room_positions);
CREATE TABLE stream_positions (stream_name PRIMARY KEY, position);
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
    data,
    enabled,
    UNIQUE(user_id, pushkey, app_id)
);
CREATE TABLE push_rules (
    user_id,
    kind,
    rule_id,
    conditions,
    actions,
    enabled,
    priority,
    UNIQUE(user_id, kind, rule_id)
);
CREATE TABLE notification_queue (
    user_id,
    room_id,
    event_id,
    notification_type,
    actions
);
-- OIDC
CREATE TABLE idp_providers (
    id,
    name,
    issuer_url,
    client_id,
    client_secret_encrypted,
    scopes,
    enabled,
    auto_create_users,
    username_claim,
    icon_url,
    created_at,
    updated_at
);
CREATE TABLE idp_user_links (
    provider_id,
    external_id,
    user_id,
    external_email,
    external_name,
    last_login_at
);