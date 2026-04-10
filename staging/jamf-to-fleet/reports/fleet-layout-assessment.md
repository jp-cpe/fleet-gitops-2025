# Fleet layout assessment (v4.83)

## Summary

- Repository was using legacy paths (`lib/` and `teams/`) for active artifacts.
- Fleet v4.83 guidance expects `platforms/`, `labels/`, and `fleets/` with glob-based references.
- CI entrypoints were mixed (`gitops.sh` for teams and `gitops-fleets.sh` for fleets).

## Required path and key adjustments

- Moved `teams/*.yml` to `fleets/*.yml`.
- Moved `lib/all/queries/*.yml` to `platforms/all/reports/*.yml`.
- Moved `lib/macos/declaration-profiles/*.json` to `platforms/macos/declaration-profiles/*.json`.
- Updated `default.yml` report and label references to glob-based v4.83 paths.
- Updated fleet YAML keys:
  - `queries` -> `reports`
  - `team_settings` -> `settings`
  - `macos_settings.custom_settings` -> `apple_settings.configuration_profiles`
- Switched GitHub workflow action to `./.github/gitops-action-fleets`.
- Switched GitLab pipeline to run `./gitops-fleets.sh`.

## Remaining migration work

- Import Jamf profile objects into `staging/jamf-to-fleet/profiles/` using contour once `jamf-cli` is available.
- Promote imported `.mobileconfig` files into `platforms/macos/configuration-profiles/`.
