require 'rake/clean'
CLEAN.include(["*.~","*/\#*", "*/**/.\#*"])
CLOBBER.include("*/**/*.yaml")
