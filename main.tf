resource "aws_vpc" "main" {
    cidr_block = var.vpc_cidr
    instance_tenancy = "default"
    enable_dns_hostnames = true

    tags = {}
}


resource "aws_internet_gateway" "main" {
    vpc_id = aws_vpc.main.id
    tags = {}
  
}

resource "aws_subnet" "public" {
    count = length(var.public_subnet_cidrs)
    vpc_id = aws_vpc.main.id
    cidr_block = var.public_subnet_cidrs[count.index]
    availability_zone = local.az_names[count.index]


    tags = {}

  
}


resource "aws_subnet" "private" {
    count= length(var.private_subnet_cidrs)
    vpc_id = aws_vpc.main.id
    cidr_block = var.private_subnet_cidrs[count.index]
    availability_zone = local.az_names[count.index]

    tags = {}
}


resource "aws_subnet" "database" {
    count = length(var.database_subnet_cidrs)
    vpc_id = aws_vpc.main.id
    cidr_block = var.database_subnet_cidrs[count.index]
    availability_zone = local.az_names[count.index]

    tags = {}


}


resource "aws_route_table" "public" {
    vpc_id = aws_vpc.main.id
    
    tags = {}
  
}

resource "aws_route_table" "private" {
  vpc_id = aws.vpc_id
  tags = {}
}

resource "aws_route_table" "database" {
    vpc_id = aws_vpc.main.id
    tags = {}
  
}

resource "aws_route" "public" {
    route_table_id = aws_route_table.public.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id

}


resource "aws_eip" "nat" {
    domain = "vpc"

    tags = {
 
    }
  
}


resource "aws_nat_gateway" "main" {
    allocation_id = aws_eip.nat.id
    subnet_id = aws_subnet.public.id
    tags = {

    }
    depends_on = [ aws_internet_gateway.main ]
}

resource "aws_route" "private" {
    route_table_id = aws_subnet.private.id
    destination_cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main.id
  
}

resource "aws_route" "database" {
    route_table_id = aws_subnet.database.id
    destination_cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_internet_gateway.main.id 
}


resource "aws_route_table_association" "public" {
  count = length(var.public_subnet_cidrs)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
    count = length(var.private_subnet_cidrs)
    route_table_id = aws_route_table.private.id
    subnet_id = var.private_subnet_tags[count.index].id
  
}

resource "aws_route_table_association" "database" {
    count = length(var.database_subnet_cidrs)
    route_table_id = aws_route_table.database.id
    subnet_id = var.database_subnet_cidrs[count.index].id
  
}