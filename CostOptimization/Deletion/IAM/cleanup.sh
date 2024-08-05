#!/bin/bash

# Function to check if a role is unused for more than 90 days
is_role_unused() {
  local role_name=$1
  last_used=$(aws iam get-role --role-name "$role_name" --query 'Role.RoleLastUsed.LastUsedDate' --output text)
  if [ "$last_used" == "None" ]; then
    return 0
  fi
  last_used_timestamp=$(date -d "$last_used" +%s)
  current_timestamp=$(date +%s)
  let diff_days=($current_timestamp - $last_used_timestamp) / 86400
  if [ $diff_days -gt 90 ]; then
    return 0
  else
    return 1
  fi
}

# List all IAM roles
roles=$(aws iam list-roles --query 'Roles[*].RoleName' --output text)

for role in $roles; do
  if is_role_unused "$role"; then
    echo "Deleting unused role: $role"

    # List and delete attached policies
    policies=$(aws iam list-attached-role-policies --role-name "$role" --query 'AttachedPolicies[*].PolicyArn' --output text)
    for policy in $policies; do
      aws iam detach-role-policy --role-name "$role" --policy-arn "$policy"
      echo "Detached policy: $policy from role: $role"
    done

    # List and delete instance profiles
    instance_profiles=$(aws iam list-instance-profiles-for-role --role-name "$role" --query 'InstanceProfiles[*].InstanceProfileName' --output text)
    for profile in $instance_profiles; do
      aws iam remove-role-from-instance-profile --instance-profile-name "$profile" --role-name "$role"
      aws iam delete-instance-profile --instance-profile-name "$profile"
      echo "Deleted instance profile: $profile for role: $role"
    done

    # Delete the role
    aws iam delete-role --role-name "$role"
    echo "Deleted role: $role"
  fi
done

echo "Script execution completed."
