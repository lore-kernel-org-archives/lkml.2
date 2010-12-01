Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754413Ab0LAB75 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 20:59:57 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:50611 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754122Ab0LAB6p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 20:58:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=sA33SPuH18j1wdbnbAyoU4A+AEgvofbqN5FmjjXDasjrcMbSfeHqGyzTaHrEarCzcy
         32IDlnaO+demJY1RA/c0NECftUD2ekxx+AimWsmIirb9SFqTq2w/hJ/VC9yevQu1MfQo
         Uiu+1xuj1OIOph1/qZ8Zbw4iBVCGqrq1dwU3o=
From: Shawn Bohrer <shawn.bohrer@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, Shawn Bohrer <shawn.bohrer@gmail.com>
Subject: [PATCH 10/14] perf: Document missing sched options
Date: Tue, 30 Nov 2010 19:57:18 -0600
Message-Id: <1291168642-11402-11-git-send-email-shawn.bohrer@gmail.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1291168642-11402-1-git-send-email-shawn.bohrer@gmail.com>
References: <1291168642-11402-1-git-send-email-shawn.bohrer@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Shawn Bohrer <shawn.bohrer@gmail.com>
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
1.7.3.2

