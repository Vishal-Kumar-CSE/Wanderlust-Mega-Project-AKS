: <<'EOF'
#!/bin/bash

# Fetch the public IP of the frontend service in AKS
frontend_ip=$(kubectl get svc frontend-service -o jsonpath='{.status.loadBalancer.ingress[0].ip}')

# Initialize variables
file_to_find="../backend/.env.docker"
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

# Check if frontend_ip is empty
if [[ -z "$frontend_ip" ]]; then
    echo -e "${RED}ERROR: Could not retrieve frontend-service IP. Is the service running?${NC}"
    exit 1
fi

echo -e " ${GREEN}AKS Frontend Public IPv4 address ${NC} : ${frontend_ip}"

# Check if .env.docker contains FRONTEND_URL
if grep -q "FRONTEND_URL=\"http://${frontend_ip}:5173\"" "$file_to_find"; then
    echo -e "${YELLOW}${file_to_find} is already updated to the current frontend IP.${NC}"
else
    if [[ -f "$file_to_find" ]]; then
        echo -e "${GREEN}${file_to_find}${NC} found.."
        echo -e "${YELLOW}Configuring env variables in ${NC} ${file_to_find}"
        sleep 7s
        sed -i -E "s|FRONTEND_URL=.*|FRONTEND_URL=\"http://${frontend_ip}:5173\"|g" "$file_to_find"
        echo -e "${GREEN}Environment variables updated successfully.${NC}"
    else
        echo -e "${RED}ERROR: File not found: ${file_to_find}${NC}"
        exit 1
    fi
fi
EOF
