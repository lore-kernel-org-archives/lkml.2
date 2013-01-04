Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754561Ab3ADSGn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 13:06:43 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:52007 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754098Ab3ADSGl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 13:06:41 -0500
From: Cody P Schafer <cody@linux.vnet.ibm.com>
To: Dipankar Sarma <dipankar@in.ibm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Cody P Schafer <cody@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] rcu: comment: correct 'optimized' to 'optimize'.
Date: Fri,  4 Jan 2013 12:59:40 -0500
Message-Id: <1357322381-9573-1-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.0.3
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13010418-7182-0000-0000-000004337127
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Small gramar fix in rcutree comment regarding 'rcu_scheduler_active'
var.
---
 kernel/rcutree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index e441b77..bfb8972 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -105,7 +105,7 @@ int rcu_num_nodes __read_mostly = NUM_RCU_NODES; /* Total # rcu_nodes in use. */
  * The rcu_scheduler_active variable transitions from zero to one just
  * before the first task is spawned.  So when this variable is zero, RCU
  * can assume that there is but one task, allowing RCU to (for example)
- * optimized synchronize_sched() to a simple barrier().  When this variable
+ * optimize synchronize_sched() to a simple barrier().  When this variable
  * is one, RCU must actually do all the hard work required to detect real
  * grace periods.  This variable is also used to suppress boot-time false
  * positives from lockdep-RCU error checking.
-- 
1.8.0.3

