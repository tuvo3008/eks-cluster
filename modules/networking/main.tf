resource "aws_vpc" "tu-vpc" {
  cidr_block = var.vpc_cidr_block
  tags = merge(
    var.tag,
    {
      Name = var.vpc_name
    }
  )
}

resource "aws_subnet" "tu-sn-public" {
  vpc_id                  = aws_vpc.tu-vpc.id
  cidr_block              = var.sn_public_cidr_block
  map_public_ip_on_launch = var.public_ip_on_launch
  availability_zone       = var.az_public
  tags = merge(
    var.tag,
    {
      Name = "tu-sn-public"
    }
  )
}

resource "aws_subnet" "tu-sn-private" {
  vpc_id            = aws_vpc.tu-vpc.id
  cidr_block        = var.sn_private_cidr_block
  availability_zone = var.az_private
  tags = merge(
    var.tag,
    {
      Name = "tu-sn-private"
    }
  )
}

# IGW
resource "aws_internet_gateway" "tu-igw" {
  vpc_id = aws_vpc.tu-vpc.id
  tags   = var.tag
}

# Elastic IP for NAT Gateway
resource "aws_eip" "nat_gateway_ip" {
  domain = "vpc"
  tags = merge(
    var.tag,
    {
      Name = "tu-nat-gateway-ip"
    }
  )
}

# NAT Gateway
resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat_gateway_ip.id
  subnet_id     = aws_subnet.tu-sn-public.id # Public Subnet for NAT Gateway
  tags = merge(
    var.tag,
    {
      Name = "tu-nat-gateway"
    }
  )
}

# Route for Private Subnets to use NAT Gateway
resource "aws_route" "private_route" {
  route_table_id         = aws_route_table.tu-rtb-private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gateway.id
}

# Route table public
resource "aws_route_table" "tu-rtb-public" {
  vpc_id = aws_vpc.tu-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.tu-igw.id
  }
  tags = merge(
    var.tag,
    {
      Name = "tu-rtb-public"
    }
  )
}

# Public association 1
resource "aws_route_table_association" "tu-public-association" {
  subnet_id      = aws_subnet.tu-sn-public.id
  route_table_id = aws_route_table.tu-rtb-public.id
}

# Route table private
resource "aws_route_table" "tu-rtb-private" {
  vpc_id = aws_vpc.tu-vpc.id
  tags = merge(
    var.tag,
    {
      Name = "tu-rtb-private"
    }
  )
}

resource "aws_route_table_association" "tu-private-association" {
  subnet_id      = aws_subnet.tu-sn-private.id
  route_table_id = aws_route_table.tu-rtb-private.id
}

resource "aws_security_group" "eks_security_group" {
  name        = "tu-eks-cluster-sg"
  description = "EKS cluster communication security group"
  vpc_id      = aws_vpc.tu-vpc.id
  tags        = var.tag

  # Ingress Rutus (Allow inbound traffic)
  ingress {
    description = "Allow all traffic from worker nodes"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true # Allow communication within the EKS cluster
  }

  ingress {
    description = "Allow HTTPS from the Internet"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr_block]
  }

  # Egress Rules (Allow outbound traffic)
  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

