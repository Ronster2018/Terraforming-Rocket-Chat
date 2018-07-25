# Terraform
Automatically setting up a server and deploying web applications. 

1. Create a private key
    "$ openssl genpkey -algorithm RSA - out *secret_key.*pem -pkeyopt rsa_keygen_bits:2048"
2. Crete Public Key
    "$ openssl rsa -pubout -in secret_key.pem -out public_key.pem"
3. Download terraform to your machine
4. Move the terraform executable to either your usr/local/bin or variable Paths
5. Navigate to access.tf and add your AWS access and secret key
6. Navigate to variables.tf and add your public key and the names of any security group.
7. In the terminal, run Terraform Plan and check the output
8. In the terminal, run Terraform Apply
9. Check AWS console to see if the instance has started.
10. SSH into the instance using your private key

1. Setting up the server through SSH. 
    echo 'http://the_new_ec2_instance.amazon.com
    proxy / localhost:3000{
      websocket
      transparent
    }' >/var/snap/rocketchat-server/current/Caddyfile
2. sudo systemctl restart snap.rocketchat-server.rocketchat-caddy
3. sudo systemctl status snap.rocketchat-server.rocketchat-caddy
