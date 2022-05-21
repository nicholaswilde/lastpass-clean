# lastpass-clean

Bash scripts to help clean up a [LastPass][1] vault

> :warning: Warning: Theses scripts remove items from a LastPass vault! Use with cation!

## :rocket:&nbsp; TL;DR

```shell
brew install lastpass-cli jq whois
chmod +x check-urls.sh rm-dead-url-items.sh
./check-urls.sh dead-urls.csv
./rm-dead-url-items.sh dead-urls.csv
rm dead-urls.csv
```

## :framed_picture:&nbsp; Background

I have been using [LastPass][1] as my password manager for quite some time and now have over 1,000 items.
I have realized that a lot of my items haven't been used in quite some time and so I wanted to clean it up.
Going through all of the entries manually is a daunting task and so I decided to leverage [lastpass-cli][3] to automate the cleanup.

One cleanup task is to remove items to websites that no longer exist.
One way of doing this is to check if the `url` parameter is actually a dead url.
Sometime the sub domain isn't available anymore but the website still exists.

Another cleanup task is to rename the items. Since I am using the command line client more, I decided to replace spaces with
dashes and convert the names to lowercase to make it easier to work with the command prompt.

## :gear:&nbsp; Prerequisites

```shell
brew install lastpass-cli jq whois
# or
task deps
```

## :scroll:&nbsp; Scripts

| Script          | Description                                     |
|-----------------|-------------------------------------------------|
| `check-urls.sh`   | Check LastPass vault for dead urls              |
| `rm-dead-url-items.sh` | Remove items with dead urls from LastPass vault |
| `check-names.sh` | Check LastPass vault for items that need to be renamed |
| `rename-items.sh` | Rename items from LastPass vault |

## :floppy_disk:&nbsp; Backup

Be sure to backup the vault before using these scripts.

```shell
lpass export > backup.csv
# or
task backup
```

## :book:&nbsp; Usage

Make the scripts executable

```shell
chmod +x check-urls.sh rm-dead-url-items.sh check-names.sh rename-items.sh
```

### :link:&nbsp; Remove Dead URL Items

Check items for dead urls and export them to a csv file

```shell
./check-urls.sh dead-urls.csv
# or
task urls
```

Manually review the csv file to confirm that there aren't any items that should not be deleted.

Remove the items with dead urls.

```shell
./rm-dead-url-items.sh dead-urls.csv
# or
task rm
```

Remove the dead url csv file.

```shell
rm dead-urls.csv
```

### :open_file_folder:&nbsp; Rename Items

WIP

## :balance_scale:&nbsp; License

[Apache 2.0 License](../LICENSE)

## :pencil:&nbsp; Author

This project was started in 2022 by [Nicholas Wilde][2].

[1]: https://www.lastpass.com/
[2]: https://github.com/nicholaswilde/
[3]: https://github.com/lastpass/lastpass-cli/
