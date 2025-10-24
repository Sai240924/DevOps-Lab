# My IaC Project with Version Control

## What is This Project?

This is my DevOps project about **Infrastructure as Code (IaC)** using **Terraform** and **Git** for version control. Think of it like writing a recipe for a robot to build a toy castle in the cloud! IaC means writing code to set up things like cloud storage or servers, instead of clicking buttons. I use Git to save my work, like saving versions of a drawing, so I can go back if I make a mistake or share it with friends.

This project creates a fun **random pet name** using Terraform (no real cloud needed). It shows how to use version control the right way to keep my code safe and organized.

## Why Use Version Control for IaC?

Version control (with Git and GitHub) is like a time machine for my code. It helps me:
- **Track Changes**: See what I changed and go back if something breaks.
- **Work with Friends**: Everyone can add ideas without messing things up.
- **Test Safely**: Try new things on a copy without breaking the main code.
- **Share Easily**: Put my code online so others can use it.

## Best Practices I Learned

Here are the smart ways to use version control for IaC:
1. **Use Git**: Save all my code in Git to track changes.
2. **Organize Folders**: Keep files neat, like sorting toys in boxes.
3. **Branching**: Work on copies (branches) to keep the main code safe.
4. **Clear Commit Messages**: Write notes like “Added pet name code” when saving.
5. **No Secrets**: Never put passwords in code to stay safe.
6. **Documentation**: Write instructions (like this README) to explain my project.
7. **Automated Testing**: Use tools to check my code for mistakes automatically.

## Project Workflow

Below is a simple diagram showing how my project works. It’s like a map of steps I follow to write, save, and use my IaC code.

```
IaC Version Control Workflow
===========================
[Developer's Computer]
   |
   | 1. Write Terraform Code
   v
[Local Git Repository]
   | - Organized Folders
   | - No Secrets
   |
   | 2. Git Commit
   v
[Feature Branch]
   | - Branching
   | - Clear Commits
   |
   | 3. Push to GitHub
   v
[GitHub Repository]
   | - Documentation
   |
   | 4. Pull Request & Review
   v
[Main Branch]
   |
   | 5. Pull to Computer
   v
[Developer's Computer]
   |
   | 6. Run Terraform Apply
   |    - Output (Pet Name)
   v

[Done!]

[GitHub Repository] --> [Automated Tests] - Automated Testing
                    |        |
                    | 7. Test Results
                    v
                 [Main Branch]
```

## How to Use This Project

Follow these steps to try my project on your computer. You’ll need **Git** and **Terraform** installed (they’re free!).

### Step 1: Get the Code
1. Open a terminal (like Command Prompt or Terminal).
2. Clone my project:
   ```bash
   git clone https://github.com/yourusername/my-iac-project.git
   cd my-iac-project
   ```

### Step 2: Set Up Terraform
1. Run this to set up Terraform:
   ```bash
   terraform init
   ```
2. Check what will happen:
   ```bash
   terraform plan
   ```
3. Create the pet name:
   ```bash
   terraform apply
   ```
   Type `yes` when asked. You’ll see a random pet name, like “happy-cat”!

### Step 3: Explore Version Control
- Look at `main.tf` to see my Terraform code.
- Check the `.gitignore` file (it keeps state files out of Git).
- See my commits:
  ```bash
  git log
  ```
- View branches:
  ```bash
  git branch
  ```

### Step 4: Make Your Own Changes
1. Create a new branch:
   ```bash
   git checkout -b my-feature
   ```
2. Edit `main.tf`, like adding:
   ```hcl
   description = "My cool pet name"
   ```
3. Save and push:
   ```bash
   git add main.tf
   git commit -m "Added description"
   git push origin my-feature
   ```
4. Go to GitHub and make a Pull Request to share your changes.

## Files in This Project
- `main.tf`: The Terraform code that makes a random pet name.
- `iac_workflow.txt`: A text diagram of my workflow.
- `.gitignore`: Tells Git not to save state files.
- `README.md`: This file, explaining everything!

## What I Learned
This project taught me how to use Terraform to build things with code and Git to keep my work organized. The best practices make sure my code is safe, clear, and easy to share. I can now build bigger cloud projects, like storage or servers, using these steps!

If you want to try it, follow the steps above or ask me for help. Happy coding!

## Vercel deployment & CI hints

If you connected this repository to Vercel and want Vercel to serve or build the files inside `iac-project/`, here are two safe options:

1) Use the repository-level `vercel.json` (already added in the repo root)
    - The included `vercel.json` routes requests to `iac-project/` and uses the `@vercel/static` builder so files in `iac-project` are served as static assets.
    - No extra build command is required for static files. This is the simplest option if you just want to publish documentation or static content from this folder.

2) Configure the project in the Vercel dashboard
    - In your Vercel Project settings set the "Root Directory" to `iac-project/` (if you prefer per-project setting).
    - Build Command: leave blank or use a simple command if you have a build step.
    - Output Directory: leave blank for static serving, or set it to the folder that contains the generated site if you add a static generator.

Notes and CI hints
- Do NOT commit Terraform state files into source control (`*.tfstate`, `*.tfstate.backup`). This repo already ignores them via `iac-project/.gitignore` but if you ever see `terraform.tfstate` in the repo, remove it and move to remote state.
- Prefer a remote Terraform backend (Terraform Cloud, S3 with locking, Azure/GCP storage) for multi-user work.
- If you want Vercel to run a CI step that invokes Terraform (not typical), consider using a separate pipeline (GitHub Actions, GitLab CI, or a dedicated runner) because Vercel builds are intended for web apps and static sites. Example GitHub Actions job (in .github/workflows/terraform.yml):

```yaml
name: Terraform

on:
   push:
      paths:
         - 'iac-project/**'

jobs:
   terraform:
      runs-on: ubuntu-latest
      steps:
         - uses: actions/checkout@v4
            with:
               path: repo
         - name: Set up Terraform
            uses: hashicorp/setup-terraform@v2
         - name: Terraform Init
            working-directory: repo/iac-project
            run: terraform init
         - name: Terraform Validate
            working-directory: repo/iac-project
            run: terraform validate

```

## Approval for apply runs (recommended)

To prevent accidental or unauthorized `terraform apply` runs, configure a GitHub Environment and require approvals:

1. In GitHub go to: Settings → Environments → New environment. Name it `terraform-apply` (the workflow uses this name).
2. Add required reviewers (users or teams) who must approve runs that target this environment.
3. Optionally set secrets scoped to the environment for provider credentials.

With this in place, any workflow job that sets `environment: terraform-apply` will pause and require an approval from one of the configured reviewers before `apply` steps run. This is a recommended safety step for production infra.

That keeps infrastructure runs in CI designed for infra (and not in Vercel builds).