Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756981Ab1GAPZ4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 11:25:56 -0400
Received: from hera.kernel.org ([140.211.167.34]:42646 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752456Ab1GAPZx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 11:25:53 -0400
Date: Fri, 1 Jul 2011 15:25:36 GMT
From: tip-bot for Namhyung Kim <namhyung@gmail.com>
Message-ID: <tip-ce2bec5f13bf16206184ed3188e278db45927cb3@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
        mingo@redhat.com, a.p.zijlstra@chello.nl, acme@ghostprotocols.net,
        namhyung@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        acme@ghostprotocols.net, tglx@linutronix.de, namhyung@gmail.com,
        mingo@elte.hu
In-Reply-To: <1308847562-5100-1-git-send-email-namhyung@gmail.com>
References: <1308847562-5100-1-git-send-email-namhyung@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf script: Rename old perf-trace to perf-script
Git-Commit-ID: ce2bec5f13bf16206184ed3188e278db45927cb3
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 01 Jul 2011 15:25:37 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ce2bec5f13bf16206184ed3188e278db45927cb3
Gitweb:     http://git.kernel.org/tip/ce2bec5f13bf16206184ed3188e278db45927cb3
Author:     Namhyung Kim <namhyung@gmail.com>
AuthorDate: Fri, 24 Jun 2011 01:46:02 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 1 Jul 2011 12:51:26 +0200

perf script: Rename old perf-trace to perf-script

Fix the leftovers from commit 133dc4c39c57 ("perf: Rename
'perf trace' to 'perf script'").

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Link: http://lkml.kernel.org/r/1308847562-5100-1-git-send-email-namhyung@gmail.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/Documentation/perf-probe.txt            |    2 +-
 .../util/scripting-engines/trace-event-python.c    |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/Documentation/perf-probe.txt b/tools/perf/Documentation/perf-probe.txt
index 02bafce..41343d6 100644
--- a/tools/perf/Documentation/perf-probe.txt
+++ b/tools/perf/Documentation/perf-probe.txt
@@ -183,4 +183,4 @@ Delete all probes on schedule().
 
 SEE ALSO
 --------
-linkperf:perf-trace[1], linkperf:perf-record[1]
+linkperf:perf-script[1], linkperf:perf-record[1]
diff --git a/tools/perf/util/scripting-engines/trace-event-python.c b/tools/perf/util/scripting-engines/trace-event-python.c
index 6ccf70e..8173636 100644
--- a/tools/perf/util/scripting-engines/trace-event-python.c
+++ b/tools/perf/util/scripting-engines/trace-event-python.c
@@ -465,7 +465,7 @@ static int python_generate_script(const char *outfile)
 	fprintf(ofp, "# be retrieved using Python functions of the form "
 		"common_*(context).\n");
 
-	fprintf(ofp, "# See the perf-trace-python Documentation for the list "
+	fprintf(ofp, "# See the perf-script-python Documentation for the list "
 		"of available functions.\n\n");
 
 	fprintf(ofp, "import os\n");
