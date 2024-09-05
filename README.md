# HTTPS Mutual Authentication Middleware

A financial services client, interested in a network observability platform from a U.S. company, was facing a problem that one of the platform’s competitors had already solved—monitoring remote HTTPS endpoints that use mutual authentication for security. Sasquat Software stepped in at the request of the observability platform provider and built a solution that allowed it (and any other observability tool, for that matter) to monitor mutual authentication models without needing to develop new features in the platform itself.

This middleware complements observability services like Kentik by enabling mutual authentication for endpoints that require it. It acts as a bridge between the Kentik agent and the target endpoints, handling secure requests and responses. The middleware manages mutual authentication processes, allowing the Kentik agent to focus solely on its main function: collecting information from the monitored endpoints. Configurable via a settings.json file and equipped with robust logging features, it extends the Kentik agent's capabilities while ensuring ease of maintenance and troubleshooting.

## Installation Instructions for the Middleware using the ZIP package

Follow these steps to install the middleware:

1. **Download the ZIP package**: The ZIP package contains everything you need to set up the middleware on your server. 
```
curl -L https://github.com/GustavoPerezYSSY/inter-middleware/releases/download/v1.0/yssy-mutuauth-middleware-v1-0-0.zip -o yssy-mutuauth-middleware-v1-0-0.zip
```


2. **Extract the ZIP package**: Use the `unzip` command to extract the contents of the ZIP file to your current working directory. The command syntax is `unzip [file to unzip]`.

3. **Change directory to the extracted folder**: Use the `cd` command to navigate into the directory that was created when you extracted the ZIP file.

5. **Set execute permission to the shell scripts**: Before you can run the shell scripts, you need to give them execute permissions. You can do this with the following command: `chmod +x install.sh uninstall.sh`.

6. **Run the install.sh script**: This script sets up everything you need for the middleware to run. Execute the script by using the command `./install.sh`.
    - The `install.sh` script does the following:
        - It creates a directory at `/opt/yssy-mutuauth-middleware` and extracts the contents of `setup.zip` to this directory.
        - It sets up the middleware as a service that automatically starts on system boot.
        - It attempts to open the `settings.json` file for editing using the nano text editor. If nano is not installed on your system, it falls back to the vi editor.

7. **Edit the settings.json file**: Once the `install.sh` script completes its run, you need to edit the `settings.json` file to set your specific configuration parameters.

8. **Start the middleware service**: The `install.sh` script sets up the middleware as a service. You can start it with the command `systemctl start yssy-mutuauth-middleware`.

9. **Check the status of the service**: Use the `systemctl status yssy-mutuauth-middleware` to make sure the service is running as expected.

The middleware should now be running on your server and ready to handle mutual authentication for your endpoints.

## Uninstallation Instructions

To uninstall the middleware, you simply need to run the `uninstall.sh` script with the command `./uninstall.sh`. This script will stop the middleware service, disable it from running at startup, and remove the `/opt/yssy-mutuauth-middleware` directory and its contents.


## Configuration Guide for `settings.json`

This guide provides instructions for setting up the `settings.json` file for the middleware service.

### Overview

The `settings.json` file is used to configure the middleware service and define destination routes for the requests.

### File Structure

The `settings.json` file has two main parts:

1. `middlewareService`: This is an object that contains settings related to the middleware service itself.

2. `destinationRoutes`: This is an array of objects. Each object represents a destination route, specifying the properties for each route such as `originHostname`, `destinationHostname`, `destinationPort`, and paths to the `certFile`, `keyFile`, and `caFile`.

Here's an example of a `settings.json` file:

```json
{
  "middlewareService": {
    "certPath": "path_to_certificate",
    "clientKeyPath": "path_to_client_key",
    "caBundlePath": "path_to_ca_bundle",
    "servicePort": "port_number"
  },
  "destinationRoutes": [
    {
      "originHostname": "origin_hostname_1",
      "destinationHostname": "destination_hostname_1",
      "destinationPort": "destination_port_1",
      "certFile": "path_to_certificate_1",
      "keyFile": "path_to_key_1",
      "caFile": "path_to_ca_1"
    },
    {
      "originHostname": "origin_hostname_2",
      "destinationHostname": "destination_hostname_2",
      "destinationPort": "destination_port_2",
      "certFile": "path_to_certificate_2",
      "keyFile": "path_to_key_2",
      "caFile": "path_to_ca_2"
    }
  ]
}
```

### Configuration Steps

#### Step 1: Configure the Middleware Service

Under the `middlewareService` object, replace `"path_to_certificate"`, `"path_to_client_key"`, and `"path_to_ca_bundle"` with the actual paths to your certificate, client key, and CA bundle files respectively, used to configure a secure communication to this middleware service. 

Replace `"port_number"` with the port number that the middleware service should listen on.

Your `middlewareService` object should look something like this:

```json
"middlewareService": {
    "certPath": "/path/to/your/certificate",
    "clientKeyPath": "/path/to/your/client/key",
    "caBundlePath": "/path/to/your/ca/bundle",
    "servicePort": 8080
}
```

