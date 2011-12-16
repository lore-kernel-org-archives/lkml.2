Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752757Ab1LPKJT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 05:09:19 -0500
Received: from www.linutronix.de ([62.245.132.108]:40682 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751443Ab1LPKJO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 05:09:14 -0500
From: Richard Weinberger <richard@nod.at>
To: tglx@linutronix.de
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org,
        Richard Weinberger <richard@nod.at>,
        Richard Weinberger <rw@linutronix.de>
Subject: [PATCH] [TRIVIAL] Fix typo in request_threaded_irq()
Date: Fri, 16 Dec 2011 11:09:02 +0100
Message-Id: <1324030142-3367-1-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.7.3
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Richard Weinberger <rw@linutronix.de>
---
 kernel/irq/manage.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 1da999f..a9a9dbe 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -1292,7 +1292,7 @@ EXPORT_SYMBOL(free_irq);
  *	and to set up the interrupt handler in the right order.
  *
  *	If you want to set up a threaded irq handler for your device
- *	then you need to supply @handler and @thread_fn. @handler ist
+ *	then you need to supply @handler and @thread_fn. @handler is
  *	still called in hard interrupt context and has to check
  *	whether the interrupt originates from the device. If yes it
  *	needs to disable the interrupt on the device and return
-- 
1.7.7.3

