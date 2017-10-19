# SpamChecker.TCL v. 1.0
# by CaeSpock <cae@bolivia-internet.com>

## This script will help in the spam catching function.
## Create a channel, make the bot join it, configure the script and use it.
## With this script you can ask the bot to periodically (timed joins) join a 
## a channel or a list of channels and also you can ask the bot to join and 
## part channels that arent in that list.

## Configuration:

## Channel where all the relay stuff will go.
## This is also the channel where all the input and commands go.
## You must define this channel at the eggdrop.conf
set relaychannel "#CaePrivate"

## Time (in minutes) to wait in the channel, after joining, before parting
set wait_in 1

## After how many minutes join afain the static channels list
## This number should always be greater that the wait_in
set min_timed_joins 20

## All the channels we will periodically join
set static_channels {
	"#channel1"
	"#channel2"
	"#channel3"
	"#channel4"
	"#channel5"
	"#channel6"
}

## [0/1] By default start to join the static channels list?
set static_join 1

# ############################################################# #
# # You shouldnt have to modify nothing from here :P          # #
# ############################################################# #

## Binds
## AS defined here, only people defined as "OPS" in the bot can execute the commands
bind pub o !check pub_check
bind pub o !stj pub_start_timed_join
bind pub o !etj pub_end_timed_join
bind msgm - * message
bind notc - * notice
bind raw - INVITE invite

proc pub_check {nick uhost hand channel arg} {
  global relaychannel
  if {[string toupper $channel] != [string toupper $relaychannel]} {
    return 0
  }
  if {[string toupper $arg] == [string toupper $relaychannel]} {
    return 0
  }
  if {$arg == ""} {
    puthelp "notice $nick :4\[12SpamChecker:4\] Usage: !check <#Channel>"
    return 0
  }
  if {[string index $arg 0] != "#" } {
    puthelp "notice $nick :4\[12SpamChecker:4\] Usage: !check <#Channel> dont forget the #!"
    return 0
  }
  channel_join $arg
  return 0
}

proc channel_join { chan } {
  global relaychannel wait_in
  puthelp "PRIVMSG $relaychannel :4\[12SpamChecker:4\] Joining $chan at \[[date]|[time]\]"
  channel add $chan {
  chanmode ""
  idle-kick 0
  need-op {  }
  need-invite { }
  need-key {  }
  need-unban {  }
  need-limit {  }
  flood-chan 10:60
  flood-deop 3:10
  flood-kick 3:10
  flood-join 5:60
  flood-ctcp 3:60
  }
  channel set $chan 
  timer $wait_in "channel_part $chan"
}

proc channel_part { chan } {
  global relaychannel
  puthelp "PRIVMSG $relaychannel :4\[12SpamChecker:4\] Parting $chan at \[[date]|[time]\]"
  channel remove $chan
}

proc message {nick uhost hand rest} {
  global relaychannel
  puthelp "privmsg $relaychannel :\[[date]|[time]\] *$nick!$uhost* $rest"
  return 1
}

proc notice { nick uhost hand rest } {
  global relaychannel
  puthelp "privmsg $relaychannel :\[[date]|[time]\] -$uhost- $rest"
  return 1
}

proc invite { fro keyw arg } {
  global relaychannel
  puthelp "privmsg $relaychannel :\[[date]|[time]\] -$fro- $keyw $arg"
  return 1
}

proc timed_join { } {
  global relaychannel min_timed_joins static_channels static_join _timed_joins_checker
  unset _timed_joins_checker
  foreach channel_to_join $static_channels {
    channel_join $channel_to_join
  }
  if { $static_join == 1 } {
    if { [info exists _timed_joins_checker] } { killtimer $_timed_joins_checker }
       set _timed_joins_checker [timer $min_timed_joins timed_join]
  }
}

proc pub_start_timed_join {nick uhost hand channel arg} {
  global relaychannel min_timed_joins static_join
  if { $static_join == 1 } {
      puthelp "notice $nick :4\[12SpamChecker:4\] Timed Joins are already enabled!"
      return 0
  }
  set static_join 1
  puthelp "PRIVMSG $relaychannel :4\[12SpamChecker:4\] Starting Timed Joins every $min_timed_joins minutes at \[[date]|[time]\]"
  putlog "\[SpamChecker\] $nick Started Timed Joins ($min_timed_joins mins)"
  if { [info exists _timed_joins_checker] } { killtimer $_timed_joins_checker }
    set _timed_joins_checker [timer $min_timed_joins timed_join]
}

proc pub_end_timed_join {nick uhost hand channel arg} {
  global relaychannel static_join _timed_joins_checker
  if { $static_join == 0 } {
      puthelp "notice $nick :4\[12SpamChecker:4\] Timed Joins are already disabled!"
      return 0
  }
  puthelp "PRIVMSG $relaychannel :4\[12SpamChecker:4\] Stopping Timed Joins at \[[date]|[time]\]"
  puthelp "PRIVMSG $relaychannel :4\[12SpamChecker:4\] The bot wont load more timers."
  set static_join 0
  if { [info exists _timed_joins_checker] } { killtimer $_timed_joins_checker }
  unset _timed_joins_checker
  putlog "\[SpamChecker\] $nick Stopped Timed Joins."
}

if { [info exists _timed_joins_checker] } { killtimer $_timed_joins_checker }
    set _timed_joins_checker [timer $min_timed_joins timed_join]

putlog "Loaded: SpamChecker.TCL v1.0 by CaeSpock!"

