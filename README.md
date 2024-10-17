# Shell Script: Delete ECS Clusters and Task Definitions in All Regions

This script automates the process of deleting all ECS clusters, services, and task definitions in every AWS region.

## Purpose

The script performs the following actions in **all AWS regions**:
1. Retrieves all ECS clusters.
2. Stops and deletes all services in each ECS cluster.
3. Deletes the ECS clusters after the services are stopped.
4. Deregisters all ECS task definitions.

## Prerequisites

Before running the script, ensure the following:

1. **AWS CLI is installed**: The AWS Command Line Interface (CLI) should be installed and configured with appropriate permissions.
   - You can follow the [AWS CLI installation guide](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html) to set up the AWS CLI.
   
2. **AWS credentials are set up**: Ensure you have configured AWS credentials either using `aws configure` or by setting the appropriate environment variables (`AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`).
   
3. **Required IAM permissions**: The user or role executing this script should have the following permissions:
   - `ecs:ListClusters`
   - `ecs:ListServices`
   - `ecs:UpdateService`
   - `ecs:DeleteService`
   - `ecs:DeleteCluster`
   - `ecs:ListTaskDefinitions`
   - `ecs:DeregisterTaskDefinition`
   - `ec2:DescribeRegions`

4. **Bash environment**: The script is designed to run in a Unix-based environment (e.g., macOS or Linux). On Windows, you can use a bash environment such as Git Bash or WSL (Windows Subsystem for Linux).

## How to Run the Script

1. **Clone or download the script**:
   Download the script to your local machine, or clone it from your repository if available.

2. **Make the script executable**:
   Open a terminal and navigate to the directory where the script is located. Run the following command to make the script executable:
   
   ```bash
   chmod +x delete-ecs-in-all-regions.sh
   ```

3. **Execute the script**: Run the script with the following command:

   ```bash
   ./delete-ecs-in-all-regions.sh
   ```

   The script will begin processing all regions, listing all ECS clusters, stopping and deleting services, deleting the clusters, and deregistering task definitions.

## Example Output

The script will output messages indicating the progress of each step:

```bash
Processing region: us-east-1
Processing cluster: arn:aws:ecs:us-east-1:123456789012:cluster/MyCluster in region: us-east-1
Stopping and deleting service: arn:aws:ecs:us-east-1:123456789012:service/MyService in cluster: MyCluster
Deleting cluster: arn:aws:ecs:us-east-1:123456789012:cluster/MyCluster in region: us-east-1
Deregistering task definition: arn:aws:ecs:us-east-1:123456789012:task-definition/MyTaskDef:1 in region: us-east-1
All task definitions have been deregistered in region: us-east-1.
...
```

The script will continue this process for all AWS regions.

## Notes

- This script permanently deletes ECS clusters, services, and task definitions. Make sure you double-check the AWS environment before running this script to avoid accidental deletions.
- The script suppresses most metadata outputs to simplify the process. If you need detailed output for debugging, you can remove the >/dev/null parts of the commands to see more information.