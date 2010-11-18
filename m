Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933021Ab0KRXE3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 18:04:29 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:34210 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932996Ab0KRXE1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 18:04:27 -0500
Date: Thu, 18 Nov 2010 15:02:41 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] sched: fix kernel-doc for runqueue_is_locked
Message-Id: <20101118150241.34f0ca15.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix kernel-doc warning for runqueue_is_locked():

Warning(kernel/sched.c:664): missing initial short description on line:

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- lnx-2637-r2g4-kerndoc.orig/kernel/sched.c
+++ lnx-2637-r2g4-kerndoc/kernel/sched.c
@@ -664,10 +664,9 @@ inline void update_rq_clock(struct rq *r
 #endif
 
 /**
- * runqueue_is_locked
+ * runqueue_is_locked - Returns true if the current cpu runqueue is locked
  * @cpu: the processor in question.
  *
- * Returns true if the current cpu runqueue is locked.
  * This interface allows printk to be called with the runqueue lock
  * held and know whether or not it is OK to wake up the klogd.
  */
---
