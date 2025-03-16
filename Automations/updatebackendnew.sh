#!/bin/bash

# Fetch the public IP of the frontend service in AKS
frontend_ip=$(kubectl get svc frontend-service -o jsonpath='{.status.loadBalancer.ingress[0].ip}')

# Initialize variables
file_to_find="../backend/.env.docker"
alreadyUpdate=$(sed -n "4p" ../backend/.env.docker)
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

echo -e " ${GREEN}AKS Frontend Public IPv4 address ${NC} : ${frontend_ip}"

if [[ "${alreadyUpdate}" == "FRONTEND_URL=\"http://${frontend_ip}:5173\"" ]]
then
        echo -e "${YELLOW}${file_to_find} file is already updated to the current host's IPv4 ${NC}"
else
        if [ -f ${file_to_find} ]
        then
                echo -e "${GREEN}${file_to_find}${NC} found.."
                echo -e "${YELLOW}Configuring env variables in ${NC} ${file_to_find}"
                sleep 7s;
                sed -i -e "s|FRONTEND_URL.*|FRONTEND_URL=\"http://${frontend_ip}:5173\"|g" ${file_to_find}
                echo -e "${GREEN}env variables configured..${NC}"
        else
                echo -e "${RED}ERROR : File not found..${NC}"
        fi
fi

