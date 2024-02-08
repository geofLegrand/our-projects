terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.67.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

variable "list-users" {
  #type = list(string)
  default = ["us1", "us2", "us3", "us4", "us5"]

}

variable "study-group" {
  #type = string
  default = "study-group"
}

resource "aws_iam_group" "ourGroup" {
  name = var.study-group
}



# variable "list-groups" {
#     #type = list(string)
#   default  = ["grp1", "grp2", "grp3", "grp4", "grp5"]

# }

# # Create the iam group on aws (Ctrl+K+C) and un(Ctrl+K+U)
# resource "aws_iam_group" "devotraining" {
#   count = 1
#   name = "DevTrain"

# }
# Create the iam user belong to the iam group created before

# resource "aws_iam_user" "usr-01" {

#   count = length(var.list-users)
#   name = var.list-users[count.index] 

# }

resource "aws_iam_user" "usr-01" {

  for_each = toset(var.list-users)

  name = each.key

}

# Affect the user to a group
resource "aws_iam_user_group_membership" "members" {
  for_each = toset(var.list-users)

  user = aws_iam_user.usr-01[each.key].name

  groups = [aws_iam_group.ourGroup.name]
}


