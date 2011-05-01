Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756971Ab1EANWd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 09:22:33 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:54819 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755145Ab1EANWX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 09:22:23 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 12/86] rcu: Update RCU's trace.txt documentation for new format
Date: Sun,  1 May 2011 06:20:52 -0700
Message-Id: <1304256126-26015-12-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110501132142.GA25494@linux.vnet.ibm.com>
References: <20110501132142.GA25494@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul E. McKenney <paul.mckenney@linaro.org>

The trace.txt file had obsolete output for the debugfs rcu/rcudata
file, so update it.

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 Documentation/RCU/trace.txt |   65 ++++++++++++++++++++++--------------------
 1 files changed, 34 insertions(+), 31 deletions(-)

diff --git a/Documentation/RCU/trace.txt b/Documentation/RCU/trace.txt
index 5a704ff..13dbf9b 100644
--- a/Documentation/RCU/trace.txt
+++ b/Documentation/RCU/trace.txt
@@ -21,23 +21,23 @@ rcu_pending() function decided that there was core RCU work to do).
 The output of "cat rcu/rcudata" looks as follows:
 
 rcu_sched:
-  0 c=17829 g=17829 pq=1 pqc=17829 qp=0 dt=10951/1/0 df=1101 of=0 ri=36 ql=0 b=10
-  1 c=17829 g=17829 pq=1 pqc=17829 qp=0 dt=16117/1/0 df=1015 of=0 ri=0 ql=0 b=10
-  2 c=17829 g=17829 pq=1 pqc=17829 qp=0 dt=1445/1/0 df=1839 of=0 ri=0 ql=0 b=10
-  3 c=17829 g=17829 pq=1 pqc=17829 qp=0 dt=6681/1/0 df=1545 of=0 ri=0 ql=0 b=10
-  4 c=17829 g=17829 pq=1 pqc=17829 qp=0 dt=1003/1/0 df=1992 of=0 ri=0 ql=0 b=10
-  5 c=17829 g=17830 pq=1 pqc=17829 qp=1 dt=3887/1/0 df=3331 of=0 ri=4 ql=2 b=10
-  6 c=17829 g=17829 pq=1 pqc=17829 qp=0 dt=859/1/0 df=3224 of=0 ri=0 ql=0 b=10
-  7 c=17829 g=17830 pq=0 pqc=17829 qp=1 dt=3761/1/0 df=1818 of=0 ri=0 ql=2 b=10
+  0!c=423090 g=423091 pq=1 pqc=423090 qp=1 dt=86475/1/0 df=16319 of=163 ri=1519 ql=0 b=10 ci=1460693 co=1648 ca=6448
+  1!c=423329 g=423330 pq=1 pqc=423329 qp=1 dt=90875/1/0 df=16231 of=157 ri=1249 ql=0 b=10 ci=1459002 co=1614 ca=3310
+  2!c=423370 g=423371 pq=1 pqc=423370 qp=1 dt=69661/1/0 df=16125 of=163 ri=1469 ql=0 b=10 ci=1610701 co=2015 ca=2378
+  3!c=422967 g=422968 pq=1 pqc=422967 qp=1 dt=70349/1/0 df=12528 of=163 ri=1450 ql=0 b=10 ci=1427543 co=1430 ca=897
+  4!c=423196 g=423197 pq=1 pqc=423196 qp=0 dt=38935/1/0 df=10959 of=177 ri=1657 ql=0 b=10 ci=1562249 co=1896 ca=533
+  5!c=422950 g=422951 pq=1 pqc=422950 qp=0 dt=25127/1/0 df=5895 of=167 ri=1549 ql=0 b=10 ci=1777260 co=2137 ca=274
+  6!c=423396 g=423397 pq=1 pqc=423396 qp=1 dt=22639/1/0 df=4590 of=149 ri=1572 ql=0 b=10 ci=1471186 co=1530 ca=243
+  7 c=460203 g=460203 pq=1 pqc=460202 qp=0 dt=937087/1/0 df=3298 of=149 ri=1584 ql=6 b=10 ci=4026154 co=1948 ca=135
 rcu_bh:
