# Image Optimization Hook

This repository includes a script `hooks/optimize-images.ps1` you can wire into a Git pre-commit hook to automatically compress PNG images.

## Why

Reducing image payload speeds up page loads and improves Core Web Vitals (Largest Contentful Paint). The script performs loss-limited palette reduction and stripping of metadata only when the result is smaller.

## Usage

1. Ensure ImageMagick (`magick`) is installed and available in PATH.
2. Configure Git to use a custom hooks path (optional but recommended):

   ```powershell
   git config core.hooksPath hooks
   ```

3. Create a pre-commit hook that invokes the script:

   ```powershell
   # File: hooks/pre-commit (PowerShell on Windows Git >=2.44 supports .ps1 via shebang not always; call explicitly)
   powershell -ExecutionPolicy Bypass -File "$(git rev-parse --show-toplevel)\hooks\optimize-images.ps1" -Colors 32
   git add static/images/*.png
   ```

4. Make the hook executable (Git Bash):

   ```bash
   chmod +x hooks/pre-commit
   ```

## Customization

- Adjust `-Colors 32` to a different palette size (e.g., 64 or 128) if banding appears.
- To scope only changed files, replace enumeration with staged list:

   ```powershell
   $staged = git diff --cached --name-only --diff-filter=AM | Select-String -Pattern '\.png$' | ForEach-Object { $_.ToString() }
   foreach ($f in $staged) { # optimize $f exactly }
   ```

## Safety

The script only overwrites when the optimized version is smaller.

## Future Enhancements

- Add WebP generation alongside PNG for browsers supporting it.
- Integrate CI check to fail if images exceed size thresholds.
