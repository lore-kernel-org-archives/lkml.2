Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753359Ab0DTVrP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 17:47:15 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:47516 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752564Ab0DTVpL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 17:45:11 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 23/23] rcu: make SRCU usable in modules
Date: Tue, 20 Apr 2010 14:44:55 -0700
Message-Id: <1271799895-21028-23-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <20100420214431.GA20777@linux.vnet.ibm.com>
References: <20100420214431.GA20777@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a #include for mutex.h to allow SRCU to be more easily used in
kernel modules.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/srcu.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/srcu.h b/include/linux/srcu.h
index 9c01f10..4d5d2f5 100644
--- a/include/linux/srcu.h
+++ b/include/linux/srcu.h
@@ -27,6 +27,8 @@
 #ifndef _LINUX_SRCU_H
 #define _LINUX_SRCU_H
 
+#include <linux/mutex.h>
+
 struct srcu_struct_array {
 	int c[2];
 };
-- 
1.7.0

