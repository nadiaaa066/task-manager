#!/bin/bash

TASK_FILE=$1
TEST_FILE=$2

TODO_TASKS=$(awk '/ToDo Tasks:/{flag=1;next}/Done Tasks:/{flag=0}flag' "$TASK_FILE")

DONE_TASKS=$(awk '/Done Tasks:/{flag=1;next}flag' "$TASK_FILE")

TEST_RESULTS=$(cat "$TEST_FILE")

update_pre() {
    ID=$1
    CONTENT=$2
    FILE=$3

    perl -0777 -i -pe \
    "s|(<pre id=\"$ID\">).*?(</pre>)|\$1\n$CONTENT\n\$2|s" \
    "$FILE"
}

update_pre "todo" "$TODO_TASKS" "index.html"
update_pre "done" "$DONE_TASKS" "index.html"
update_pre "tests" "$TEST_RESULTS" "index.html"

git config --global user.name "github-actions"
git config --global user.email "github-actions@users.noreply.github.com"

git add index.html
git commit -m "Update task report" || true
