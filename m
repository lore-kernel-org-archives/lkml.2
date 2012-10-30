Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758246Ab2J3WCo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 18:02:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49270 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753742Ab2J3WCm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 18:02:42 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 01/25] perf tools: Remove BINDIR define from exec_cmd.o compilation
Date: Tue, 30 Oct 2012 23:01:42 +0100
Message-Id: <1351634526-1516-2-git-send-email-jolsa@redhat.com>
In-Reply-To: <1351634526-1516-1-git-send-email-jolsa@redhat.com>
References: <1351634526-1516-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's not needed.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
---
 tools/perf/Makefile | 1 -
 1 file changed, 1 deletion(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index b1801e0..3e807d7 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -893,7 +893,6 @@ $(OUTPUT)%.s: %.S
 $(OUTPUT)util/exec_cmd.o: util/exec_cmd.c $(OUTPUT)PERF-CFLAGS
 	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) \
 		'-DPERF_EXEC_PATH="$(perfexecdir_SQ)"' \
-		'-DBINDIR="$(bindir_relative_SQ)"' \
 		'-DPREFIX="$(prefix_SQ)"' \
 		$<
 
-- 
1.7.11.7

