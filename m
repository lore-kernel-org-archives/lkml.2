Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754880Ab2CEP5f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 10:57:35 -0500
Received: from merlin.infradead.org ([205.233.59.134]:45778 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753264Ab2CEPzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 10:55:45 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 2/7] perf tools: Add descriptions of missing Makefile arguments
Date: Mon,  5 Mar 2012 12:55:27 -0300
Message-Id: <1330962932-1796-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1330962932-1796-1-git-send-email-acme@infradead.org>
References: <1330962932-1796-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

There are some variable arguments can be specified on make invocation,
but some of them are missing descriptions so that user cannot be
informed easily. Fix it.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1329980894-4289-1-git-send-email-namhyung.kim@lge.com
Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index e011b50..fa04340 100644
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
1.7.9.2.358.g22243

