Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753065Ab0DMKo1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 06:44:27 -0400
Received: from hera.kernel.org ([140.211.167.34]:37050 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753022Ab0DMKoZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 06:44:25 -0400
Date: Tue, 13 Apr 2010 10:43:57 GMT
From: tip-bot for Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, tglx@linutronix.de, randy.dunlap@oracle.com
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, tglx@linutronix.de,
       randy.dunlap@oracle.com
In-Reply-To: <20100331113100.cc898487.randy.dunlap@oracle.com>
References: <20100331113100.cc898487.randy.dunlap@oracle.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: cleanup some Documentation
Message-ID: <tip-854c5548dfad017920a36201d40449fdbad90bfb@git.kernel.org>
Git-Commit-ID: 854c5548dfad017920a36201d40449fdbad90bfb
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 13 Apr 2010 10:43:57 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  854c5548dfad017920a36201d40449fdbad90bfb
Gitweb:     http://git.kernel.org/tip/854c5548dfad017920a36201d40449fdbad90bfb
Author:     Randy Dunlap <randy.dunlap@oracle.com>
AuthorDate: Wed, 31 Mar 2010 11:31:00 -0700
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 8 Apr 2010 11:34:26 -0300

perf: cleanup some Documentation

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
