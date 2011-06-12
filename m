Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753191Ab1FLLd4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jun 2011 07:33:56 -0400
Received: from jester.euphonynet.be ([212.87.96.13]:58464 "EHLO
	mailpush2.euphonynet.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751692Ab1FLLdz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jun 2011 07:33:55 -0400
From: Bart Van Assche <bvanassche@acm.org>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Fix spelling - change hsot into shot
Date: Sun, 12 Jun 2011 13:33:45 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.38.8-scst; KDE/4.6.0; x86_64; ; )
Cc: Thomas Gleixner <tglx@linutronix.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201106121333.45603.bvanassche@acm.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 kernel/irq/manage.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index d64bafb..30fb079 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -654,7 +654,7 @@ again:
 	 * to IRQS_INPROGRESS and the irq line is masked forever.
 	 *
 	 * This also serializes the state of shared oneshot handlers
-	 * versus "desc->threads_onehsot |= action->thread_mask;" in
+	 * versus "desc->threads_oneshot |= action->thread_mask;" in
 	 * irq_wake_thread(). See the comment there which explains the
 	 * serialization.
 	 */
-- 
1.7.3.4

