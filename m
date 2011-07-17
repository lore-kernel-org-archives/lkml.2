Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752397Ab1GQHBM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jul 2011 03:01:12 -0400
Received: from jester.euphonynet.be ([212.87.96.13]:36812 "EHLO
	mailpush2.euphonynet.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751852Ab1GQHBK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jul 2011 03:01:10 -0400
From: Bart Van Assche <bvanassche@acm.org>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] futex: Fix spelling in a source code comment
Date: Sun, 17 Jul 2011 09:01:00 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.38.8-scst; KDE/4.6.0; x86_64; ; )
Cc: Darren Hart <dvhltc@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>,
        trivial@kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201107170901.00119.bvanassche@acm.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change a single occurrence of "unlcoked" into "unlocked".

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: Darren Hart <dvhltc@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/futex.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index fe28dc2..dc5e742 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -1763,7 +1763,7 @@ static void futex_wait_queue_me(struct futex_hash_bucket *hb, struct futex_q *q,
  *
  * Returns:
  *  0 - uaddr contains val and hb has been locked
- * <1 - -EFAULT or -EWOULDBLOCK (uaddr does not contain val) and hb is unlcoked
+ * <1 - -EFAULT or -EWOULDBLOCK (uaddr does not contain val) and hb is unlocked
  */
 static int futex_wait_setup(u32 __user *uaddr, u32 val, unsigned int flags,
 			   struct futex_q *q, struct futex_hash_bucket **hb)
-- 
1.7.3.4

