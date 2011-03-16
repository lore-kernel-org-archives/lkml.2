Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753045Ab1CPN5D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 09:57:03 -0400
Received: from hera.kernel.org ([140.211.167.34]:35808 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752987Ab1CPN4w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 09:56:52 -0400
Date: Wed, 16 Mar 2011 13:56:22 GMT
From: tip-bot for Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        torvalds@linux-foundation.org, tglx@linutronix.de,
        randy.dunlap@oracle.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, tglx@linutronix.de,
        randy.dunlap@oracle.com, mingo@elte.hu
In-Reply-To: <20110315161230.c4e1e8e3.rdunlap@xenotime.net>
References: <20110315161230.c4e1e8e3.rdunlap@xenotime.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched, kernel-doc: Fix runqueue_is_locked() description
Message-ID: <tip-58cbe2476abce8b5e3508d23bd05c2e2e8c394da@git.kernel.org>
Git-Commit-ID: 58cbe2476abce8b5e3508d23bd05c2e2e8c394da
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 16 Mar 2011 13:56:22 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  58cbe2476abce8b5e3508d23bd05c2e2e8c394da
Gitweb:     http://git.kernel.org/tip/58cbe2476abce8b5e3508d23bd05c2e2e8c394da
Author:     Randy Dunlap <randy.dunlap@oracle.com>
AuthorDate: Tue, 15 Mar 2011 16:12:30 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 16 Mar 2011 14:00:23 +0100

sched, kernel-doc: Fix runqueue_is_locked() description

Fix kernel-doc warning for runqueue_is_locked():

  Warning(kernel/sched.c:664): missing initial short description

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
LKML-Reference: <20110315161230.c4e1e8e3.rdunlap@xenotime.net>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index c8e40b7..58d66ea 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -661,10 +661,9 @@ static void update_rq_clock(struct rq *rq)
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
