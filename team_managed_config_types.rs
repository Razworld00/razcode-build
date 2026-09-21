//! JSON types for cli-chat-proxy's `/v1/team/{team_id}/managed-config` routes;
//! the documents written here are served to CLIs by `/v1/deployment/config`.

use chrono::{DateTime, Utc};
use serde::{Deserialize, Deserializer, Serialize};

/// Deserialize a present field into `Some(_)` even when its value is `null`.
/// Plain `Option<Option<T>>` cannot distinguish the two: serde maps an explicit
/// `null` to `None`, the same as an absent field. Paired with `#[serde(default)]`
/// this gives the three states a partial update needs.
fn present_or_null<'de, T, D>(deserializer: D) -> Result<Option<Option<T>>, D::Error>
where
    T: Deserialize<'de>,
    D: Deserializer<'de>,
{
    Option::deserialize(deserializer).map(Some)
}

#[derive(Debug, Clone, Default, Serialize, Deserialize, PartialEq, Eq)]
pub struct TeamManagedConfig {
    pub configured: bool,
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub managed_config: Option<String>,
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub requirements: Option<String>,
    pub fail_closed: bool,
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub updated_at: Option<DateTime<Utc>>,
}

/// A partial update. Each document field is a double option, which is what lets
/// JSON say all three things:
///
/// - absent (`None`) — leave the stored document alone
/// - `null` (`Some(None)`) — clear it
/// - a string (`Some(Some(_))`) — replace it
///
/// An omitted field can therefore never erase a document, which is how an
/// editor that does not round-trip `requirements` stops being able to wipe a
/// team's enforced policy. A body that names neither document is a 400.
#[derive(Debug, Clone, Default, Serialize, Deserialize, PartialEq, Eq)]
#[serde(deny_unknown_fields)] // a typoed key must 400, not silently leave a field alone
pub struct SetTeamManagedConfigRequest {
    #[serde(
        default,
        deserialize_with = "present_or_null",
        skip_serializing_if = "Option::is_none"
    )]
    pub managed_config: Option<Option<String>>,
    #[serde(
        default,
        deserialize_with = "present_or_null",
        skip_serializing_if = "Option::is_none"
    )]
    pub requirements: Option<Option<String>>,
    /// Guard: the write fails 412 unless the stored `updated_at` equals this.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub expected_updated_at: Option<DateTime<Utc>>,
}

#[derive(Debug, Clone, Default, Serialize, Deserialize, PartialEq, Eq)]
#[serde(deny_unknown_fields)] // a typoed guard key must 400, not silently unguard
pub struct DeleteTeamManagedConfigRequest {
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub expected_updated_at: Option<DateTime<Utc>>,
}
