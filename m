Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753045Ab2HAInB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 04:43:01 -0400
Received: from mail.lippert-at.com ([62.80.22.186]:27331 "EHLO
	domex.lippertembedded.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752815Ab2HAIm4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 04:42:56 -0400
Message-ID: <5018E919.7010303@LiPPERTEmbedded.de>
Date: Wed, 01 Aug 2012 10:30:17 +0200
From: Jens Rottmann <JRottmann@LiPPERTEmbedded.de>
User-Agent: Thunderbird 1.5.0.14 (Windows/20071210)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: John Stultz <johnstul@us.ibm.com>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 2nd resend] cs5535-clockevt: typo, it's MFGPT, not MFPGT
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 01 Aug 2012 08:42:53.0419 (UTC) FILETIME=[A3FC13B0:01CD6FC1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cs5535-clockevt: typo, it's MFGPT, not MFPGT

Had me fooled for a while, "dmesg|grep -i mfgpt" wouldn't show anything.

Signed-off-by: Jens Rottmann <JRottmann@LiPPERTEmbedded.de>
---

Hi Thomas,

I know this is not the most important fix in the world, but the nice
thing about open source is that you can scatch your itches ...

Got no response, therefore rescratching.  :-)

Thanks,
Jens

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


