Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756234Ab1BJMZL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 07:25:11 -0500
Received: from cantor2.suse.de ([195.135.220.15]:37655 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756119Ab1BJMZG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 07:25:06 -0500
From: stable-bot for Dave Young <hidave.darkstar@gmail.com>
Date: Thu, 10 Feb 2011 10:23:26 +0100
Subject: [PATCH 15/28] sched: Remove unused PF_ALIGNWARN flag
To: stable@kernel.org
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@elte.hu>
Message-ID: <1297340644.5512.15.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit: 637bbdc5b83615ef9f45f50399d1c7f27473c713 upstream
Author: Dave Young <hidave.darkstar@gmail.com>
AuthorDate: Mon Sep 13 20:19:03 2010 +0800

PF_ALIGNWARN is not implemented and it is for 486 as the
comment.

It is not likely someone will implement this flag feature.
So here remove this flag and leave the valuable 0x00000001 for
future use.

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
LKML-Reference: <20100913121903.GB22238@darkstar>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Mike Galbraith <efault@gmx.de>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/sched.h |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index c43d86b..32bf471 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1728,8 +1728,6 @@ extern void thread_group_times(struct task_struct *p, cputime_t *ut, cputime_t *
 /*
  * Per process flags
  */
-#define PF_ALIGNWARN	0x00000001	/* Print alignment warning msgs */
-					/* Not implemented yet, only for 486*/
 #define PF_STARTING	0x00000002	/* being created */
 #define PF_EXITING	0x00000004	/* getting shut down */
 #define PF_EXITPIDONE	0x00000008	/* pi exit done on shut down */
-- 
1.7.4


