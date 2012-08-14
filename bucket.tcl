namespace eval bucket {
    set CasSequence [clock seconds]
    array set Storage {}
    array set VbucketMap {}

    proc create {{name default}} {
        if {[info exists Storage($name)]} {
            error "The bucket with given name already exists"
        }
        set Storage($name) [dict create]
        set VbucketMap($name) {}
        return $name
    }

    proc set {bucket key value flags} {
        set cas [incr CasSequence]]
        dict set Storage($bucket) $key [list $value $flags $cas]
        return $cas
    }
}
