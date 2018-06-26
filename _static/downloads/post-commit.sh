#!/usr/bin/env bash
# get the name of the branch, only take actions when in master branch.
branch=$(git symbolic-ref HEAD | sed -e 's,.*/\(.*\),\1,')
target="master"
proj_name="machine-learning-course-notes"
if [ ${branch} = ${target} ]; then
    echo 'Now we are on master branch!'
    # use post-commit hook
    # i.e., after ``git add -A && git commit -m 'updated docs'``
    # we are placing ``git push`` at the end because this is a ``post-commit``
    # hook rather than ``post-push`` hook, which actually does not exist.
    echo '$ make html'
    make html
    echo 'Now running post-commit hook :D'
    echo '-------------------------'
    echo 'Step 1: start to mving html folder to /tmp dir ...'
    mv ~/PycharmProjects/${proj_name}/_build/html /tmp
    echo '>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>'
    echo ' '
    echo 'Step 2: checkout gh-pages branch ...'
    git checkout gh-pages
    echo '>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>'
    echo ' '
    # propagate changes in other branches
    # git fetch --all --prune
    echo 'Step 3: pull updates of gh-pages branch ...'
    git pull
    echo '>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>'
    echo ' '
    echo 'Step 4: copy html files to ${proj_name} dir ...'
    # use /tmp/html/* to move html files to /coding-notes dir
    # instead of moving /html folder to /coding-notes dir
    cp -vr /tmp/html/* ~/PycharmProjects/${proj_name}
    rm -rf /tmp/html
    echo '>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>'
    echo ' '
    echo 'Step 5: add & commit & push ...'
    git add -A && git commit -m 'updated docs in gh-pages' && git push
    echo '>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>'
    echo ' '
    echo 'Step 6: checkout master and push updates in master ...'
    git checkout master && git push
    echo '>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>'
    echo 'Gracefully Done.'
    # the ``yes`` prevents you to be prompted to confirm each overwrite
    # yes | copy -vr /tmp/html ~/PycharmProjects/coding-notes
else
    echo 'Now we are not in master branch, nothing to do for post-commit'
fi