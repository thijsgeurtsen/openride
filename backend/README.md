# Strava backend (planned, not implemented)

Use a secure server-side OAuth 2.0 authorization-code flow with state verification, encrypted token storage, refresh handling, and per-user authorization. Never put the client secret in Flutter or GitHub. Request `activity:write` for uploads. Export a valid FIT file with timestamps and upload via Strava `/api/v3/uploads` using multipart `data_type=fit`; poll upload status with backoff and handle duplicate uploads. Consider Strava API rate limits and evolving API endpoints. No working Strava connection exists in v0.1.
