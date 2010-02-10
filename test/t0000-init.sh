#! /bin/sh

test_description='gitbug init test

This test covers the gitbug-init commands

'

. ./test-lib.sh

fresh_repo () {
    test_create_repo "$TEST_DIRECTORY/$test/t$test_count" &&
    cd "$TEST_DIRECTORY/$test/t$test_count" &&
    test_tick || return 1
}

init_test() {
    gitbug init || return 1
    git diff && git diff --cached || return 1
    [ -z "$(git ls-files --others)" ] || return 1
    templ_tree=$(git rev-parse --verify HEAD:bugs/templates) || return 1
    [ "$templ_tree" == 07de27f8daf16af90f3aaa17608f9f4899280d8c ] ||
    fail "The tree hash for bugs/templates has changed," \
        "if you changed its contents, then this is expected, " \
        "use 'git rev-parse HEAD:bugs/templates' to find the new hash" \
        "And fix it in $0"
}

test_expect_success \
    'gitbug init from the root of a fresh git repo' \
    'fresh_repo &&
     init_test'

test_expect_success \
    'gitbug init from the root of a repo with changes' \
    'fresh_repo && mkdir a b c &&
     test_commit "add-a" a/a &&
     test_commit "add-b" b/b &&
     test_commit "add-c" c/c &&
     init_test'

test_expect_failure \
    'gitbug init from a subdir of a fresh git repo' \
    'fresh_repo && mkdir a && cd a &&
     init_test'

test_expect_failure \
    'gitbug init from a subdir of a repo with changes' \
    'fresh_repo && mkdir a && test_commit "add-a" a/a && cd a &&
     init_test'

test_done
