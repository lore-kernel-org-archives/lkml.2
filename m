Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755632Ab0LASBQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 13:01:16 -0500
Received: from canuck.infradead.org ([134.117.69.58]:58847 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464Ab0LASBO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 13:01:14 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Shawn Bohrer <shawn.bohrer@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 10/15] perf sched: Document missing options
Date: Wed,  1 Dec 2010 16:01:00 -0200
Message-Id: <1291226465-26337-11-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1291226465-26337-1-git-send-email-acme@infradead.org>
References: <1291226465-26337-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shawn Bohrer <shawn.bohrer@gmail.com>

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1291168642-11402-11-git-send-email-shawn.bohrer@gmail.com>
Signed-off-by: Shawn Bohrer <shawn.bohrer@gmail.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-sched.txt |   18 ++++++++++++++++--
 1 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/tools/perf/Documentation/perf-sched.txt b/tools/perf/Documentation/perf-sched.txt
index 8417644..46822d5 100644
--- a/tools/perf/Documentation/perf-sched.txt
+++ b/tools/perf/Documentation/perf-sched.txt
@@ -8,11 +8,11 @@ perf-sched - Tool to trace/measure scheduler properties (latencies)
 SYNOPSIS
 --------
 [verse]
-'perf sched' {record|latency|replay|trace}
+'perf sched' {record|latency|map|replay|trace}
 
 DESCRIPTION
 -----------
-There are four variants of perf sched:
+There are five variants of perf sched:
 
   'perf sched record <command>' to record the scheduling events
   of an arbitrary workload.
@@ -30,8 +30,22 @@ There are four variants of perf sched:
   of the workload as it occurred when it was recorded - and can repeat
   it a number of times, measuring its performance.)
 
+  'perf sched map' to print a textual context-switching outline of
+  workload captured via perf sched record.  Columns stand for
+  individual CPUs, and the two-letter shortcuts stand for tasks that
+  are running on a CPU. A '*' denotes the CPU that had the event, and
+  a dot signals an idle CPU.
+
 OPTIONS
 -------
+-i::
+--input=<file>::
+        Input file name. (default: perf.data)
+
+-v::
+--verbose::
+        Be more verbose. (show symbol address, etc)
+
 -D::
 --dump-raw-trace=::
         Display verbose dump of the sched data.
-- 
1.6.2.5

