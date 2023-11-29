# Project Title
## About
This is designed to set up an environment for compiling the libedgetpu library, specifically for use with the Google Coral USB Accelerator. The Dockerfile includes instructions for installing necessary dependencies, cloning the TensorFlow repository at a version compatible with TensorFlow Lite 2.5.0, and building the libedgetpu library using a Makefile. This setup ensures that the libedgetpu library is compiled in a controlled environment with all required dependencies, making it suitable for applications involving Edge TPU-based machine learning models.

## Dockerfile
Dockerfile: This file contains all the instructions to build the Docker image. It sets up the environment, installs necessary packages, and configures the settings.

## Usage
### Building the Docker Image
build_image.sh: This script is used to build the Docker image. Run it with:

```bash
./build_image.sh
```
### Creating the Docker Container
create_container.sh: This script creates a Docker container from the image. To use it, run:

```bash
./create_container.sh
```

### Running the Docker Container
run_container.sh: Use this script to start the Docker container. Execute it with:

```bash
./run_container.sh
```

### Stopping the Docker Container
stop_container.sh: This script stops the running Docker container. To stop the container, run:

```bash
./stop_container.sh
```


## Contributing
Contributions to this project are welcomed, but there are certain guidelines that should be followed to maintain the integrity and consistency of the codebase:

- Branching Policy: Direct pushes to the master branch are not allowed. All changes should be made in separate branches.
- Pull Requests: After rebasing, submit your changes via a pull request. This allows for code review and discussion before changes are merged into master.

We appreciate your contributions and encourage you to follow these practices for the betterment of the project.
