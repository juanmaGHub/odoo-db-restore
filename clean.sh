# Clean environment variables
for var in $(grep -v '^#' ".env" | xargs); do
    unset $var
done