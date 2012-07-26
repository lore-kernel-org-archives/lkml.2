Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752740Ab2GZPRW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 11:17:22 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38174 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752426Ab2GZPRT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 11:17:19 -0400
Date: Thu, 26 Jul 2012 08:15:30 -0700
From: "tip-bot for Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Message-ID: <tip-a7e4786b937a3ae918a7520cfdba557a80915fa7@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, srivatsa.bhat@linux.vnet.ibm.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de,
        srivatsa.bhat@linux.vnet.ibm.com
In-Reply-To: <20120720192459.6149.14821.stgit@srivatsabhat.in.ibm.com>
References: <20120720192459.6149.14821.stgit@srivatsabhat.in.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched:
  Fix comment about PREEMPT_ACTIVE bit location
Git-Commit-ID: a7e4786b937a3ae918a7520cfdba557a80915fa7
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 26 Jul 2012 08:15:36 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a7e4786b937a3ae918a7520cfdba557a80915fa7
Gitweb:     http://git.kernel.org/tip/a7e4786b937a3ae918a7520cfdba557a80915fa7
Author:     Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
AuthorDate: Sat, 21 Jul 2012 00:54:59 +0530
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 26 Jul 2012 13:54:58 +0200

sched: Fix comment about PREEMPT_ACTIVE bit location

PREEMPT_ACTIVE flag is bit 27, not 28. Fix the comment.

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Cc: paulmck@linux.vnet.ibm.com
Cc: josh@joshtriplett.org
Cc: rostedt@goodmis.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/20120720192459.6149.14821.stgit@srivatsabhat.in.ibm.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/hardirq.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/hardirq.h b/include/linux/hardirq.h
index bb7f309..305f23c 100644
--- a/include/linux/hardirq.h
+++ b/include/linux/hardirq.h
@@ -22,7 +22,7 @@
  *
  * - bits 16-25 are the hardirq count (max # of nested hardirqs: 1024)
  * - bit 26 is the NMI_MASK
- * - bit 28 is the PREEMPT_ACTIVE flag
+ * - bit 27 is the PREEMPT_ACTIVE flag
  *
  * PREEMPT_MASK: 0x000000ff
  * SOFTIRQ_MASK: 0x0000ff00
