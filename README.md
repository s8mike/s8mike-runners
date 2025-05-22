### ✅`README.md` with the local setup instructions

````markdown
# s8mike-runners

This repository demonstrates a simple GitHub Actions CI setup and includes scripts for managing self-hosted runners at both the organization and repository level.

---

## 🚀 Getting Started Locally

Follow these steps to clone the repository and start working locally:

### 1. Clone the Repository

Using HTTPS:

```bash
git clone https://github.com/<your-username>/s8mike-runners.git
````

Or using SSH:

```bash
git clone git@github.com:<your-username>/s8mike-runners.git
```

### 2. Navigate into the Project Folder

```bash
cd s8mike-runners
```

### 3. Set Up Project Structure (if not already present)

```bash
mkdir -p .github/workflows
mkdir runners

touch .github/workflows/simple-ci.yml
touch runners/org-runner.sh
touch runners/repo-runner.sh
touch runners/delete-runner.sh
touch README.md
```

Then edit files using your preferred code editor.

### 4. Stage, Commit, and Push

```bash
git add .
git commit -m "Initial commit with CI and runner scripts"
git push origin main
```

---

## 📁 Folder Structure

```
s8mike-runners/
├── .github/
│   └── workflows/
│       └── simple-ci.yml          # Basic CI with labeled echo steps
├── runners/
│   ├── org-runner.sh              # Register organization-level self-hosted runner
│   ├── repo-runner.sh             # Register repository-level self-hosted runner
│   └── delete-runner.sh           # Remove/unregister a runner
├── README.md
└── (your app code...)             # In a real-world project, your repo usually includes code, config, or other logic beyond just DevOps tooling.
```

---

## ⚙️ GitHub Actions CI

The workflow file `.github/workflows/simple-ci.yml` defines a basic CI pipeline that runs on every push and pull request to the `main` branch. It performs four labeled steps:

* Build
* Deploy
* S8
* S9

You can view the pipeline in the **Actions** tab after pushing your code or creating a pull request.

---

## 🖥️ Self-hosted Runners

All runner scripts are located in the `runners/` folder. These are Linux-based examples using GitHub-hosted binaries.

### 🔧 1. Register an Organization-level Runner

```bash
cd runners
bash org-runner.sh
```

> Replace variables like `ORG` and `<ORG_REGISTRATION_TOKEN>` in the script with your actual values.

---

### 🔧 2. Register a Repository-level Runner

```bash
cd runners
bash repo-runner.sh
```

> Replace `REPO`, `OWNER`, and `<REPO_REGISTRATION_TOKEN>` as needed.

---

### ❌ 3. Remove a Runner

```bash
cd runners
bash delete-runner.sh  # or >runner.sh
```

> Make sure to replace `<REMOVE_TOKEN>` in the script with a valid removal token.

---

## 🛡️ Notes

* These scripts are intended for Linux environments.
* You must retrieve registration and removal tokens via the GitHub API or web UI.
* Always keep tokens secure. Avoid committing them directly in your scripts.

---

## 📚 References

* [GitHub Actions: Self-hosted runners](https://docs.github.com/en/actions/hosting-your-own-runners)
* [GitHub REST API: Actions](https://docs.github.com/en/rest/actions)

```