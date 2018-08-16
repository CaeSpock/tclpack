# Ops.TCL v. 2.10
# By CaeSpock <cae@caespock.org>
#
# Sends a message to all @ps in a channel
# This tcl works only on DALnet due to the commands it use.

bind dcc o ops dcc_wall
bind dcc o opsv dcc_voz

proc dcc_voz {hand idx text} {
  global chan ops botnick

  if {[lindex $text 0] == ""} {
    putdcc $idx "Usage: .opsv <text>"
    return 0
  }

  if {[channels] == ""} {
    putdcc $idx "Im not on any channel!"
    return 0
  }

  set ops 0
  set chan [string tolower [lindex [console $idx] 0]]

  if {[lsearch -exact [string tolower [channels]] $chan] == -1} {
    putdcc $idx "Im not on $chan. Please change your console"
    putdcc $idx "to other channel, or type \".help console\"."
    return 0
  }

  if ![onchan $botnick $chan] {
    putdcc $idx "Hmm ... Im not on $chan right now."
    return 0
  }

  putlog "$hand \[OpsVoiced $chan\]:$text"
  putserv "NOTICE @+$chan :$hand: $text"
  return 1
}

proc dcc_wall {hand idx text} {
  global chan ops botnick

  if {[lindex $text 0] == ""} {
    putdcc $idx "Usage: .ops <texto>"
    return 0
  }

  if {[channels] == ""} {
    putdcc $idx "Im not on any channel!"
    return 0
  }

  set ops 0
  set chan [string tolower [lindex [console $idx] 0]]

  if {[lsearch -exact [string tolower [channels]] $chan] == -1} {
    putdcc $idx "Im not on $chan. Please change your console"
    putdcc $idx "to other channel, or type \".help console\"."
    return 0
  }

  if ![onchan $botnick $chan] {
    putdcc $idx "Weird.. Im not on $chan right now."
    return 0
  }

  if ![botisop $chan] {
    putdcc $idx "Im not an op at $chan."
    return 0
  }

  foreach user [chanlist $chan] {
    if [isop $user $chan] {set ops [expr $ops+1]}
  }

  if {$ops == 1} {
    putdcc $idx "There arent ops at $chan..."
    return 0
  }

  putlog "$hand \[Ops $chan ($ops)\]:$text"
  putserv "NOTICE @$chan :$hand: $text"
  return 1
}

putlog "Loaded: Ops.TCL 2.10 by CaeSpock!"

