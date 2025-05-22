# Copyright (c) 2023-present The Arkham Core developers
# Distributed under the MIT software license, see the accompanying
# file COPYING or https://opensource.org/license/mit/.

function(generate_setup_nsi)
  set(abs_top_srcdir ${PROJECT_SOURCE_DIR})
  set(abs_top_builddir ${PROJECT_BINARY_DIR})
  set(CLIENT_URL ${PROJECT_HOMEPAGE_URL})
  set(CLIENT_TARNAME "arkham")
  set(ARKHAM_GUI_NAME "arkham-qt")
  set(ARKHAM_DAEMON_NAME "arkhamd")
  set(ARKHAM_CLI_NAME "arkham-cli")
  set(ARKHAM_TX_NAME "arkham-tx")
  set(ARKHAM_WALLET_TOOL_NAME "arkham-wallet")
  set(ARKHAM_TEST_NAME "test_arkham")
  set(EXEEXT ${CMAKE_EXECUTABLE_SUFFIX})
  configure_file(${PROJECT_SOURCE_DIR}/share/setup.nsi.in ${PROJECT_BINARY_DIR}/arkham-win64-setup.nsi USE_SOURCE_PERMISSIONS @ONLY)
endfunction()
