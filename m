Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757168Ab1CRQfK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 12:35:10 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:47730 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756917Ab1CRQfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 12:35:07 -0400
Date: Fri, 18 Mar 2011 09:34:53 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH] sched: fix yield_to kernel-doc
Message-Id: <20110318093453.8f7489a4.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt356.oracle.com [141.146.40.156]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4D8389B1.0075,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Add missing function parameters for yield_to():

Warning(kernel/sched.c:5470): No description found for parameter 'p'
Warning(kernel/sched.c:5470): No description found for parameter 'preempt'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
---
Corrections needed?

 kernel/sched.c |    2 ++
 1 file changed, 2 insertions(+)

--- linux-2.6.38-git4.orig/kernel/sched.c
+++ linux-2.6.38-git4/kernel/sched.c
@@ -5460,6 +5460,8 @@ EXPORT_SYMBOL(yield);
  * yield_to - yield the current processor to another thread in
  * your thread group, or accelerate that thread toward the
  * processor it's on.
+ * @p: target task
+ * @preempt: whether task preemption is allowed or not
  *
  * It's the caller's job to ensure that the target task struct
  * can't go away on us before we can do any checks.
