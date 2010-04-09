Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754922Ab0DIFrf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 01:47:35 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:44741 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754620Ab0DIFra (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 01:47:30 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/urgent 4/4] rcu: fix syntax error in rcu_dereference_check() example in comment
Date: Thu,  8 Apr 2010 22:47:22 -0700
Message-Id: <1270792042-9358-4-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <20100409054701.GA8833@linux.vnet.ibm.com>
References: <20100409054701.GA8833@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Need a logical "or" rather than a comma.

Suggested-by: Yong Zhang <yong.zhang@windriver.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/rcupdate.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 6cdb176..b769184 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -217,7 +217,7 @@ static inline int rcu_read_lock_sched_held(void)
  * target struct:
  *
  *	bar = rcu_dereference_check(foo->bar, rcu_read_lock_held() ||
- *					      lockdep_is_held(&foo->lock),
+ *					      lockdep_is_held(&foo->lock) ||
  *					      atomic_read(&foo->usage) == 0);
  */
 #define rcu_dereference_check(p, c) \
-- 
1.7.0

