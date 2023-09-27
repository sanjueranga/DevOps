import json
import boto3
import uuid
from decimal import Decimal

# Initialize AWS services
dynamodb = boto3.resource('dynamodb')
table_name = 'user'  # Replace with your DynamoDB table name
table = dynamodb.Table(table_name)


class DecimalEncoder(json.JSONEncoder):
    def default(self, o):
        if isinstance(o, Decimal):
            return float(o)
        return super(DecimalEncoder, self).default(o)


def lambda_handler(event, context):
    print("Received event: ", event)
    # Check if 'pathParameters' key exists in the event and get user_id
    if 'pathParameters' in event and 'id' in event['pathParameters']:
        user_id = event['pathParameters']['id']
        print("meeka thama yko",id)
    else:
        # Handle the case where 'pathParameters' or 'userId' is missing
        user_id = None

    # Get the HTTP method from the 'routeKey'
    operation = event['routeKey'].split(' ')[0]
    path = event['rawPath']
    
    if 'body' in event:
        request_body = json.loads(event['body'])
    
    if operation == 'GET':
        if path == '/user-service/get-all':
            return get_all_users()
        elif path == '/user-service/check-status':
            return {
                'statusCode': 200,
                'body': json.dumps({'message': 'Server is running'}),
            }
        else:
            return get_user_by_id(user_id)
    elif operation == 'POST':
        return create_user(request_body)
    elif operation == 'DELETE':
        return delete_user(user_id)
    elif operation == 'PUT':
        return edit_user(user_id, request_body)
    else:
        return {
            'statusCode': 400,
            'body': json.dumps({'message': 'Invalid operation'}),
        }

# Define your other functions (get_all_users, get_user_by_id, create_user, delete_user, edit_user) here.



def get_all_users():
    try:
        response = table.scan()
        users = response['Items']
        return {
            'statusCode': 200,
            'body': json.dumps(users,cls=DecimalEncoder),
        }
    except Exception as e:
        return {
            'statusCode': 500,
            'body': json.dumps({'message': str(e)}),
        }

def get_user_by_id(user_id):
    try:
        response = table.get_item(Key={'userId': user_id})
        user = response.get('Item', None)

        if user is None:
            return {
                'statusCode': 404,
                'body': json.dumps({'message': 'User not found'}),
            }

        return {
            'statusCode': 200,
            'body': json.dumps(user,cls=DecimalEncoder),
        }
    except Exception as e:
        return {
            'statusCode': 500,
            'body': json.dumps({'message': 'Error retrieving user'}),
        }

def create_user(request_body):
    name = request_body.get('name', '')
    email = request_body.get('email', '')
    password = request_body.get('password', '')
    age = request_body.get('age', '')
    address = request_body.get('address', '')

    if not name or not email or not password or not age or not address:
        return {
            'statusCode': 400,
            'body': json.dumps({'message': 'Missing required fields'}),
        }

    user_id = str(uuid.uuid4())

    user = {
        'userId': user_id,
        'name': name,
        'email': email,
        'password': password,
        'age': age,
        'address': address,
    }

    try:
        table.put_item(Item=user)
        return {
            'statusCode': 201,
            'body': json.dumps({'message': 'User created successfully', 'userId': user_id}),
        }
    except Exception as e:
        return {
            'statusCode': 500,
            'body': json.dumps({'message': 'Error creating user'}),
        }

def delete_user(user_id):
    try:
        response = table.delete_item(Key={'userId': user_id}, ReturnValues='ALL_OLD')
        deleted_user = response.get('Attributes', None)

        if deleted_user is None:
            return {
                'statusCode': 404,
                'body': json.dumps({'message': 'User not found'}),
            }

        return {
            'statusCode': 200,
            'body': json.dumps({'message': 'User deleted successfully'}),
        }
    except Exception as e:
        return {
            'statusCode': 500,
            'body': json.dumps({'message': str(e)}),
        }

def edit_user(user_id, updated_user_data):
    print(user_id)
    update_expression = 'SET #name = :name, #email = :email, #password = :password, #age = :age, #address = :address'
    expression_attribute_names = {
        '#name': 'name',
        '#email': 'email',
        '#password': 'password',
        '#age': 'age',
        '#address': 'address',
    }
    expression_attribute_values = {
        ':name': updated_user_data['name'],
        ':email': updated_user_data['email'],
        ':password': updated_user_data['password'],
        ':age': updated_user_data['age'],
        ':address': updated_user_data['address'],
    }

    try:
        response = table.update_item(
            Key={'userId': user_id},
            UpdateExpression=update_expression,
            ExpressionAttributeNames=expression_attribute_names,
            ExpressionAttributeValues=expression_attribute_values,
            ReturnValues='ALL_NEW'
        )

        updated_user = response.get('Attributes', None)

        if updated_user is None:
            return {
                'statusCode': 404,
                'body': json.dumps({'message': 'User not found'}),
            }

        # Use the custom JSON encoder to serialize the updated_user with Decimal values
        return {
            'statusCode': 200,
            'body': json.dumps(updated_user, cls=DecimalEncoder),
        }
    except Exception as e:
        return {
            'statusCode': 500,
            'body': json.dumps({'message': str(e)}),
        }
