# RelaySpy.TCL v. 1.0.1
# by CaeSpock <cae@bolivia-internet.com>

# Configuration:
# Please inser here the relay or the nick to relay all actions on channels.

# Please make the bot join this channel, just for security purposes.
# if its a nick... well. dont go offline!!!
set relaychannel "#RelayPrivate"

# [0/1] Relay to everybody in the partyline AND the botnet ?
# Means to EVERYBODY in local and remote bots!
# if this is set to 1, it wont relay to a channel or nick, just to the partyline!
set relaytopartyline 0

#What channels to spy? comma separated! :)
set spychannels "#chan1 #chan2"

# Lets define what to relay here...
# If you want it to relay, leave the bind, if not
# comment it adding a # character at the beggining

# Want to catch public messages ?
bind pubm - * message
bind pub - * message

# Want to catch messages to the bot ?
bind msg - * message2
bind msgm - * message2

# Want to catch CTCP Actions ? like /me jumps
bind ctcp - ACTION ctcp

# Want to catch all notices sent to the bot ?
# This includes /notice #channel bleh
# but also all services notices.
bind raw - NOTICE raw

# Want to catch join part quits ?
bind join - * join
bind part - * part
bind sign - * sign

# Want to catch kicks?
bind kick - * kick

# Want to catch nick changes ?
bind nick - * nick

# Want to catch mode changes ?
bind mode - * mode

##You shouldnt have to modify anything from here:

proc message {nick uhost hand ch rest} {
  set destination_message "($ch) <$nick!$uhost> $rest"
  send_message $ch $destination_message
}

proc notice {nick uhost hand rest} {
  set destination_message "-$nick!$uhost- $rest"
  send_message $nick $destination_message
}

proc message2 {nick uhost hand rest} {
  set destination_message "*$nick!$uhost* $rest"
  send_message $nick $destination_message
}

proc ctcp { nk uh hd ch kw arg } {
  set destination_message "($ch) * $nk!$uh $arg"
  send_message $ch $destination_message
}

proc raw { fr key arg } {
  set destination_message "-$fr- $key $arg"
  send_message $fr $destination_message
}

proc join { ni uh ha ch } {
  set destination_message "($ch) $ni ($uh) has joined $ch"
  send_message $ch $destination_message
}

proc part { ni uh ha ch } {
  set destination_message "($ch) $ni ($uh) has left $ch"
  send_message $ch $destination_message
}

proc sign { ni uh ha ch re } {
  set destination_message "($ch) $ni ($uh) quit ($re)"
  send_message $ch $destination_message
}

proc kick { ni uh hd ch tg rn } {
  set destination_message "($ch) $tg was kicked by $ni ($rn)"
  send_message $ch $destination_message
}

proc nick { ni uh hd ch nn } {
  set destination_message "($ch) $ni!$uh is now known as $n"
  send_message $ch $destination_message
}

proc mode { ni uh hd ch mc vi } {
  set destination_message "($ch) $ni!$uh sets mode $mc $vi"
  send_message $ch $destination_message
}

proc send_message { fromwho message } {
 global relaychannel spychannels relaytopartyline
 
  if { [string compare [string tolower $relaychannel] [string tolower $fromwho]] == 0 } {
	return 1
  }
  set number_channels [llength $spychannels]
  for {set contador 0} {$contador < $number_channels} {incr contador} {
      if {[string compare [string tolower [lindex $spychannels $contador]] [string tolower $fromwho]] == 0 } {
        if { $relaytopartyline == 1 } {
             dccbroadcast "$message"
        }
	puthelp "privmsg $relaychannel :$message"
      }
  }
}

putlog "Loaded: RelaySpy.TCL v1.0.1 by CaeSpock!"
