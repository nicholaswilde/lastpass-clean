# lastpass-clean

Bash scripts to help clean up a [LastPass][1] vault

> :warning: Warning: Theses scripts remove items from a LastPass vault! Use with cation!

## :rocket:&nbsp; TL;DR

```shell
brew install lastpass-cli jq
chmod +x check-urls.sh rm-dead-url-items.sh
./check-urls.sh dead-urls.txt
./rm-dead-url-items.sh dead-urls.txt
rm dead-urls.txt
```

## :framed_picture:&nbsp; Background

I have been using [LastPass][1] as my password manager for quite some time and now have over 1,000 items.
I have realized that a lot of my items haven't been used in quite some time and so I wanted to clean it up.
Going through all of the entries manually is a daunting task and so I decided to leverage [lastpass-cli][3] to automate the cleanup.

One cleanup task is to remove items to websites that no longer exist.
One way of doing this is to check if the `url` parameter is actually a dead url.
Sometime the sub domain isn't available anymore but the website still exists.

Another cleanup task is to rename the items. Since I am using the command line client more, I decided to replace spaces with
dashes and convert the names to lowercase.

## :chess_pawn:&nbsp; Prerequisites

```shell
brew install lastpass-cli jq
```

## :scroll:&nbsp; Scripts

| Script          | Description                                     |
|-----------------|-------------------------------------------------|
| `check-urls.sh`   | Check LastPass vault for dead urls              |
| `rm-dead-url-items.sh` | Remove items with dead urls from LastPass vault |

## :book:&nbsp; Usage

```shell
# Make the scripts executable
chmod +x check-urls.sh rm-dead-urls.sh
# Check items for dead urls and export them to a text file
./check-urls.sh dead-urls.txt
# Manually review the text file to confirm that there aren't any items that should not be deleted.
# Remove the items with dead urls.
./rm-dead-url-items.sh dead-urls.txt
# Remove the bad url text file.
rm bad-urls.txt
```

## :balance_scale:&nbsp; License

[Apache 2.0 License](../LICENSE)

## :pencil:&nbsp; Author

This project was started in 2022 by [Nicholas Wilde][2].

[1]: https://www.lastpass.com/
[2]: https://github.com/nicholaswilde/
[3]: https://github.com/lastpass/lastpass-cli/
