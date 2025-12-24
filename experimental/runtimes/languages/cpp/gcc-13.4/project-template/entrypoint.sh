#!/bin/bash
app_env=${1:-development}

# Define build target
build_target="hello_world"

# Development environment commands
dev_commands() {
    echo "Running development environment commands..."
    export ENV="development"
    # Use GCC 13.4 from /opt/gcc-13.4/bin
    export PATH="/opt/gcc-13.4/bin:$PATH"
    export LD_LIBRARY_PATH="/opt/gcc-13.4/lib64:$LD_LIBRARY_PATH"
    g++ -Wall ${build_target}.cpp -o $build_target || exit 1
    ./$build_target
}

# Production environment commands
prod_commands() {
    echo "Running production environment commands..."
    export ENV="production"
    # Use GCC 13.4 from /opt/gcc-13.4/bin
    export PATH="/opt/gcc-13.4/bin:$PATH"
    export LD_LIBRARY_PATH="/opt/gcc-13.4/lib64:$LD_LIBRARY_PATH"
    g++ -O2 -Wall ${build_target}.cpp -o $build_target || exit 1
    ./$build_target
    echo "Server started in background. Check server.log for details."
}

# Check environment variables to determine the running environment
if [ "$app_env" = "production" ] || [ "$app_env" = "prod" ] ; then
    echo "Production environment detected"
    prod_commands
else
    echo "Development environment detected"
    dev_commands
fi

