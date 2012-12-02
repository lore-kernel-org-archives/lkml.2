Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753621Ab2LBPQn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2012 10:16:43 -0500
Received: from mail-ia0-f180.google.com ([209.85.210.180]:50654 "EHLO
	mail-ia0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484Ab2LBPQm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2012 10:16:42 -0500
X-Greylist: delayed 497 seconds by postgrey-1.27 at vger.kernel.org; Sun, 02 Dec 2012 10:16:42 EST
Message-ID: <1354460899.3241.2.camel@phoenix>
Subject: [PATCH] clocksource: sunxi_timer: Add terminating entry for
 sunxi_timer_dt_ids
From: Axel Lin <axel.lin@ingics.com>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, John Stultz <johnstul@us.ibm.com>,
        linux-kernel@vger.kernel.org
Date: Sun, 02 Dec 2012 23:08:19 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The of_device_id table is supposed to be zero-terminated.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/clocksource/sunxi_timer.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clocksource/sunxi_timer.c b/drivers/clocksource/sunxi_timer.c
index 3c46434..3cd1bd3 100644
--- a/drivers/clocksource/sunxi_timer.c
+++ b/drivers/clocksource/sunxi_timer.c
@@ -101,6 +101,7 @@ static struct irqaction sunxi_timer_irq = {
 
 static struct of_device_id sunxi_timer_dt_ids[] = {
 	{ .compatible = "allwinner,sunxi-timer" },
+	{ }
 };
 
 static void __init sunxi_timer_init(void)
-- 
1.7.9.5



