// Who may read gunk-web (the-valley's schema/read.cue): one reader. A reader
// reads it at an edge only where the owning instance's identity registry
// grants that reader read of gunk-web there too.
package read

project:  "gunk-web"
identity: "0ca87e9f5d2a065676d43099914305af"
readers: patrick: true
