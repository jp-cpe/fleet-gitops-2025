# Promotion map: staging to Fleet GitOps

## Scope

Configuration profiles only (Jamf -> contour -> Fleet GitOps).

## Source to target mapping

- `staging/jamf-to-fleet/profiles/**/*.mobileconfig` -> `platforms/macos/configuration-profiles/`
- `staging/jamf-to-fleet/profiles/**/*.json` (DDM declarations only) -> `platforms/macos/declaration-profiles/`

## Validation gate before copy

- `contour profile validate staging/jamf-to-fleet/profiles --recursive --json`
- Resolve any failed objects before promotion.

## Promotion command pattern

```bash
cp staging/jamf-to-fleet/profiles/*.mobileconfig platforms/macos/configuration-profiles/
```
