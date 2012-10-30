Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934063Ab2J3Qjc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 12:39:32 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:60314 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757873Ab2J3Qj3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 12:39:29 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 1/4] srcu: Credit Lai Jiangshan with SRCU rewrite
Date: Tue, 30 Oct 2012 09:38:07 -0700
Message-Id: <1351615090-24398-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <20121030163650.GA23518@linux.vnet.ibm.com>
References: <20121030163650.GA23518@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12103016-5406-0000-0000-0000018E5087
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lai Jiangshan <laijs@cn.fujitsu.com>

Lai Jiangshan rewrote SRCU, so this commit ensures that he gets his
proper share of blame^Wcredit.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/srcu.h |    2 ++
 kernel/srcu.c        |    2 ++
 2 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/include/linux/srcu.h b/include/linux/srcu.h
index 55a5c52..a55ddb1 100644
--- a/include/linux/srcu.h
+++ b/include/linux/srcu.h
@@ -16,8 +16,10 @@
  * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
  *
  * Copyright (C) IBM Corporation, 2006
+ * Copyright (C) Fujitsu, 2012
  *
  * Author: Paul McKenney <paulmck@us.ibm.com>
+ *	   Lai Jiangshan <laijs@cn.fujitsu.com>
  *
  * For detailed explanation of Read-Copy Update mechanism see -
  * 		Documentation/RCU/ *.txt
diff --git a/kernel/srcu.c b/kernel/srcu.c
index 97c465e..0b99f27 100644
--- a/kernel/srcu.c
+++ b/kernel/srcu.c
@@ -16,8 +16,10 @@
  * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
  *
  * Copyright (C) IBM Corporation, 2006
+ * Copyright (C) Fujitsu, 2012
  *
  * Author: Paul McKenney <paulmck@us.ibm.com>
+ *	   Lai Jiangshan <laijs@cn.fujitsu.com>
  *
  * For detailed explanation of Read-Copy Update mechanism see -
  * 		Documentation/RCU/ *.txt
-- 
1.7.8

