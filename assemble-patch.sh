#!/usr/bin/env bash
set -euo pipefail

OUT="TFS_SECURE_DATABASE_BACKUP_V2.patch"
EXPECTED="8ca094f4e03833ee786bb00231a584a20c6d5765b38ebd0ba45ce8d997da6718"

cat payload/TFS_SECURE_DATABASE_BACKUP_V2.patch.gz.b64.part01 \
    payload/TFS_SECURE_DATABASE_BACKUP_V2.patch.gz.b64.part02 \
    payload/TFS_SECURE_DATABASE_BACKUP_V2.patch.gz.b64.part03 \
    payload/TFS_SECURE_DATABASE_BACKUP_V2.patch.gz.b64.part04 \
  | tr -d '\r\n' \
  | base64 -d \
  | gzip -d > "$OUT"

ACTUAL="$(sha256sum "$OUT" | awk '{print $1}')"
if [[ "$ACTUAL" != "$EXPECTED" ]]; then
  echo "ERROR: SHA-256 mismatch"
  echo "expected: $EXPECTED"
  echo "actual:   $ACTUAL"
  rm -f "$OUT"
  exit 1
fi

echo "OK: $OUT"
echo "SHA-256: $ACTUAL"
