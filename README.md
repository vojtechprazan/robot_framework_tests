# Playground for Robot Framework API Testing Project

Here I put tests to examine and discover Robot Framework feature

## Project Structure

- `tests/`: Directory containing Robot Framework test cases and keywords.
  - `test_1.robot`
 
## test_1

- **Get Random User Id And Email**: Fetches a random user and logs their email.
- **Get Users Posts By Id**: Retrieves and logs posts associated with the user.
- **Verify Posts Are Valid**: Verifies posts are valid by their id 
- **Create Post And Verify Response**: Creates a new post for the user with a non-empty title and body.

## Run tests
robot tests/test_1.robot