#### `middlewareService` Attributes

The `middlewareService` object contains the following properties:

##### `certPath`

This is a string representing the file path to the SSL/TLS certificate used by the middleware service to establish secure connections.

Example: `"certPath": "/path/to/your/certificate"`

##### `clientKeyPath`

This is a string representing the file path to the private key of the SSL/TLS certificate used by the middleware service.

Example: `"clientKeyPath": "/path/to/your/key"`

##### `caBundlePath`

This is a string representing the file path to the Certificate Authority (CA) bundle. This bundle is used by the middleware service to validate client certificates.

Example: `"caBundlePath": "/path/to/your/ca"`

##### `servicePort`

This is a number representing the port number on which the middleware service will listen for incoming requests.

Example: `"servicePort": 8080"`


#### Step 2: Configure the Destination Routes
In the `destinationRoutes` array, for each route, replace `origin_hostname_1`, `destination_hostname_1`, `destination_port_1`, `path_to_certificate_1`, `path_to_key_1`, and `path_to_ca_1` with your actual values.

You can add as many destination route objects as needed in the `destinationRoutes` array.

A sample destination route could look like this:
```json
{
  "originHostname": "example.origin.com",
  "destinationHostname": "example.destination.com",
  "destinationPort": 443,
  "certFile": "/path/to/your/certificate",
  "keyFile": "/path/to/your/key",
  "caFile": "/path/to/your/ca"
}
```

#### `destinationRoute` Attributes

Each `destinationRoute` object in the `destinationRoutes` array represents an destination endpoint that will be monitored. This final target has the following properties:

##### `originHostname`

This is a string representing the hostname of the origin server. When a request is made to the middleware service, it will compare the originHostname with the hostname specified in the incoming request to determine if this is the route to forward the request to.

Example: `"originHostname": "origin.example.com"`

If the incoming request was called using any other hostname not configured in this settings, an error wil be returned.

##### `destinationHostname`

This is a string representing the hostname of the destination server - the target of monitoring. If the incoming request matches the `originHostname`, the middleware service will forward the request to this destination host.

Example: `"destinationHostname": "destination.example.com"`

##### `destinationPort`

This is a number representing the port number of the destination server. The middleware service will forward the request to this port on the `destinationHostname`.

Example: `"destinationPort": 443`

##### `certFile`

This is a string representing the file path to the certificate file for mutual authentication with the destination server. The middleware service will use this certificate when forwarding the request.

Example: `"certFile": "/path/to/your/certificate"`

##### `keyFile`

This is a string representing the file path to the private key file for mutual authentication with the destination server. The middleware service will use this private key when forwarding the request.

Example: `"keyFile": "/path/to/your/key"`

##### `caFile`

This is a string representing the file path to the Certificate Authority (CA) bundle file for mutual authentication with the destination server. The middleware service will use this CA bundle when forwarding the request.

Example: `"caFile": "/path/to/your/ca"`

## Yssy-MutuAuth Middleware Diagnostics
This guide provides steps for diagnosing and troubleshooting the Yssy-MutuAuth Middleware.

### Service Management
The Yssy-MutuAuth Middleware runs as a system service, which means you can manage it using the systemctl command. Here are some useful commands:

#### Stop the service:
`sudo systemctl stop yssy-mutuauth-middleware.service`

#### Start the service:
`sudo systemctl start yssy-mutuauth-middleware.service`

#### Disable the service:
`sudo systemctl disable yssy-mutuauth-middleware.service`

#### Enable the service:
`sudo systemctl enable yssy-mutuauth-middleware.service`

#### Installation and Uninstallation
Uninstall: If you need to uninstall the middleware, simply run the uninstall.sh script. This will remove the service and all related files.
`sh ./uninstall.sh`

`sh ./install.sh`

#### Logs Inspection
The middleware logs can be inspected using the journalctl command:

`journalctl -fu yssy-mutuauth-middleware.service`

#### Reviewing Configuration
The middleware configuration is stored in settings.json. This file is key to configuring the middleware and its behavior. If you're experiencing issues, it's a good idea to review this file for any misconfigurations.

#### Understanding Route Concepts
The middleware acts as a bridge between the Kentik agent and the target endpoints, handling secure requests and responses. In the settings.json file, the destinationRoutes section is used to define the routes from the middleware to the endpoints. Each object in the destinationRoutes array represents a destination route, specifying the properties for each route such as originHostname, destinationHostname, destinationPort, and paths to the certFile, keyFile, and caFile.

![Middleware Routes](middleware-routes.png)

For instance, if an incoming request matches the originHostname, the middleware service will forward the request to the destination specified by the destinationHostname and destinationPort. The certFile, keyFile, and caFile are used for mutual authentication with the destination server. The middleware will use these files when forwarding the request.

If you're experiencing issues, ensure that these settings are correctly configured to establish the desired routes.
