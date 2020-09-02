# tfe-sensitive-env-var-test
TFE sensitive variable value access test

The purpose of this repository is to demonstrate the sensitive enviromental variables value access via Shell code and `null_provider`

# Steps to reproduce

## 1. Create test code 

Create code similiar to one in the file [main.tf](main.tf)

```terraform
  
resource "null_resource" "get_aws_cred" {
  provisioner "local-exec" {
    command = "echo $AWS_SECRET_ACCESS_KEY > awskey"
  }
}

data "local_file" "awscred" {
  filename = "awskey"
  depends_on = [
    null_resource.get_aws_cred
  ]
}

output "AWS_SECRET_ACCESS_KEY" {
  value = data.local_file.awscred.content
}
```

## 2. Define testing envrironment variable

Define in the workspace where you have above-mentioned code environment variable with name AWS_SECRET_ACCESS_KEY,
some content, for the purpose of this example `This is GOING TO BE VISIBLE`. Mark it as **sensitive**


## 3. Plan 

Run the manual or VCS-driven queue for the above specified code in our testing workspace.

```Terraform
 
 
Terraform v0.12.28
Configuring remote state backend...
Initializing Terraform configuration...
2020/08/31 12:17:55 [DEBUG] Using modified User-Agent: Terraform/0.12.28 TFE/v202007-2
Refreshing Terraform state in-memory prior to plan...
The refreshed state will be used to calculate this plan, but will not be
persisted to local or remote state storage.


------------------------------------------------------------------------

An execution plan has been generated and is shown below.
Resource actions are indicated with the following symbols:
  + create
 <= read (data resources)

Terraform will perform the following actions:

  # data.local_file.awscred will be read during apply
  # (config refers to values not yet known)
 <= data "local_file" "awscred"  {
      + content        = (known after apply)
      + content_base64 = (known after apply)
      + filename       = "awskey"
      + id             = (known after apply)
    }

  # null_resource.get_aws_cred will be created
  + resource "null_resource" "get_aws_cred" {
      + id = (known after apply)
    }

Plan: 1 to add, 0 to change, 0 to destroy.
```
## 4. Observe the sensitive value in output 

```
Terraform v0.12.28
Initializing plugins and modules...
2020/08/31 12:18:18 [DEBUG] Using modified User-Agent: Terraform/0.12.28 TFE/v202007-2
null_resource.get_aws_cred: Creating...
null_resource.get_aws_cred: Provisioning with 'local-exec'...
null_resource.get_aws_cred (local-exec): Executing: ["/bin/sh" "-c" "echo $AWS_SECRET_ACCESS_KEY > awskey"]
null_resource.get_aws_cred: Creation complete after 0s [id=7710720977275536005]
data.local_file.awscred: Refreshing state...

Apply complete! Resources: 1 added, 0 changed, 0 destroyed.

Outputs:

AWS_SECRET_ACCESS_KEY = This is GOING TO BE VISIBLE
```

As you can see, we can read the value, of sensitive environmental vairable easy. in clear text in TFE UI. While, it work as expected, it can present some security problems...

# TODO

- [x] make initial test
- [x] Update readme
