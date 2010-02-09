#! /bin/sh

test_description='gitbug init test

This test covers the gitbug-init commands

'

. ./test-lib.sh

test_tick

test_expect_success \
    'gitbug init from the root of a fresh git repo' \
    'gitbug init &&
     test -d bugs &&
     git diff && git diff --cached &&
     head=$(git rev-parse --verify HEAD) &&
     echo $head &&
     [ "$head" == 0b5f455ecb1873caabc1c34f6c6167a059c87474 ]'

test_done
