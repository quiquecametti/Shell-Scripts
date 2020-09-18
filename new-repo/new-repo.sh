#!/bin/bash

# Uses curl and GitHub API to create a new repository
#Default Options from GitHub API found here https://developer.github.com/v3/repos/#create-a-repository-for-the-authenticated-user
api_link='https://api.github.com/user/repos'
repo_link=''
upload_folder=false
user='' name='' description='' homepage=''
# Personal and Orgeanization Patrameters
private=false is_template=false auto_init=false delete_branch_on_merge=false
has_issues=true has_projects=true has_wiki=true use_ssh=false
allow_squash_merge=true allow_merge_commit=true allow_rebase_merge=true
#local json_conf=''
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
while (( "$#" ))
do
    case ${1} in
        # Personal and Organization Parameters
        -u|--user) shift;user=${1};;
        -n|--name) shift;name=${1};;
        -d|--description) shift;description=${1};;
        -w|--homepage) shift;homepage=${1};;
        -pr|--private) private=true;;
        -nI|--noIssues) has_issues=false;;
        -nP|--noProjects) has_projects=false;;
        -nW|--noWiki) has_wiki=false;;
        -t|--isTemplate) is_template=true;;
        -aI|--autoInit) auto_init=true;;
        -nSM|--noSquashMerge) allow_squash_merge=false;;
        -nMC|--noMergeCommit) allow_merge_commit=false;;
        -nRM|--noRebaseMerge) allow_rebase_merge=false;;
        -dBoM|--deleteBranchonMerge) delete_branch_on_merge=true;;
        --token)
            shift
            if [ -f $1 ]; then
                cp $1 $DIR/github_${user}.token
            else
                echo ${1} > $DIR/github_${user}.token;
            fi
            exit 0;;
        --removeToken) rm $DIR/github_${user}.token;exit 0;;
        --ssh) use_ssh=true;;
        -uF|--uploadFolder) upload_folder=true;;
        #-j|--json)
        -h|--help) cat $DIR/new-repo.help;exit 0;;
        *) echo "ALERT: ${1} is not a parameter.";exit 1;;
        # Organization Parameters
    esac
    shift
done
if [ -z $name ]
then
    echo "ALERT: Repository must have a name. Please enter the name."
    read name
    echo "Name : ${name}"
fi

json_conf='{
    "name":"'"${name}"'",
    "description":"'"${description}"'",
    "homepage":"'"${homepage}"'",
    "private":'$private',
    "has_issues":'$has_issues',
    "has_projects":'$has_projects',
    "has_wiki":'$has_wiki',
    "is_template":'$is_template',
    "auto_init":'$auto_init',
    "allow_squash_merge":'$allow_squash_merge',
    "allow_merge_commit":'$allow_merge_commit',
    "allow_rebase_merge":'$allow_rebase_merge',
    "delete_branch_on_merge":'$delete_branch_on_merge'
}'

echo $json_conf > /tmp/new_repo.json

if [ -f ${DIR}/github_${user}.token ]; then
    token=$(cat "$DIR/github_${user}.token")
    curl -X POST -u $user:$token $api_link -d "@/tmp/new_repo.json" > /tmp/new-repo.log
else
    echo "No Token"
    curl -X POST -u $user $api_link -d "@/tmp/new_repo.json" > /tmp/new-repo.log
fi

cat /tmp/new-repo.log
if [[ $use_ssh = true ]]; then
    repo_link="git@github.com:$user/${name// /-}.git"
else
    repo_link="https://github.com/$user/${name// /-}"
fi
if [ ${upload_folder} = true ] ; then
    if [[ -d "./.git" ]]; then
        git remote add origin $repo_link
        git branch -M main
        git push -u origin main
    else
        git init
        git add .
        git commit -m "first commit"
        git branch -M main
        git remote add origin $repo_link
        git push -u origin main
    fi

else
    echo ""
    echo "Create a new repository on the command line"
    echo 'echo "# '${name// /-}'" >> README.md'
    echo "git init"
    echo "git add README.md"
    echo 'git commit -m "first commit"'
    echo "git branch -M main"
    echo "git remote add origin $repo_link"
    echo "git push -u origin main"
    echo ""
    echo "Push an existing repository from the command line"
    echo "git remote add origin $repo_link"
    echo "git branch -M main"
    echo "git push -u origin main"
fi
