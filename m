Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752090Ab2LBOki (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2012 09:40:38 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:34081 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301Ab2LBOkh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2012 09:40:37 -0500
Message-ID: <1354459224.3241.1.camel@phoenix>
Subject: [PATCH] irqchip: irq-sunxi: Add terminating entry for
 sunxi_irq_dt_ids
From: Axel Lin <axel.lin@ingics.com>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Date: Sun, 02 Dec 2012 22:40:24 +0800
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
 drivers/irqchip/irq-sunxi.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/irqchip/irq-sunxi.c b/drivers/irqchip/irq-sunxi.c
index eef41a4..10974fa 100644
--- a/drivers/irqchip/irq-sunxi.c
+++ b/drivers/irqchip/irq-sunxi.c
@@ -129,7 +129,8 @@ static int __init sunxi_of_init(struct device_node *node,
 }
 
 static struct of_device_id sunxi_irq_dt_ids[] __initconst = {
-	{ .compatible = "allwinner,sunxi-ic", .data = sunxi_of_init }
+	{ .compatible = "allwinner,sunxi-ic", .data = sunxi_of_init },
+	{ }
 };
 
 void __init sunxi_init_irq(void)
-- 
1.7.9.5



