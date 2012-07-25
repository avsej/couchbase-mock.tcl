#!/bin/sh
# the next line ignored by Tcl \
exec tclsh "$0" "$@"

package require logger
set log [logger::init main]

source [file join [file dirname [info script]] mock.tcl]

mock::init

if {![info exists forever]} {
    set forever 1
    vwait forever
}

