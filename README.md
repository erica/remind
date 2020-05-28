# remind

A simple notification-center reminder app that uses the [Swift Argument Parser](https://github.com/apple/swift-argument-parser).

This project uses a build phase to install to /usr/local/bin. Make sure you can write to that folder or change the build phase.

```
OVERVIEW: Command-line notifier

Schedule reminders from the command line. "remind -m 20 Stand up and stretch",
"remind --at 1:30P Call Bob", "remind --at 13:30 Leave for Dr visit". Any
notifications scheduled earlier in the day (say it is now 2PM and you set a
reminder for 11:30), are pushed forward one day.

USAGE: remind [<message> ...] [--minutes <minutes>] [--hours <hours>] [--days <days>] [--when <when>] [--list]

ARGUMENTS:
  <message>               Notification message. 

OPTIONS:
  -m, --minutes <minutes> Delay in minutes. (default: 0)
  -h, --hours <hours>     Delay in hours. (default: 0)
  -d, --days <days>       Delay in days. (default: 0)
  -t, --at, --time, --when <when>
                          Sets time for scheduled reminder. 
  -l, --list              Lists scheduled notifications then quits. 
  --help                  Show help information.

```

## Installation

* Install [homebrew](https://brew.sh).
* Install [mint](https://github.com/yonaskolb/Mint) with homebrew (`brew install mint`).
* From command line: `mint install erica/remind`

## Build notes

* This project includes a build phase that writes to /usr/local/bin
* Make sure your /usr/local/bin is writable: `chmod u+w /usr/local/bin`
