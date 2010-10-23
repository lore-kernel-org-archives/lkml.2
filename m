Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757891Ab0JWQQN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Oct 2010 12:16:13 -0400
Received: from igloo.linux.gr ([62.1.205.36]:52782 "EHLO igloo.linux.gr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756908Ab0JWQQM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Oct 2010 12:16:12 -0400
X-Greylist: delayed 560 seconds by postgrey-1.27 at vger.kernel.org; Sat, 23 Oct 2010 12:16:11 EDT
X-Hellug-MailScanner-From: serzan@hellug.gr
X-Hellug-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-2.9, required 5, autolearn=not spam, ALL_TRUSTED -1.00,
	BAYES_00 -1.90)
X-Hellug-MailScanner: Found to be clean
X-Hellug-MailScanner-ID: o9NG6XJC030119
From: Serafeim Zanikolas <sez@debian.org>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] time: jiffies.c: fix typos in comment
Date: Sat, 23 Oct 2010 18:06:26 +0200
Message-Id: <1287849986-5936-1-git-send-email-sez@debian.org>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Serafeim Zanikolas <sez@debian.org>
---
 kernel/time/jiffies.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/time/jiffies.c b/kernel/time/jiffies.c
index 5404a84..12ba9a7 100644
--- a/kernel/time/jiffies.c
+++ b/kernel/time/jiffies.c
@@ -30,8 +30,8 @@
  * the timer interrupt frequency HZ and it suffers
  * inaccuracies caused by missed or lost timer
  * interrupts and the inability for the timer
- * interrupt hardware to accuratly tick at the
- * requested HZ value. It is also not reccomended
+ * interrupt hardware to accurately tick at the
+ * requested HZ value. It is also not recommended
  * for "tick-less" systems.
  */
 #define NSEC_PER_JIFFY	((u32)((((u64)NSEC_PER_SEC)<<8)/ACTHZ))
-- 
1.7.1

