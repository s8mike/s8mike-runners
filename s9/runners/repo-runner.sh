#!/bin/bash

# -----------------------
# Configurable Variables
# -----------------------
RUNNER_VERSION="2.328.0"                               #update version to match
REPO_URL="https://github.com/s8mike/s8mike-runners"                    #replace with github url/repository
RUNNER_TOKEN="BG6HYSAZ6HMRJGIPVWI5MP3IZZ5TA"                                #replace with repository token
RUNNER_LABELS="repo-build,repo-deploy,s9"                                      # use prefered label
RUNNER_USER="runner"                                                  # Give runner-user name of choice     
RUNNER_COUNT=3                                                              #use prefered number of runners
BASE_DIR="/opt/github-runner-multi"

# -----------------------
# Create system user
# -----------------------
if ! id -u "$RUNNER_USER" >/dev/null 2>&1; then
  echo "[INFO] Creating system user: $RUNNER_USER"
  sudo useradd -m -s /bin/bash "$RUNNER_USER"
fi

# Allow the runner user to run all sudo commands without password
echo "[INFO] Granting passwordless sudo to $RUNNER_USER"
echo "$RUNNER_USER ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/$RUNNER_USER > /dev/null
sudo chmod 0440 /etc/sudoers.d/$RUNNER_USER

# Create base directory for all runners
sudo mkdir -p "$BASE_DIR"
sudo chown "$RUNNER_USER":"$RUNNER_USER" "$BASE_DIR"

# Download runner package once
cd "$BASE_DIR"
RUNNER_TAR="actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz"
if [ ! -f "$RUNNER_TAR" ]; then
  echo "[INFO] Downloading runner version $RUNNER_VERSION"
  curl -o "$RUNNER_TAR" -L \
    "https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/${RUNNER_TAR}"
fi

echo "[INFO] Validating SHA256 checksum"
echo "01066fad3a2893e63e6ca880ae3a1fad5bf9329d60e77ee15f2b97c148c3cd4e  $RUNNER_TAR" | shasum -a 256 -c     #Replace echo value

# -----------------------
# Install multiple runners
# -----------------------
for i in $(seq 1 $RUNNER_COUNT); do
  RUNNER_DIR="$BASE_DIR/runner-$i"
  RUNNER_NAME="$(hostname)-RUNNER-$i"
  SERVICE_NAME="github-runner-$i"

  echo "[INFO] Setting up runner $i in $RUNNER_DIR"
  sudo mkdir -p "$RUNNER_DIR"
  sudo chown "$RUNNER_USER":"$RUNNER_USER" "$RUNNER_DIR"

  sudo -u "$RUNNER_USER" bash <<EOF
set -e
cd "$RUNNER_DIR"

# Copy and extract
cp "$BASE_DIR/$RUNNER_TAR" .
tar xzf "$RUNNER_TAR"

# Remove old config if exists
if [ -f ".runner" ]; then
  yes | ./config.sh remove || true
  rm -f .runner
fi

# Configure runner
./config.sh \
  --url "$REPO_URL" \
  --token "$RUNNER_TOKEN" \
  --name "$RUNNER_NAME" \
  --labels "$RUNNER_LABELS" \
  --runnergroup "$RUNNER_GROUP" \
  --unattended \
  --work _work
EOF

  # -----------------------
  # Create systemd service
  # -----------------------
  echo "[INFO] Creating systemd service for $SERVICE_NAME"
  sudo tee /etc/systemd/system/$SERVICE_NAME.service > /dev/null <<EOL
[Unit]
Description=GitHub Actions Runner $i
After=network.target

[Service]
ExecStart=$RUNNER_DIR/run.sh
User=$RUNNER_USER
WorkingDirectory=$RUNNER_DIR
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOL

  # Start the runner
  sudo systemctl daemon-reload
  sudo systemctl enable --now "$SERVICE_NAME"
done

echo "✅ All $RUNNER_COUNT GitHub runners installed and running with labels: $RUNNER_LABELS"






################################################################################################
#Updated runner script to include sudo for docker commands ✅ Updated Version (Safe + Corrected)

