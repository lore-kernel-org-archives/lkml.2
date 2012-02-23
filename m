Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752113Ab2BWGtV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 01:49:21 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:51770 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750843Ab2BWGtU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 01:49:20 -0500
X-AuditID: 9c93016f-b7cc4ae0000027c5-c0-4f45e16dde19
From: Namhyung Kim <namhyung.kim@lge.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: [PATCH] perf tools: Add descriptions of missing Makefile arguments
Date: Thu, 23 Feb 2012 16:08:14 +0900
Message-Id: <1329980894-4289-1-git-send-email-namhyung.kim@lge.com>
X-Mailer: git-send-email 1.7.9
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are some variable arguments can be specified on make invocation,
but some of them are missing descriptions so that user cannot be
informed easily. Fix it.

Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
---
 tools/perf/Makefile |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index e011b5060f92..fa043404479e 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -15,6 +15,16 @@ endif
 
 # Define V to have a more verbose compile.
 #
+# Define O to save output files in a separate directory.
+#
+# Define ARCH as name of target architecture if you want cross-builds.
+#
+# Define CROSS_COMPILE as prefix name of compiler if you want cross-builds.
+#
+# Define NO_LIBPERL to disable perl script extension.
+#
+# Define NO_LIBPYTHON to disable python script extension.
+#
 # Define PYTHON to point to the python binary if the default
 # `python' is not correct; for example: PYTHON=python2
 #
@@ -32,6 +42,10 @@ endif
 # Define NO_DWARF if you do not want debug-info analysis feature at all.
 #
 # Define WERROR=0 to disable treating any warnings as errors.
+#
+# Define NO_NEWT if you do not want TUI support.
+#
+# Define NO_DEMANGLE if you do not want C++ symbol demangling.
 
 $(OUTPUT)PERF-VERSION-FILE: .FORCE-PERF-VERSION-FILE
 	@$(SHELL_PATH) util/PERF-VERSION-GEN $(OUTPUT)
-- 
1.7.9

