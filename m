Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751440Ab2GDMiN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 08:38:13 -0400
Received: from mail.lippert-at.com ([62.80.22.186]:14212 "EHLO
	domex.lippertembedded.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750963Ab2GDMiM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 08:38:12 -0400
X-Greylist: delayed 913 seconds by postgrey-1.27 at vger.kernel.org; Wed, 04 Jul 2012 08:38:12 EDT
Message-ID: <4FF4359E.6030808@LiPPERTEmbedded.de>
Date: Wed, 04 Jul 2012 14:22:54 +0200
From: Jens Rottmann <JRottmann@LiPPERTEmbedded.de>
User-Agent: Thunderbird 1.5.0.14 (Windows/20071210)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: John Stultz <johnstul@us.ibm.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] cs5535-clockevt: typo, it's MFGPT, not MFPGT
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 04 Jul 2012 12:22:57.0153 (UTC) FILETIME=[BE74FF10:01CD59DF]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cs5535-clockevt: typo, it's MFGPT, not MFPGT

Had me fooled for a while, "dmesg|grep -i mfgpt" wouldn't show anything.

Signed-off-by: Jens Rottmann <JRottmann@LiPPERTEmbedded.de>
---

--- linux-3.4/drivers/clocksource/cs5535-clockevt.c
+++ mfgpt_typo/drivers/clocksource/cs5535-clockevt.c
@@ -53,7 +53,7 @@
 #define MFGPT_PERIODIC (MFGPT_HZ / HZ)
 
 /*
- * The MFPGT timers on the CS5536 provide us with suitable timers to use
+ * The MFGPT timers on the CS5536 provide us with suitable timers to use
  * as clock event sources - not as good as a HPET or APIC, but certainly
  * better than the PIT.  This isn't a general purpose MFGPT driver, but
  * a simplified one designed specifically to act as a clock event source.
@@ -144,7 +144,7 @@
 
 	timer = cs5535_mfgpt_alloc_timer(MFGPT_TIMER_ANY, MFGPT_DOMAIN_WORKING);
 	if (!timer) {
-		printk(KERN_ERR DRV_NAME ": Could not allocate MFPGT timer\n");
+		printk(KERN_ERR DRV_NAME ": Could not allocate MFGPT timer\n");
 		return -ENODEV;
 	}
 	cs5535_event_clock = timer;
_
