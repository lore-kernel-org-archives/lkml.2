Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752403Ab2LPUzu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2012 15:55:50 -0500
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:6675 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983Ab2LPUzt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2012 15:55:49 -0500
Date: Sun, 16 Dec 2012 21:55:40 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Alessandro Zummo <a.zummo@towertech.it>
Cc: Sascha Hauer <s.hauer@pengutronix.de>, rtc-linux@googlegroups.com,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] rtc: imx dryice: Must include <linux/spinlock.h>
Message-ID: <20121216215540.2b7abe15@endymion.delvare>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the missing header include for spinlocks, to avoid potential build
failures on specific architectures or configurations.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Acked-by: Sascha Hauer <s.hauer@pengutronix.de>
---
 drivers/rtc/rtc-imxdi.c |    1 +
 1 file changed, 1 insertion(+)

--- linux-3.8-rc0.orig/drivers/rtc/rtc-imxdi.c	2012-12-16 21:23:57.415274494 +0100
+++ linux-3.8-rc0/drivers/rtc/rtc-imxdi.c	2012-12-16 21:50:48.324778700 +0100
@@ -36,6 +36,7 @@
 #include <linux/platform_device.h>
 #include <linux/rtc.h>
 #include <linux/sched.h>
+#include <linux/spinlock.h>
 #include <linux/workqueue.h>
 
 /* DryIce Register Definitions */

-- 
Jean Delvare
