#!/bin/bash

# Retrieve the public IP address of the backend service in AKS
backend_ip=$(kubectl get svc backend-service -o jsonpath='{.status.loadBalancer.ingress[0].ip}')

# Initialize variables
file_to_find="../frontend/.env.docker"
alreadyUpdate=$(cat ../frontend/.env.docker)
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

echo -e " ${GREEN}AKS Backend Public IPv4 address ${NC} : ${backend_ip}"

if [[ "${alreadyUpdate}" == "VITE_API_PATH=\"http://${backend_ip}:31100\"" ]]
then
        echo -e "${YELLOW}${file_to_find} file is already updated to the current backend IP ${NC}"
else
        if [ -f ${file_to_find} ]
        then
                echo -e "${GREEN}${file_to_find}${NC} found.."
                echo -e "${YELLOW}Configuring env variables in ${NC} ${file_to_find}"
                sleep 7s;
                sed -i -e "s|VITE_API_PATH.*|VITE_API_PATH=\"http://${backend_ip}:31100\"|g" ${file_to_find}
                echo -e "${GREEN}env variables configured..${NC}"
        else
                echo -e "${RED}ERROR : File not found..${NC}"
        fi
fi

