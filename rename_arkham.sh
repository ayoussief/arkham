#!/bin/bash

# 1. Replace text content in all files (case-sensitive)
echo "Replacing text content..."
find . -type f ! -path "./.git/*" -exec sed -i 's/arkham/arkham/g' {} +
find . -type f ! -path "./.git/*" -exec sed -i 's/Arkham/Arkham/g' {} +
find . -type f ! -path "./.git/*" -exec sed -i 's/ARKHAM/ARKHAM/g' {} +

# 2. Special case for data directory (.arkham -> .arkham)
echo "Updating data directory references..."
find . -type f ! -path "./.git/*" -exec sed -i 's/\.arkham/\.arkham/g' {} +

# 3. Rename files and directories (FIXED: handles all cases first)
echo "Renaming files and directories..."
find . -depth -name "*ARKHAM*" -execdir rename -f 's/ARKHAM/ARKHAM/g' {} +
find . -depth -name "*Arkham*" -execdir rename -f 's/Arkham/Arkham/g' {} +
find . -depth -name "*arkham*" -execdir rename -f 's/arkham/arkham/g' {} +

# 4. Fix build system (only if configure.ac exists)
echo "Updating build system..."
if [ -f "configure.ac" ]; then
  sed -i 's/arkham/arkham/g' configure.ac
  sed -i 's/ARKHAM/ARKHAM/g' configure.ac
else
  echo "Warning: configure.ac not found"
fi

# 5. REMOVED redundant mv commands - handled by step 3

echo "Done! Now run:"
echo "./autogen.sh && ./configure && make"