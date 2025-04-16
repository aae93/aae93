# 🔍 Config Diff Script

This script compares configuration files inside a `.tar.gz` archive against their current versions in your working directory.

---

## ⚙️ What It Does

- 📦 Extracts the archive into the `example_config/` folder (only once)
- 🚫 Skips re-extraction if the folder already exists and is not empty
- 🧹 Compares only meaningful lines:
  - Ignores comment lines (starting with `#` or `;`)
  - Ignores `README` and `README.md` files
- 🎨 Highlights **only the actual differences**:
  - 🔴 `+` lines exist in the archive but not in the current version
  - 🟢 `-` lines exist in the current version but not in the archive
- 📝 Saves all differences into `example_config/diff_report.txt`

---

## 🚀 How to Use

1. Make sure your archive is available, for example:
   ```
   configs.tar.gz
   ```

2. Run the script:

   ```bash
   python compare_configs.py configs.tar.gz
   ```

---

## 📂 Example Output

```
📄 etc/nginx/nginx.conf
+worker_processes auto;
-user nginx;

📄 config/app.yaml
+debug: false
-debug: true
```

---

## 📁 Output Location

- Extracted configs: `example_config/`
- Diff report: `example_config/diff_report.txt`

---

## ❗ Notes

- If you modify the archive and want to force re-extraction, simply delete the `example_config/` folder manually
- The script compares only non-comment lines
- The output is both printed to terminal and saved to a file

---

🔧 Great for DevOps, CI/CD, configuration audit and change tracking.
