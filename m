Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756931Ab0CaSdQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 14:33:16 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:55599 "EHLO
	rcsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756566Ab0CaSdM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 14:33:12 -0400
Date: Wed, 31 Mar 2010 11:31:00 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
       Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH] perf: cleanup some Documentation
Message-Id: <20100331113100.cc898487.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A0B0207.4BB3952F.00F6:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Correct typos in perf bench & perf sched help text.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 tools/perf/Documentation/perf-bench.txt |    6 +++---
 tools/perf/Documentation/perf-sched.txt |    4 ++--
 2 files changed, 5 insertions(+), 5 deletions(-)

--- lnx-2634-rc3.orig/tools/perf/Documentation/perf-bench.txt
+++ lnx-2634-rc3/tools/perf/Documentation/perf-bench.txt
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
@@ -79,7 +79,7 @@ options (20 sender and receiver processe
 
       Total time:0.308 sec
 
-% perf bench sched messaging -t -g 20        # be multi-thread,with 20 groups
+% perf bench sched messaging -t -g 20        # be multi-thread, with 20 groups
 (20 sender and receiver threads per group)
 (20 groups == 800 threads run)
 
--- lnx-2634-rc3.orig/tools/perf/Documentation/perf-sched.txt
+++ lnx-2634-rc3/tools/perf/Documentation/perf-sched.txt
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
---
~Randy
