-- Core Tables
CREATE TABLE IF NOT EXISTS users (user_id PK, password_hash, localpart, display_name, avatar_url, admin, created_at);
CREATE TABLE IF NOT EXISTS rooms (room_id PK, version, creator, created_at, tombstone_event_id);
CREATE TABLE IF NOT EXISTS events (event_id PK, room_id, type, state_key, sender, content, origin_server_ts);
CREATE TABLE IF NOT EXISTS room_memberships (room_id, user_id, membership, display_name, avatar_url);
CREATE TABLE IF NOT EXISTS room_state (room_id, event_type, state_key, event_id);

-- E2EE Tables
CREATE TABLE IF NOT EXISTS devices (user_id, device_id, display_name, keys, signatures);
CREATE TABLE IF NOT EXISTS cross_signing_keys (user_id, key_type, key_data, signatures);
CREATE TABLE IF NOT EXISTS cross_signing_signatures (user_id, key_id, signer_user_id, signature);
CREATE TABLE IF NOT EXISTS key_backup_versions (version PK, user_id, algorithm, auth_data);
CREATE TABLE IF NOT EXISTS key_backup_keys (user_id, version, room_id, session_id, session_data);
CREATE TABLE IF NOT EXISTS one_time_keys (user_id, device_id, key_id, algorithm, key_data);
CREATE TABLE IF NOT EXISTS fallback_keys (user_id, device_id, key_id, algorithm, key_data, used);

-- Sync & Messaging
CREATE TABLE IF NOT EXISTS access_tokens (token PK, user_id, device_id, created_at);
CREATE TABLE IF NOT EXISTS sync_tokens (user_id, device_id, since_token, room_positions);
CREATE TABLE IF NOT EXISTS to_device_messages (id, user_id, device_id, sender, type, content);
CREATE TABLE IF NOT EXISTS typing (room_id, user_id, timeout_at);
CREATE TABLE IF NOT EXISTS receipts (room_id, user_id, event_id, receipt_type, ts);