# 🚀 Key Improvements

# Fixed typo "RNNER" → "RUNNER".

# Defined RUNNER_GROUP="Default".

# Moved RUNNER_TOKEN to an environment variable for security.

# Added runner to docker group (so you can use Docker inside workflows).

# Added docker.service dependency in systemd unit for stability.

# Optional SHA256 check (you decide if you want strict version pinning).

#To use in other repos.

#############################################################################################

#!/bin/bash

# -----------------------
# Configurable Variables
# -----------------------
RUNNER_VERSION="2.328.0"
REPO_URL="https://github.com/s8mike/s8mike-runners"
RUNNER_TOKEN="${RUNNER_TOKEN:?Runner token not set}"   # must be passed in env
RUNNER_LABELS="repo-build,repo-deploy,s9"
RUNNER_USER="runner"
RUNNER_COUNT=3
RUNNER_GROUP="Default"                                # explicitly define
BASE_DIR="/opt/github-runner-multi"

# -----------------------
# Create system user
# -----------------------
if ! id -u "$RUNNER_USER" >/dev/null 2>&1; then
  echo "[INFO] Creating system user: $RUNNER_USER"
  sudo useradd -m -s /bin/bash "$RUNNER_USER"
  sudo usermod -aG docker "$RUNNER_USER"
fi

# Allow the runner user passwordless sudo (all commands)
echo "[INFO] Granting passwordless sudo to $RUNNER_USER"
echo "$RUNNER_USER ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/$RUNNER_USER > /dev/null
sudo chmod 0440 /etc/sudoers.d/$RUNNER_USER

# Create base directory
sudo mkdir -p "$BASE_DIR"
sudo chown "$RUNNER_USER":"$RUNNER_USER" "$BASE_DIR"
cd "$BASE_DIR"

# Download runner package
RUNNER_TAR="actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz"
if [ ! -f "$RUNNER_TAR" ]; then
  echo "[INFO] Downloading runner version $RUNNER_VERSION"
  curl -o "$RUNNER_TAR" -L \
    "https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/${RUNNER_TAR}"
fi

# (Optional) Verify checksum
# echo "<correct-sha256>  $RUNNER_TAR" | shasum -a 256 -c

# -----------------------
# Install multiple runners
# -----------------------
for i in $(seq 1 $RUNNER_COUNT); do
  RUNNER_DIR="$BASE_DIR/runner-$i"
  RUNNER_NAME="$(hostname)-RUNNER-$i"
  SERVICE_NAME="github-runner-$i"

  echo "[INFO] Setting up runner $i in $RUNNER_DIR"
  sudo mkdir -p "$RUNNER_DIR"
  sudo chown "$RUNNER_USER":"$RUNNER_USER" "$RUNNER_DIR"

  sudo -u "$RUNNER_USER" bash <<EOF
set -e
cd "$RUNNER_DIR"

# Copy and extract
cp "$BASE_DIR/$RUNNER_TAR" .
tar xzf "$RUNNER_TAR"

# Remove old config
if [ -f ".runner" ]; then
  yes | ./config.sh remove || true
  rm -f .runner
fi

# Configure runner
./config.sh \
  --url "$REPO_URL" \
  --token "$RUNNER_TOKEN" \
  --name "$RUNNER_NAME" \
  --labels "$RUNNER_LABELS" \
  --runnergroup "$RUNNER_GROUP" \
  --unattended \
  --work _work
EOF

  # Create systemd service
  echo "[INFO] Creating systemd service for $SERVICE_NAME"
  sudo tee /etc/systemd/system/$SERVICE_NAME.service > /dev/null <<EOL
[Unit]
Description=GitHub Actions Runner $i
After=network.target docker.service
Wants=docker.service

[Service]
ExecStart=$RUNNER_DIR/run.sh
User=$RUNNER_USER
WorkingDirectory=$RUNNER_DIR
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOL

  sudo systemctl daemon-reload
  sudo systemctl enable --now "$SERVICE_NAME"
done

echo "✅ Installed $RUNNER_COUNT runners with labels: $RUNNER_LABELS"




