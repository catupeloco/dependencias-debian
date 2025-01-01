# Introduction
This script was originally crafted to analyze the number of dependencies a package has.  
This allows you to select the package that has the minimal impact on the overall system size.

# Usage
- You can download the script and run it as an unprivileged user.  
- ***script.sh*** package-name-1 package-name-2 ***...*** package-name-n

# Output
- The script outputs all package dependencies in an indented tree structure.  
- Sublevels are shown in different colors for easier reading.  
- If the tree is long enough, the `less` command allows you to navigate with the arrow keys.
