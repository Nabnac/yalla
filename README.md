# CVE Database for Kandji

This repository contains an automated CVE (Common Vulnerabilities and Exposures) database used by Kandji custom scripts to scan macOS systems for vulnerable packages.

## Overview

- **Automated Updates**: GitHub Actions updates the CVE database daily
- **No Rate Limits**: Kandji scripts fetch from this repo instead of hitting NVD API directly
- **Package Coverage**: Monitors common packages like git, curl, openssl, python, node.js, etc.

## Structure

```
cve-data/
├── manifest.json       # Index of available packages
├── metadata.json       # Update timestamp and statistics
├── {package}.json.gz   # Compressed CVE data per package
└── previews/          # Human-readable samples
```

## Usage

The Kandji script automatically fetches CVE data from:
```
https://raw.githubusercontent.com/Nabnac/yalla/main/cve-data/{package}.json.gz
```

## Update Schedule

The CVE database is updated daily at 2 AM UTC via GitHub Actions.

## Manual Update

To trigger a manual update:
1. Go to [Actions](https://github.com/Nabnac/yalla/actions)
2. Select "Update CVE Database"
3. Click "Run workflow"

## Security

This is a public repository containing only CVE metadata. No sensitive information is stored here.
