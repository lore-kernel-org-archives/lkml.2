Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752354Ab2GTT0P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 15:26:15 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:55467 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751908Ab2GTT0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 15:26:14 -0400
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH] preempt/hardirq.h: Fix comment about PREEMPT_ACTIVE bit
 location
To: rostedt@goodmis.org, tglx@linutronix.de
Cc: mingo@kernel.org, paulmck@linux.vnet.ibm.com, josh@joshtriplett.org,
        linux-kernel@vger.kernel.org
Date: Sat, 21 Jul 2012 00:54:59 +0530
Message-ID: <20120720192459.6149.14821.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 12072019-9264-0000-0000-000001F2944B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PREEMPT_ACTIVE flag is bit 27, not 28. Fix the comment.

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
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

