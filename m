Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754840Ab0IMSnt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 14:43:49 -0400
Received: from hera.kernel.org ([140.211.167.34]:55997 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754754Ab0IMSnr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 14:43:47 -0400
Date: Mon, 13 Sep 2010 18:42:46 GMT
From: tip-bot for Dave Young <hidave.darkstar@gmail.com>
Cc: linux-kernel@vger.kernel.org, hidave.darkstar@gmail.com, hpa@zytor.com,
        mingo@redhat.com, torvalds@linux-foundation.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, hidave.darkstar@gmail.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        torvalds@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20100913121903.GB22238@darkstar>
References: <20100913121903.GB22238@darkstar>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Remove unused PF_ALIGNWARN flag
Message-ID: <tip-637bbdc5b83615ef9f45f50399d1c7f27473c713@git.kernel.org>
Git-Commit-ID: 637bbdc5b83615ef9f45f50399d1c7f27473c713
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 13 Sep 2010 18:42:48 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  637bbdc5b83615ef9f45f50399d1c7f27473c713
Gitweb:     http://git.kernel.org/tip/637bbdc5b83615ef9f45f50399d1c7f27473c713
Author:     Dave Young <hidave.darkstar@gmail.com>
AuthorDate: Mon, 13 Sep 2010 20:19:03 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 13 Sep 2010 20:39:08 +0200

sched: Remove unused PF_ALIGNWARN flag

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
---
 include/linux/sched.h |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index b51c53c..cdf5669 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1682,8 +1682,6 @@ extern void thread_group_times(struct task_struct *p, cputime_t *ut, cputime_t *
 /*
  * Per process flags
  */
-#define PF_ALIGNWARN	0x00000001	/* Print alignment warning msgs */
-					/* Not implemented yet, only for 486*/
 #define PF_STARTING	0x00000002	/* being created */
 #define PF_EXITING	0x00000004	/* getting shut down */
 #define PF_EXITPIDONE	0x00000008	/* pi exit done on shut down */
