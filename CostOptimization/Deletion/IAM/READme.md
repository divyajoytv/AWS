**1. Importance of Deleting Unused IAM Roles for AWS Cost Optimization:**

Security: Reduces the risk of unauthorized access by minimizing the number of entry points.
Management: Simplifies management of roles and permissions, making it easier to audit and maintain.
Cost Efficiency: While IAM roles themselves don't incur charges, attached resources like policies and instance profiles can contribute to indirect costs.

**2. Deleting Attached Policies and Profiles:**

Policies: Unattached policies can clutter the environment and complicate management, leading to potential security vulnerabilities.
Instance Profiles: Removing unused profiles ensures that no redundant resources are left, further reducing management overhead.

**3. Script Description:**

Identify Unused Roles: The script checks for IAM roles that haven't been used in the last 90 days.
Delete Attached Policies: For each unused role, the script detaches and deletes any associated policies.
Delete Instance Profiles: The script also deletes any instance profiles linked to the unused roles.
Remove Roles: Finally, it deletes the unused IAM roles.

**How to Use**
1. Ensure you have AWS CLI configured with the necessary permissions.
2. Save the script to a file, for example, cleanup_unused_iam_roles.sh.
3. Make the script executable: chmod +x cleanup_unused_iam_roles.sh.
4. Run the script: ./cleanup_unused_iam_roles.sh.

