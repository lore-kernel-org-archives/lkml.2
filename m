Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965072Ab2CFJxM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 04:53:12 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:38725 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758459Ab2CFJxK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 04:53:10 -0500
X-IronPort-AV: E=Sophos;i="4.73,539,1325433600"; 
   d="scan'208";a="4464390"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        darren@dvhart.com, fweisbec@gmail.com, patches@linaro.org
Subject: [PATCH 1/6] remove unused srcu_barrier()
Date: Tue, 6 Mar 2012 17:57:33 +0800
Message-Id: <1331027858-7648-1-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1331023359-6987-1-git-send-email-laijs@cn.fujitsu.com>
References: <1331023359-6987-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-03-06 17:51:08,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-03-06 17:51:14,
	Serialize complete at 2012-03-06 17:51:14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

srcu_barrier() is unused now.
This identifier is need for later.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 include/linux/srcu.h |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/include/linux/srcu.h b/include/linux/srcu.h
index 5b49d41..df8f5f7 100644
--- a/include/linux/srcu.h
+++ b/include/linux/srcu.h
@@ -49,12 +49,6 @@ struct srcu_struct {
 #endif /* #ifdef CONFIG_DEBUG_LOCK_ALLOC */
 };
 
-#ifndef CONFIG_PREEMPT
-#define srcu_barrier() barrier()
-#else /* #ifndef CONFIG_PREEMPT */
-#define srcu_barrier()
-#endif /* #else #ifndef CONFIG_PREEMPT */
-
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 
 int __init_srcu_struct(struct srcu_struct *sp, const char *name,
-- 
1.7.4.4