-  0 c=-275 g=-275 pq=1 pqc=-275 qp=0 dt=10951/1/0 df=0 of=0 ri=0 ql=0 b=10
-  1 c=-275 g=-275 pq=1 pqc=-275 qp=0 dt=16117/1/0 df=13 of=0 ri=0 ql=0 b=10
-  2 c=-275 g=-275 pq=1 pqc=-275 qp=0 dt=1445/1/0 df=15 of=0 ri=0 ql=0 b=10
-  3 c=-275 g=-275 pq=1 pqc=-275 qp=0 dt=6681/1/0 df=9 of=0 ri=0 ql=0 b=10
-  4 c=-275 g=-275 pq=1 pqc=-275 qp=0 dt=1003/1/0 df=15 of=0 ri=0 ql=0 b=10
-  5 c=-275 g=-275 pq=1 pqc=-275 qp=0 dt=3887/1/0 df=15 of=0 ri=0 ql=0 b=10
-  6 c=-275 g=-275 pq=1 pqc=-275 qp=0 dt=859/1/0 df=15 of=0 ri=0 ql=0 b=10
-  7 c=-275 g=-275 pq=1 pqc=-275 qp=0 dt=3761/1/0 df=15 of=0 ri=0 ql=0 b=10
+  0!c=18446744073709551494 g=18446744073709551494 pq=0 pqc=18446744073709551493 qp=1 dt=86475/1/0 df=11 of=0 ri=0 ql=0 b=10 ci=112 co=0 ca=0
+  1!c=18446744073709551496 g=18446744073709551496 pq=1 pqc=18446744073709551495 qp=0 dt=90875/1/0 df=15 of=0 ri=0 ql=0 b=10 ci=143 co=0 ca=0
+  2!c=18446744073709551496 g=18446744073709551496 pq=1 pqc=18446744073709551495 qp=0 dt=69661/1/0 df=21 of=0 ri=1 ql=0 b=10 ci=88 co=0 ca=0
+  3!c=18446744073709551494 g=18446744073709551494 pq=1 pqc=18446744073709551493 qp=0 dt=70349/1/0 df=13 of=0 ri=0 ql=0 b=10 ci=100 co=0 ca=0
+  4!c=18446744073709551494 g=18446744073709551494 pq=0 pqc=18446744073709551493 qp=1 dt=38935/1/0 df=17 of=0 ri=0 ql=0 b=10 ci=36 co=0 ca=0
+  5!c=18446744073709551494 g=18446744073709551494 pq=0 pqc=18446744073709551493 qp=1 dt=25127/1/0 df=7 of=0 ri=0 ql=0 b=10 ci=32 co=0 ca=0
+  6!c=18446744073709551496 g=18446744073709551496 pq=1 pqc=18446744073709551495 qp=0 dt=22639/1/0 df=9 of=0 ri=0 ql=0 b=10 ci=44 co=0 ca=0
+  7 c=182 g=182 pq=1 pqc=181 qp=0 dt=937087/1/0 df=14 of=0 ri=1 ql=0 b=10 ci=627 co=0 ca=0
 
 The first section lists the rcu_data structures for rcu_sched, the second
 for rcu_bh.  Note that CONFIG_TREE_PREEMPT_RCU kernels will have an
@@ -52,17 +52,18 @@ o	The number at the beginning of each line is the CPU number.
 	substantially larger than the number of actual CPUs.
 
 o	"c" is the count of grace periods that this CPU believes have
-	completed.  CPUs in dynticks idle mode may lag quite a ways
-	behind, for example, CPU 4 under "rcu_sched" above, which has
-	slept through the past 25 RCU grace periods.  It is not unusual
-	to see CPUs lagging by thousands of grace periods.
+	completed.  Offlined CPUs and CPUs in dynticks idle mode may
+	lag quite a ways behind, for example, CPU 6 under "rcu_sched"
+	above, which has been offline through not quite 40,000 RCU grace
+	periods.  It is not unusual to see CPUs lagging by thousands of
+	grace periods.
 
 o	"g" is the count of grace periods that this CPU believes have
-	started.  Again, CPUs in dynticks idle mode may lag behind.
-	If the "c" and "g" values are equal, this CPU has already
-	reported a quiescent state for the last RCU grace period that
-	it is aware of, otherwise, the CPU believes that it owes RCU a
-	quiescent state.
+	started.  Again, offlined CPUs and CPUs in dynticks idle mode
+	may lag behind.  If the "c" and "g" values are equal, this CPU
+	has already reported a quiescent state for the last RCU grace
+	period that it is aware of, otherwise, the CPU believes that it
+	owes RCU a quiescent state.
 
 o	"pq" indicates that this CPU has passed through a quiescent state
 	for the current grace period.  It is possible for "pq" to be
@@ -81,14 +82,16 @@ o	"pqc" indicates which grace period the last-observed quiescent
 	the next grace period!
 
 o	"qp" indicates that RCU still expects a quiescent state from
-	this CPU.
+	this CPU.  Offlined CPUs and CPUs in dyntick idle mode might
+	well have qp=1, which is OK: RCU is still ignoring them.
 
 o	"dt" is the current value of the dyntick counter that is incremented
 	when entering or leaving dynticks idle state, either by the
-	scheduler or by irq.  The number after the first "/" is the
-	interrupt nesting depth when in dyntick-idle state, or one
-	greater than the interrupt-nesting depth otherwise.  The number
-	after the second "/" is the NMI nesting depth.
+	scheduler or by irq.  This number is even if the CPU is in
+	dyntick idle mode and odd otherwise.  The number after the first
+	"/" is the interrupt nesting depth when in dyntick-idle state,
+	or one greater than the interrupt-nesting depth otherwise.
+	The number after the second "/" is the NMI nesting depth.
 
 	This field is displayed only for CONFIG_NO_HZ kernels.
 
@@ -100,7 +103,7 @@ o	"df" is the number of times that some other CPU has forced a
 
 o	"of" is the number of times that some other CPU has forced a
 	quiescent state on behalf of this CPU due to this CPU being
-	offline.  In a perfect world, this might neve happen, but it
+	offline.  In a perfect world, this might never happen, but it
 	turns out that offlining and onlining a CPU can take several grace
 	periods, and so there is likely to be an extended period of time
 	when RCU believes that the CPU is online when it really is not.
-- 
1.7.3.2

