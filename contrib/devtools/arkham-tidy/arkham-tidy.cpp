// Copyright (c) 2023 Arkham Developers
// Distributed under the MIT software license, see the accompanying
// file COPYING or http://www.opensource.org/licenses/mit-license.php.

#include "nontrivial-threadlocal.h"

#include <clang-tidy/ClangTidyModule.h>
#include <clang-tidy/ClangTidyModuleRegistry.h>

class ArkhamModule final : public clang::tidy::ClangTidyModule
{
public:
    void addCheckFactories(clang::tidy::ClangTidyCheckFactories& CheckFactories) override
    {
        CheckFactories.registerCheck<arkham::NonTrivialThreadLocal>("arkham-nontrivial-threadlocal");
    }
};

static clang::tidy::ClangTidyModuleRegistry::Add<ArkhamModule>
    X("arkham-module", "Adds arkham checks.");

volatile int ArkhamModuleAnchorSource = 0;
