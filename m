Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933070Ab2FVPZf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 11:25:35 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:56394 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933013Ab2FVPZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 11:25:31 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 02/22] rcu: Four-level hierarchy is no longer experimental
Date: Fri, 22 Jun 2012 08:17:01 -0700
Message-Id: <1340378241-6458-2-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1340378241-6458-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20120622151655.GA6249@linux.vnet.ibm.com>
 <1340378241-6458-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12062215-5518-0000-0000-0000056D4BCA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Time to make the four-level-hierarchy setting less scary, so this
commit removes "Experimental" from the boot-time message.  Leave the
message in order to get a heads-up on any possible need to expand to
a five-level hierarchy.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree_plugin.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index 1f27554..61aab6f 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -68,7 +68,7 @@ static void __init rcu_bootup_announce_oddness(void)
 	printk(KERN_INFO "\tAdditional per-CPU info printed with stalls.\n");
 #endif
 #if NUM_RCU_LVL_4 != 0
-	printk(KERN_INFO "\tExperimental four-level hierarchy is enabled.\n");
+	printk(KERN_INFO "\tFour-level hierarchy is enabled.\n");
 #endif
 	if (rcu_fanout_leaf != CONFIG_RCU_FANOUT_LEAF)
 		printk(KERN_INFO "\tExperimental boot-time adjustment of leaf fanout to %d.\n", rcu_fanout_leaf);
-- 
1.7.8

