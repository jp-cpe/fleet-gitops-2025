#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
STAGING_DIR="$ROOT_DIR/staging/jamf-to-fleet"
BACKUP_DIR="$STAGING_DIR/jamf-backup"
PROFILES_DIR="$STAGING_DIR/profiles"
VALIDATION_DIR="$STAGING_DIR/validation"
REPORTS_DIR="$STAGING_DIR/reports"
ORG_DOMAIN="com.jp-cpe"

mkdir -p "$BACKUP_DIR" "$PROFILES_DIR" "$VALIDATION_DIR" "$REPORTS_DIR"

if ! command -v jamf-cli >/dev/null 2>&1; then
  echo "jamf-cli is not installed. Install/configure jamf-cli, then re-run this script."
  exit 1
fi

echo "Exporting Jamf profiles to $BACKUP_DIR ..."
jamf-cli pro backup --output "$BACKUP_DIR" --resources profiles

echo "Importing and normalizing Jamf profiles with contour ..."
contour profile import --jamf "$BACKUP_DIR/profiles/macos/" --all -o "$PROFILES_DIR/" --org "$ORG_DOMAIN"

echo "Validating normalized profiles ..."
contour profile validate "$PROFILES_DIR" --recursive --json > "$VALIDATION_DIR/profile-validation.json"

echo "Writing migration status report ..."
{
  echo "# Jamf profile import status"
  echo
  echo "- Source backup: \`$BACKUP_DIR/profiles/macos/\`"
  echo "- Output directory: \`$PROFILES_DIR/\`"
  echo "- Validation report: \`$VALIDATION_DIR/profile-validation.json\`"
  echo "- Org domain: \`$ORG_DOMAIN\`"
} > "$REPORTS_DIR/import-status.md"

echo "Done."
