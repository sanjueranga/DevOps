# Create a VPC
resource "aws_vpc" "demoVPC" {
  cidr_block = var.cidr_block
  tags = {
    Name = "My VPC"
  }
}

# Create public subnets
resource "aws_subnet" "public_subnet_1" {
  vpc_id                  = aws_vpc.demoVPC.id
  cidr_block              = var.public_subnet_cidr_blocks[0]
  availability_zone       = var.availability_zones[0]
  map_public_ip_on_launch = true
  tags = {
    Name = "Public Subnet 1"
  }
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id                  = aws_vpc.demoVPC.id
  cidr_block              = var.public_subnet_cidr_blocks[1]
  availability_zone       = var.availability_zones[1]
  map_public_ip_on_launch = true
  tags = {
    Name = "Public Subnet 2"
  }
}

# Create private subnets
resource "aws_subnet" "private_subnet_1" {
  vpc_id            = aws_vpc.demoVPC.id
  cidr_block        = var.private_subnet_cidr_blocks[0]
  availability_zone = var.availability_zones[0]
  tags = {
    Name = "Private Subnet 1"
  }
}

resource "aws_subnet" "private_subnet_2" {
  vpc_id            = aws_vpc.demoVPC.id
  cidr_block        = var.private_subnet_cidr_blocks[1]
  availability_zone = var.availability_zones[1]
  tags = {
    Name = "Private Subnet 2"
  }
}


resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.demoVPC.id
}


resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.demoVPC.id
  tags = {
    Name = "Public Route Table"
  }
}

# Create an internet gateway
resource "aws_internet_gateway" "demoVPC" {
  vpc_id = aws_vpc.demoVPC.id
  tags = {
    Name = "Main Internet Gateway"
  }
}

# Associate the public route table with the public subnets
resource "aws_route_table_association" "public_route_table_association_1" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "public_route_table_association_2" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public_route_table.id
}


resource "aws_nat_gateway" "demoVPC" {
  allocation_id = aws_eip.nat_gateway.allocation_id
  subnet_id     = aws_subnet.public_subnet_1.id
  tags = {
    Name = "Main NAT Gateway"
  }
}

resource "aws_eip" "nat_gateway" {
  domain = "vpc"
  tags = {
    Name = "NAT Gateway EIP"
  }
}



## Create an EKS cluster
resource "aws_eks_cluster" "my_demo_cluster" {
  name     = "my_demo_cluster"
  role_arn = ""
  vpc_config {
    subnet_ids = [aws_subnet.private_subnet_1.id, aws_subnet.private_subnet_2.id]
  }
  tags = {
    Name = "My EKS Cluster"
  }
}


# resource "aws_eks_node_group" "Worker" {
#   cluster_name    = aws_eks_cluster.my_demo_cluster.name
#   node_group_name = "Worker"
#   node_role_arn   = ""
#   subnet_ids      = [aws_subnet.private_subnet_1.id, aws_subnet.private_subnet_2.id]

#   scaling_config {
#     desired_size = 2
#     max_size     = 2
#     min_size     = 2
#   }

#   ami_type       = "AL2_x86_64"
#   instance_types = ["t2.micro"]
#   capacity_type  = "ON_DEMAND"
#   disk_size      = 20

# }
