# RelayAll.TCL v. 1.0
# by CaeSpock <cae@bolivia-internet.com>

#Configuration:
# Please inser here the relay or the nick to relay all actions on channels.

#Please make the bot join this channel, just for security purposes.
#if its a nick... well. dont go offline!!!
set relaychannel "#AllPrivate"

#Bind Messages:
bind pubm - * message
bind pub - * message
bind msg - * message2
bind msgm - * message2
bind ctcp - ACTION ctcp
bind raw - NOTICE raw
bind join - * join
bind part - * part
bind sign - * sign
bind kick - * kick
bind nick - * nick
bind mode - * mode

##Patada Insultos:

proc message {nick uhost hand ch rest} {
  global relaychannel
  if { [string compare [string tolower $relaychannel] [string tolower $ch]] == 0 } {
	return 1
  }
  puthelp "privmsg $relaychannel :($ch) <$nick!$uhost> $rest"
  return 1
}

proc notice {nick uhost hand rest} {
  global relaychannel
  puthelp "privmsg $relaychannel :-$nick!$uhost- $rest"
  return 1
}

proc message2 {nick uhost hand rest} {
  global relaychannel
  puthelp "privmsg $relaychannel :*$nick!$uhost* $rest"
  return 1
}

proc ctcp { nk uh hd ch kw arg } {
  global relaychannel
  if { [string compare [string tolower $relaychannel] [string tolower $ch]] == 0 } {
	return 1
  }
  puthelp "privmsg $relaychannel :($ch) * $nk!$uh $arg"
  return 1
}

proc raw { fr key arg } {
  global relaychannel
  puthelp "privmsg $relaychannel :-$fr- $key $arg"
  return 1
}

proc join { ni uh ha ch } {
  global relaychannel
  if { [string compare [string tolower $relaychannel] [string tolower $ch]] == 0 } {
	return 1
  }
  puthelp "privmsg $relaychannel :($ch) $ni ($uh) has joined $ch"
  return 1
}

proc part { ni uh ha ch } {
  global relaychannel
  if { [string compare [string tolower $relaychannel] [string tolower $ch]] == 0 } {
	return 1
  }
  puthelp "privmsg $relaychannel :($ch) $ni ($uh) has left $ch"
  return 1
}

proc sign { ni uh ha ch re } {
  global relaychannel
  if { [string compare [string tolower $relaychannel] [string tolower $ch]] == 0 } {
	return 1
  }
  puthelp "privmsg $relaychannel :($ch) $ni ($uh) quit ($re)"
  return 1
}

proc kick { ni uh hd ch tg rn } {
  global relaychannel
  if { [string compare [string tolower $relaychannel] [string tolower $ch]] == 0 } {
	return 1
  }
  puthelp "privmsg $relaychannel :($ch) $tg was kicked by $ni ($rn)"
  return 1
}

proc nick { ni uh hd ch nn } {
  global relaychannel
  if { [string compare [string tolower $relaychannel] [string tolower $ch]] == 0 } {
	return 1
  }
  puthelp "privmsg $relaychannel :($ch) $ni!$uh is now known as $nn"
  return 1
}

proc mode { ni uh hd ch mc vi } {
  global relaychannel
  if { [string compare [string tolower $relaychannel] [string tolower $ch]] == 0 } {
	return 1
  }
  puthelp "privmsg $relaychannel :($ch) $ni!$uh sets mode $mc $vi"
  return 1
}

putlog "Loaded: RelayAll.TCL v1.0 by CaeSpock!"
