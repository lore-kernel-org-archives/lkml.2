Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758848Ab0DHOkH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 10:40:07 -0400
Received: from casper.infradead.org ([85.118.1.10]:41492 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758787Ab0DHOjF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 10:39:05 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Randy Dunlap <randy.dunlap@oracle.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 5/6] perf: cleanup some Documentation
Date: Thu,  8 Apr 2010 11:38:48 -0300
Message-Id: <1270737529-24258-6-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1270737529-24258-1-git-send-email-acme@infradead.org>
References: <1270737529-24258-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Correct typos in perf bench & perf sched help text.

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
Cc: Paul Mackerras <paulus@samba.org>
LKML-Reference: <20100331113100.cc898487.randy.dunlap@oracle.com>
Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 tools/perf/Documentation/perf-bench.txt |    6 +++---
 tools/perf/Documentation/perf-sched.txt |    4 ++--
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/tools/perf/Documentation/perf-bench.txt b/tools/perf/Documentation/perf-bench.txt
index ae525ac..0181ddd 100644
--- a/tools/perf/Documentation/perf-bench.txt
+++ b/tools/perf/Documentation/perf-bench.txt
@@ -19,12 +19,12 @@ COMMON OPTIONS
 -f::
 --format=::
 Specify format style.
-Current available format styles are,
+Current available format styles are:
 
 'default'::
 Default style. This is mainly for human reading.
 ---------------------
-% perf bench sched pipe                      # with no style specify
+% perf bench sched pipe                      # with no style specified
 (executing 1000000 pipe operations between two tasks)
         Total time:5.855 sec
                 5.855061 usecs/op
@@ -79,7 +79,7 @@ options (20 sender and receiver processes per group)
 
       Total time:0.308 sec
 
-% perf bench sched messaging -t -g 20        # be multi-thread,with 20 groups
+% perf bench sched messaging -t -g 20        # be multi-thread, with 20 groups
 (20 sender and receiver threads per group)
 (20 groups == 800 threads run)
 
diff --git a/tools/perf/Documentation/perf-sched.txt b/tools/perf/Documentation/perf-sched.txt
index 1ce7919..8417644 100644
--- a/tools/perf/Documentation/perf-sched.txt
+++ b/tools/perf/Documentation/perf-sched.txt
@@ -12,7 +12,7 @@ SYNOPSIS
 
 DESCRIPTION
 -----------
-There's four variants of perf sched:
+There are four variants of perf sched:
 
   'perf sched record <command>' to record the scheduling events
   of an arbitrary workload.
@@ -27,7 +27,7 @@ There's four variants of perf sched:
   via perf sched record. (this is done by starting up mockup threads
   that mimic the workload based on the events in the trace. These
   threads can then replay the timings (CPU runtime and sleep patterns)
-  of the workload as it occured when it was recorded - and can repeat
+  of the workload as it occurred when it was recorded - and can repeat
   it a number of times, measuring its performance.)
 
 OPTIONS
-- 
1.6.2.5

