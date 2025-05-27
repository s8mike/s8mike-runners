#!/bin/bash

BASE_DIR="/opt/github-runner-multi"
SERVICE_PREFIX="github-runner@"  # systemd service naming format: github-runner@runner-1.service

echo "🔁 Starting GitHub Runners cleanup from $BASE_DIR..."

if [ ! -d "$BASE_DIR" ]; then
  echo "❌ Base directory $BASE_DIR does not exist."
  exit 1
fi

cd "$BASE_DIR" || exit 1

for runner in runner-*; do
  if [ -d "$runner" ]; then
    echo "---------------------------------------------------"
    echo "🧹 Processing $runner"
    cd "$BASE_DIR/$runner" || continue

    read -p "Enter GitHub removal token for $runner (or leave blank to skip): " TOKEN

    if [ -n "$TOKEN" ]; then
      ./config.sh remove --token "$TOKEN"
      if [ $? -eq 0 ]; then
        echo "✅ $runner successfully deregistered from GitHub."

        # Attempt to stop systemd service if exists
        SERVICE_NAME="${SERVICE_PREFIX}${runner}.service"
        if systemctl list-units --full -all | grep -q "$SERVICE_NAME"; then
          echo "🛑 Stopping systemd service: $SERVICE_NAME"
          systemctl stop "$SERVICE_NAME"
          systemctl disable "$SERVICE_NAME"
        else
          echo "⚠️  No systemd service found for $runner. Killing run.sh as fallback."
          pkill -f "$BASE_DIR/$runner/run.sh"
        fi

        cd "$BASE_DIR"
        rm -rf "$runner"
        echo "🗑️  $runner folder deleted."
      else
        echo "⚠️  Failed to remove $runner from GitHub. You may need to force remove it from the UI."
      fi
    else
      echo "⏭️  Skipped $runner (no token provided)"
    fi
  fi
done

echo "🎉 All GitHub runners have been processed."
