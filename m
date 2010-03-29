Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755750Ab0C2Cdc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Mar 2010 22:33:32 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:59010 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755724Ab0C2Cdb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Mar 2010 22:33:31 -0400
Message-ID: <4BB01182.2090301@cn.fujitsu.com>
Date: Mon, 29 Mar 2010 10:33:38 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] rcu: remove needless struct notifier_block predeclaration
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


cleanup: remove needless struct notifier_block predeclaration 

diff --git a/include/linux/rcutiny.h b/include/linux/rcutiny.h
index a519587..ae7b05e 100644
--- a/include/linux/rcutiny.h
+++ b/include/linux/rcutiny.h
@@ -86,8 +86,6 @@ static inline void synchronize_rcu_bh_expedited(void)
 	synchronize_sched();
 }
 
-struct notifier_block;
-
 #ifdef CONFIG_NO_HZ
 
 extern void rcu_enter_nohz(void);
diff --git a/include/linux/rcutree.h b/include/linux/rcutree.h
index 42cc3a0..3be62e1 100644
--- a/include/linux/rcutree.h
+++ b/include/linux/rcutree.h
@@ -30,8 +30,6 @@
 #ifndef __LINUX_RCUTREE_H
 #define __LINUX_RCUTREE_H
 
-struct notifier_block;
-
 extern void rcu_sched_qs(int cpu);
 extern void rcu_bh_qs(int cpu);
 extern int rcu_needs_cpu(int cpu);
