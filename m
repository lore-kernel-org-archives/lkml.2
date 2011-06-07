Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757460Ab1FGRxr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 13:53:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12028 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757443Ab1FGRxo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 13:53:44 -0400
Date: Tue, 7 Jun 2011 19:51:42 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, vapier@gentoo.org, tj@kernel.org
Subject: [PATCH -mm] ptrace-unify-show_regs-prototype-fix
Message-ID: <20110607175142.GA29525@redhat.com>
References: <201106062124.p56LO6Hn023286@imap1.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201106062124.p56LO6Hn023286@imap1.linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(to fold into ptrace-unify-show_regs-prototype.patch)

No need to declare show_regs() in ptrace.h, sched.h does this.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 include/linux/ptrace.h |    1 -
 1 file changed, 1 deletion(-)

--- ptrace/include/linux/ptrace.h~show_regs	2011-06-07 19:44:46.000000000 +0200
+++ ptrace/include/linux/ptrace.h	2011-06-07 19:45:15.000000000 +0200
@@ -100,7 +100,6 @@
 #include <linux/sched.h>		/* For struct task_struct.  */
 
 
-extern void show_regs(struct pt_regs *);
 extern long arch_ptrace(struct task_struct *child, long request,
 			unsigned long addr, unsigned long data);
 extern int ptrace_readdata(struct task_struct *tsk, unsigned long src, char __user *dst, int len);

