#!/bin/bash

# 모든 리전 목록 가져오기
REGIONS=$(aws ec2 describe-regions --query "Regions[].RegionName" --output text --no-cli-pager)

# 각 리전을 순회하면서 ECS 클러스터와 서비스 삭제
for REGION in $REGIONS
do
  echo "Processing region: $REGION"

  # 모든 클러스터 목록 가져오기
  CLUSTERS=$(aws ecs list-clusters --region $REGION --query "clusterArns[]" --output text --no-cli-pager)

  # 각 클러스터에서 서비스 삭제 및 클러스터 삭제
  for CLUSTER in $CLUSTERS
  do
    echo "Processing cluster: $CLUSTER in region: $REGION"

    # 해당 클러스터 내 모든 서비스 목록 가져오기
    SERVICES=$(aws ecs list-services --cluster $CLUSTER --region $REGION --query "serviceArns[]" --output text --no-cli-pager)

    if [ -z "$SERVICES" ]; then
      echo "No services found in cluster: $CLUSTER in region: $REGION"
    else
      # 각 서비스를 중지 및 삭제
      for SERVICE in $SERVICES
      do
        echo "Stopping and deleting service: $SERVICE in cluster: $CLUSTER in region: $REGION"

        # 서비스 중지 (출력 없음)
        aws ecs update-service --cluster $CLUSTER --service $SERVICE --desired-count 0 --region $REGION --no-cli-pager >/dev/null

        # 서비스 삭제 (출력 없음)
        aws ecs delete-service --cluster $CLUSTER --service $SERVICE --force --region $REGION --no-cli-pager >/dev/null
      done
      echo "All services in cluster: $CLUSTER have been deleted in region: $REGION."
    fi

    # 모든 서비스 삭제 후 클러스터 삭제
    echo "Deleting cluster: $CLUSTER in region: $REGION"
    aws ecs delete-cluster --cluster $CLUSTER --region $REGION --no-cli-pager >/dev/null

    echo "Cluster $CLUSTER has been deleted in region: $REGION."
  done

  echo "All services and clusters in the region: $REGION have been deleted."

  # 모든 작업 정의 목록 가져오기
  TASK_DEFINITIONS=$(aws ecs list-task-definitions --region $REGION --query "taskDefinitionArns[]" --output text --no-cli-pager)

  # 작업 정의 등록 취소
  for TASK_DEF in $TASK_DEFINITIONS
  do
    echo "Deregistering task definition: $TASK_DEF in region: $REGION"
    aws ecs deregister-task-definition --task-definition $TASK_DEF --region $REGION --no-cli-pager >/dev/null
  done

  echo "All task definitions have been deregistered in region: $REGION."
done

echo "All regions have been processed."
