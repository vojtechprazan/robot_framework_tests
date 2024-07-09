*** Settings ***
Documentation  API Testing in Robot Framework
Library     RequestsLibrary
Library     BuiltIn
Library     Collections


*** Keywords ***
Get Random User Id And Email
    [Documentation]    Get a random user from the API and print his email address
    # Get all users
    ${response}    GET    ${BASE_URL}${USERS_ENDPOINT}
    ${all_users}    Set Variable    ${response.json()}

    # Get random user
    ${random_index}    Evaluate    random.randint(0, len(${all_users}) - 1)    random
    Log  ${random_index}
    ${random_user}    Set Variable    ${all_users}[${random_index}]
    Log  ${random_user}

    # Get and log email address
    ${email}    Set Variable    ${random_user}[email]
    Log    Random User Email: ${email}

    # Get user ID
    ${user_id}    Set Variable    ${random_user}[id]
    RETURN  ${user_id}


Get Users Posts By Id
    [Documentation]    Get posts from user given by his user_id
    [Arguments]  ${user_id}

    # Get posts associated with the user
    ${posts_response}    GET    ${BASE_URL}${POSTS_ENDPOINT}

    # Convert json to list
    ${posts}    Set Variable    ${posts_response.json()}

    # Empty list to save the users' post
    ${posts_by_given_id} =  Create List

    ${user_id} =  Convert To Integer  ${user_id}

    FOR    ${post}    IN    @{posts}
        ${post_user_id}    Set Variable    ${post}[userId]
        ${post_user_id} =  Convert To Integer   ${post_user_id}
        Run Keyword If   ${post_user_id} == ${user_id}    Append To List  ${posts_by_given_id}   ${post}
    END

    RETURN  ${posts_by_given_id}


Verify Posts Are Valid
    [Documentation]     Verify id value of each post. It should be within range 1 to 100, both included
    [Arguments]  ${posts}

    FOR    ${post}    IN    @{posts}
    ${post_id}    Set Variable    ${post}[id]
    ${post_id} =  Convert To Integer   ${post_id}
    IF  1 <= ${post_id} <= 100
    Log  ${post_id}
        ELSE
        Fail    Post ID ${post_id} is not within the range of 1 to 100
    END
    END


Create Post And Verify Response
    [Documentation]     Create post and verify it's value
    [Arguments]    ${user_id}
    ${post_data}=    Create Dictionary    userId=${user_id}    title=hello    body=world
    ${headers}=    Create Dictionary    Content-Type=application/json
    ${response}=    POST  url=${BASE_URL}${POSTS_ENDPOINT}    json=${post_data}    headers=${headers}  expected_status=any

    IF  200 <= ${response.status_code} <= 299
    Log    Post Created Successfully: ${response.json()}
        ELSE
        Fail    Response status code ${response.status_code} is not within the range of 200 to 299
    END


*** Variables ***
${BASE_URL}    https://jsonplaceholder.typicode.com
${USERS_ENDPOINT}    /users
${POSTS_ENDPOINT}    /posts


*** Test Cases ***
Test case B

    ${user_id}    Get Random User Id And Email
    Log    User ID from Get Random User Id And Email: ${user_id}

    ${posts_by_given_id}    Get Users Posts By Id  ${user_id}
    Log   ${posts_by_given_id}

    Verify Posts Are Valid  ${posts_by_given_id}

    Create Post And Verify Response  ${user_id}
