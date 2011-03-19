Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757320Ab1CSSXC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Mar 2011 14:23:02 -0400
Received: from hera.kernel.org ([140.211.167.34]:54484 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752621Ab1CSSXA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Mar 2011 14:23:00 -0400
Date: Sat, 19 Mar 2011 18:22:22 GMT
From: tip-bot for Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        peterz@infradead.org, tglx@linutronix.de, randy.dunlap@oracle.com,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, randy.dunlap@oracle.com,
        mingo@elte.hu
In-Reply-To: <20110318093453.8f7489a4.randy.dunlap@oracle.com>
References: <20110318093453.8f7489a4.randy.dunlap@oracle.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched: Fix yield_to kernel-doc
Message-ID: <tip-16addf954d3954a72fd56abc02ffcba3c18529a1@git.kernel.org>
Git-Commit-ID: 16addf954d3954a72fd56abc02ffcba3c18529a1
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 19 Mar 2011 18:22:22 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  16addf954d3954a72fd56abc02ffcba3c18529a1
Gitweb:     http://git.kernel.org/tip/16addf954d3954a72fd56abc02ffcba3c18529a1
Author:     Randy Dunlap <randy.dunlap@oracle.com>
AuthorDate: Fri, 18 Mar 2011 09:34:53 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 19 Mar 2011 19:19:36 +0100

sched: Fix yield_to kernel-doc

Add missing function parameters for yield_to():

 Warning(kernel/sched.c:5470): No description found for parameter 'p'
 Warning(kernel/sched.c:5470): No description found for parameter 'preempt'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <20110318093453.8f7489a4.randy.dunlap@oracle.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 58d66ea..052120d 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -5467,6 +5467,8 @@ EXPORT_SYMBOL(yield);
  * yield_to - yield the current processor to another thread in
  * your thread group, or accelerate that thread toward the
  * processor it's on.
+ * @p: target task
+ * @preempt: whether task preemption is allowed or not
  *
  * It's the caller's job to ensure that the target task struct
  * can't go away on us before we can do any checks.
