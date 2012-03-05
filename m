Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756240Ab2CEQUj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 11:20:39 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60879 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754946Ab2CEQUh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 11:20:37 -0500
Date: Mon, 5 Mar 2012 08:19:46 -0800
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-67cbbd7f1838cc8f6900f39d860d6c2e1f86cf61@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1329980894-4289-1-git-send-email-namhyung.kim@lge.com>
References: <1329980894-4289-1-git-send-email-namhyung.kim@lge.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Add descriptions of missing Makefile arguments
Git-Commit-ID: 67cbbd7f1838cc8f6900f39d860d6c2e1f86cf61
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 05 Mar 2012 08:20:14 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  67cbbd7f1838cc8f6900f39d860d6c2e1f86cf61
Gitweb:     http://git.kernel.org/tip/67cbbd7f1838cc8f6900f39d860d6c2e1f86cf61
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Thu, 23 Feb 2012 16:08:14 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 5 Mar 2012 10:15:50 -0300

perf tools: Add descriptions of missing Makefile arguments

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
 1 files changed, 14 insertions(+), 0 deletions(-)

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
