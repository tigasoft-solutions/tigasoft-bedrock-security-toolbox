# Tigasoft Bedrock Security Toolbox

Minimal, Git-based security checks for **Bedrock WordPress** deployments running on **Forge-managed VPS**.

This repository is a small toolbox, not a framework.
Use what you need, ignore the rest.

---

## Why this exists

Most WordPress compromises are not caused by exotic zero-days.
They happen because:

* Files become writable at runtime
* Plugins introduce known vulnerabilities
* Malware modifies existing files or drops new PHP files
* No one notices until SEO spam or redirects appear

If your WordPress site is:

* Git-deployed
* Composer-managed (Bedrock)
* Treated as an immutable CMS

Then **Git itself can be your intrusion detector**.

This repo codifies that idea.

---

## What this toolbox does

✔ Detects **modified tracked files** using `git status --porcelain`

✔ Detects **newly created PHP files** (common malware behavior)

✔ Fails loudly via **Forge deploy** or **cron email alerts**

✔ Requires **no WordPress plugins**

✔ Requires **no agents, daemons, or SaaS**

---

## What this toolbox does NOT do

✘ No malware signature scanning

✘ No automatic cleanup

✘ No brute-force protection

✘ No WAF replacement

This is **detection, not magic**.

---

## Assumptions

This toolbox assumes:

* Bedrock-style WordPress structure
* Git is the source of truth
* Files should not change at runtime
* Media uploads are offloaded (S3 / Spaces) or locked down

If your WordPress site allows:

* Plugin installs from wp-admin
* Theme editing in production
* Writable PHP directories

This approach is **not for you** (yet).

---

## Folder structure

```
security/
├── check-integrity.sh     # Detects modified tracked files
├── check-new-php.sh       # Detects newly created PHP files
├── cron-integrity.sh      # Cron-friendly wrapper
```

---

## Installation

Add this as a submodule into your Bedrock project root:

```
git submodule add https://github.com/tigasoft-solutions/tigasoft-bedrock-security-toolbox security
```

## Updating your submodule

Run the command below locally on your project:

```
git submodule update --remote --merge
```

Commit and deploy after updating.

## Usage with Laravel Forge

### 1. Forge Deploy Script

Add this **as the last step** in your deploy script before ACTIVATE_RELEASE():

```bash
# Initialize and update the submodule to make sure the security folder is populated
git submodule init
git submodule update --recursive

# Check if the security directory exists
if [ ! -d "$FORGE_RELEASE_DIRECTORY/security" ]; then
    echo "Security directory not found in release directory!"
    exit 1
fi

# Ensure scripts are executable
chmod +x security/*.sh

# Run integrity check BEFORE activation
./security/check-integrity.sh || exit 1

# Activate only if checks pass
$ACTIVATE_RELEASE()
```

If modified files are detected:

* Deploy fails
* You are notified immediately
* Compromised state is not hidden by a successful deploy

---

### 2. Forge Cron Job (recommended)

Run every 30 minutes:

```bash
*/30 * * * * /home/forge/site/current/security/cron-integrity.sh
```

Behavior:

* Silent on success
* Emails on failure (Forge default cron behavior)

This provides **early detection**, even without deploys.

---

## What gets detected

### File modifications

Examples:

```
 M web/.htaccess
 M web/app/themes/custom/functions.php
```

Common causes:

* Malware injection
* Unauthorized admin edits
* Server-level compromise

---

### New PHP files

Examples:

```
web/app/uploads/texts.php
web/app/themes/custom/cache.php
```

These are classic web shell indicators.

---

## Avoiding false positives

Ensure your `.gitignore` excludes:

```
.env
web/app/uploads/
cache/
logs/
storage/
```

Only **immutable, versioned files** should be tracked.

---

## Recommended hardening (outside this repo)

This toolbox works best when paired with:

* `DISALLOW_FILE_EDIT` and `DISALLOW_FILE_MODS`
* Read-only filesystem for WordPress files
* PHP execution disabled in uploads
* Media offloaded to S3 / Spaces
* Periodic Composer updates (monthly / quarterly)

---

## Why Bedrock

Bedrock makes this approach practical because:

* WordPress core is managed via Composer
* Config is environment-based
* Directory structure is predictable
* Git-first workflows are natural

Legacy WordPress installs can use this, but results vary.

---

## Intended audience

* Small agencies
* Solo developers
* Teams running WordPress as a CMS, not a playground
* People who prefer **boring, proven infrastructure**

---

## License

MIT - use it, fork it, adapt it.

If this saves you from a reinfection, that’s already a win.

---

Built by **Tigasoft Solutions**
Designed for production, not hype.
