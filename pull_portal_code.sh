#!/bin/sh

present_working_directory=$(pwd)
front_end="${present_working_directory}/portal-client"
back_end="${present_working_directory}/portal"
front_end_git_link="https://github.com/Akash76/portal-client.git"
back_end_git_link="https://github.com/Akash76/portal.git"
front_end_image_name="portal_frontend_image"
back_end_image_name="portal_backend_image"


function fail {
    printf '%s\n' "$1" >&2  ## Send message to stderr. Exclude >&2 if you don't want it that way.
    cd ${present_working_directory}
    exit "${2-1}"  ## Return a code specified by $2 or 1 by default.
}

function clone_and_verify {
    directory="$1"
    git_link="$2"
    cd "$present_working_directory" && git clone "$git_link"
    if [ -e "$directory"/Dockerfile ]
    then
        echo -e "\ncode pull successful from $git_link\n"
    else
        fail "failed code pull"
    fi
}


rm -rf ${front_end} ${back_end} || fail "failed to delete portal directories"
clone_and_verify ${front_end} ${front_end_git_link}
clone_and_verify ${back_end} ${back_end_git_link}

cd ${front_end} && docker build -t ${front_end_image_name} . || fail "failed to create docker image for front end"
echo -e "\nsuccessfully created docker image for $front_end_image_name\n"

cd ${back_end} && docker build -t ${back_end_image_name} . || fail "failed to create docker image for back end"
echo -e "\nsuccessfully created docker image for $back_end_image_name\n"

cd ${present_working_directory} && docker compose up -d || fail "failed docker compose command"


