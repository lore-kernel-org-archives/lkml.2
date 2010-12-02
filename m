Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757526Ab0LBLqY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 06:46:24 -0500
Received: from hera.kernel.org ([140.211.167.34]:53727 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751633Ab0LBLqW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 06:46:22 -0500
Date: Thu, 2 Dec 2010 11:46:01 GMT
From: tip-bot for Shawn Bohrer <shawn.bohrer@gmail.com>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
        shawn.bohrer@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        shawn.bohrer@gmail.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1291168642-11402-11-git-send-email-shawn.bohrer@gmail.com>
References: <1291168642-11402-11-git-send-email-shawn.bohrer@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf sched: Document missing options
Message-ID: <tip-1eacc94a66ce347abbf75f223361b21461331383@git.kernel.org>
Git-Commit-ID: 1eacc94a66ce347abbf75f223361b21461331383
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 02 Dec 2010 11:46:02 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1eacc94a66ce347abbf75f223361b21461331383
Gitweb:     http://git.kernel.org/tip/1eacc94a66ce347abbf75f223361b21461331383
Author:     Shawn Bohrer <shawn.bohrer@gmail.com>
AuthorDate: Tue, 30 Nov 2010 19:57:18 -0600
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 1 Dec 2010 18:22:48 -0200

perf sched: Document missing options

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
