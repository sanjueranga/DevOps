# Serverless REST API with AWS lambda + APIgateway + DynamoDB

## Table of Contents

1. [Project Overview](#project-overview)
   - Description of the project's purpose and goals.
2. [Prerequisites](#prerequisites)

   - Requirements for running and deploying the project.

3. [AWS Lambda](#aws-lambda)

   - Creating the req/res handler for the api using python on aws lambda.

4. [AWS api gateway](#apigateway)
   - Creating api end-points to execute lambda function using apigateway.
5. [Postman Tests](#postman-tests)
   - Testing api endpoints using postman

<br/><br/><br/><br/>

## Project-overview

In this project, we have developed a serverless RESTful API using AWS Lambda, API Gateway, and DynamoDB. These AWS services work together to create a scalable and efficient backend system for managing user data.

- When a client makes an HTTP request to our API Gateway endpoints, the requests are routed to the corresponding Lambda function.

- Lambda functions interact with DynamoDB to perform operations on user data, such as creating, retrieving, updating, or deleting records.
- Responses from Lambda functions are sent back through API Gateway to the client in the form of HTTP responses.
The project ensures data integrity, security, and efficient handling of user-related operations in a serverless architecture.

**Benefits**

- Serverless architecture eliminates the need to manage infrastructure, resulting in cost-effectiveness.
Scalability is handled by AWS services, automatically adapting to varying workloads.
- DynamoDB provides high availability and low-latency access to data.
- API Gateway secures and manages API endpoints, making it easy to expose services to clients.



<br/><br/>

## Prerequisites

- AWS account
- Postman 

**IAM user with following poliecies**

![Alt text](pics/Iam.png)



<br/><br/>

## AWS lambda

**Creating your first lambda function**

>Go to aws lambda console
    
- create new function

![Alt text](pics/Createfunc.png)

**Create a new role with lambda permissions**
And later allow dynmoDB fullAccess to that Role using IAM role configurations

![Alt text](pics/rolepolicy.png)



<br/><br/>

## APIgateway

<br/><br/>

## Postman Tests

https://documenter.getpostman.com/view/27331759/2s9YJZ2PCL
