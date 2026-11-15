#!/bin/bash

# Back up /mnt/family-home/media to the borg repo on /mnt/data, then prune old archives.
# Passphrase is read from ~/.borg-media-password (mode 600).
# Run nightly by ~/.config/systemd/user/borg-media-backup.timer.

REPO="/mnt/data/borg"
SOURCE_ROOT="/mnt/family-home"

# Check if repo is provided as the first argument
if [ ! -z "$1" ]; then
    REPO="$1"
fi

export BORG_REPO="$REPO"
export BORG_PASSCOMMAND="cat $HOME/.borg-media-password"

# The monthly borg check (borg-media-check.timer) can still hold the repo lock at
# 02:30, especially the long --verify-data run in Jan/Jul. Wait up to 12h for it
# instead of failing.
LOCK_WAIT=43200

# Warn when the backup drive has less than this much free space (percent).
MIN_FREE_PCT="${BORG_MIN_FREE_PCT:-10}"

# What to back up, relative to $SOURCE_ROOT. Anything in media/ not listed here
# is NOT backed up.
INCLUDES=(
    media/backups
    media/ben-dashcam
    media/diaspora
    media/Family
    media/Music
    media/mypol.pp
    media/mypol.te
    media/tapoutxt
    media/trail-cam
    media/Video
)

# Top-level entries in media/ that are deliberately left out. Kept outside the
# repo, one name per line (e.g. "lost+found"). Used only to stay quiet about them
# in the new-folder warning below.
SKIP_FILE="$HOME/.config/borg/media-skip"

# Both drives mount with nofail. If the source isn't mounted, borg would happily
# archive an empty directory; if the backup drive isn't mounted, the repo is missing.
if ! mountpoint -q "$SOURCE_ROOT" || [ ! -d "$SOURCE_ROOT/media" ]; then
    echo "Source $SOURCE_ROOT is not mounted (LUKS not unlocked?). Skipping backup." >&2
    exit 1
fi
if ! mountpoint -q /mnt/data || [ ! -d "$REPO" ]; then
    echo "Backup repo $REPO is not available (/mnt/data not mounted?). Skipping backup." >&2
    exit 1
fi

# Store paths relative to the source root (media/Family/..., media/Video/...)
cd "$SOURCE_ROOT" || exit 1

# Warn about new top-level entries in media/ that are neither included nor
# skipped, so a new folder doesn't silently go unbacked-up.
unlisted=()
for entry in media/*; do
    [[ " ${INCLUDES[*]} " == *" $entry "* ]] && continue
    grep -qxF "${entry#media/}" "$SKIP_FILE" 2>/dev/null && continue
    unlisted+=("$entry")
done
if [ ${#unlisted[@]} -gt 0 ]; then
    msg="Not backed up (add to INCLUDES or $SKIP_FILE): ${unlisted[*]}"
    echo "WARNING: $msg" >&2
    logger -t backup-alert -p user.warning "UNLISTED: $msg"
    notify-send -u critical -a "Backup alert" -i drive-harddisk "New folder not in backup" "$msg" 2>/dev/null || true
fi

# Only pass paths that exist, so a removed folder doesn't turn into a borg warning.
paths=()
for inc in "${INCLUDES[@]}"; do
    [ -e "$inc" ] && paths+=("$inc")
done

# Show progress only when run by hand; under systemd it would flood the journal.
progress=""
if [ -t 1 ]; then
    progress="--progress"
fi

# Video is already compressed, so let auto skip incompressible chunks
borg create --lock-wait $LOCK_WAIT --stats $progress --one-file-system \
    --compression auto,zstd,3 \
    ::'media-{now:%Y-%m-%d_%H%M%S}' \
    "${paths[@]}"
create_status=$?

# borg create exits 1 for warnings (e.g. a file changed while reading); only skip
# pruning on a real error so a failed run never thins out the good archives.
if [ $create_status -ge 2 ]; then
    echo "borg create failed (exit $create_status). Not pruning." >&2
    exit $create_status
fi

borg prune --lock-wait $LOCK_WAIT --list --glob-archives 'media-*' \
    --keep-daily 7 --keep-weekly 4 --keep-monthly 12 --keep-yearly 5
prune_status=$?

borg compact --lock-wait $LOCK_WAIT

# Warn (desktop + journal) when the backup drive is getting full. borg needs free
# space to prune and compact, so act before it actually runs out.
free_pct=$(( 100 - $(df --output=pcent "$REPO" | tail -1 | tr -dc '0-9') ))
free_human=$(df -h --output=avail "$REPO" | tail -1 | tr -d ' ')
if [ "$free_pct" -lt "$MIN_FREE_PCT" ]; then
    msg="Backup drive for $REPO has only $free_human ($free_pct%) free. Prune more or replace the drive."
    echo "WARNING: $msg" >&2
    logger -t backup-alert -p user.warning "LOW SPACE: $msg"
    notify-send -u critical -a "Backup alert" -i drive-harddisk "Backup drive low on space" "$msg" 2>/dev/null || true
else
    echo "Backup drive free space: $free_human ($free_pct%)."
fi

echo "Borg backup complete (create exit $create_status, prune exit $prune_status)."
exit $(( create_status > prune_status ? create_status : prune_status ))
