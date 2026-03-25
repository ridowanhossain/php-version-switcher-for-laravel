# PHP Version Switcher for Laravel

A simple Windows batch utility for managing multiple local PHP installations. Easily check the active version, switch between builds (PHP 5.6 to 8.5), or safely uninstall without deleting files.

![PHP Version Switcher Demo](./demo.png)

## Getting Started

1. Copy all your PHP builds into versioned folders (e.g., `php-5.6`, `php-8.4`) in the same directory as `php-switcher.bat`.
2. Add the active `php` directory to your Windows Environment Variables (`PATH`).
3. Launch the script via command prompt or by double-clicking it:

```powershell
.\php-switcher.bat
```

## Usage

Use the numbered options from the interactive menu:

- **1.** Check active PHP version
- **2.** Uninstall PHP (resets the active version to its folder)
- **3-14.** Switch to any PHP version from 5.6 up to 8.5
- **15.** Exit

## Important Notes

- **Portable:** The script automatically detects its location, making your PHP setup completely portable across drives or folders.
- **Conflicts:** If switching fails because a `php-<version>` folder already exists, delete/rename the conflicting folder and try again.
- **Permissions:** Run as Administrator if Windows blocks folder renaming.
