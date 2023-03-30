# iac_backup

This project is a Bash script that enables users to create automated backups and restores of their important files and data. By utilizing Bash and cronjobs, the script can run seamlessly in the background without requiring any manual intervention.

## Usage

```Bash
Usage: localBackup [options] <parameter>
Create, control and restore to backup.
          
This is a command line utility for backup-script, a
service that manages data on linux systems.
          
Options:
  -h, --help        Displays help on commandline options
  -b, --backup      Start a backup
  -l, --list        List available backups
  -r, --restore     Restore a backup
  -n, --name        Backup name
  -s, --source      Set source
  -d, --destination Set destination
```
> This script can be combinded with cron-jobs to automate the backup.
## License

This project is licensed under the [MIT License](https://opensource.org/licenses/MIT). See the [LICENSE](LICENSE) file for details.

## Author Information

This code was created in 2023 by [Yves Wetter](mailto:yves.wetter@edu.tbz.ch).
