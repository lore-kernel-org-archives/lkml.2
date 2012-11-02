Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762439Ab2KBNqc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 09:46:32 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:46692 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756105Ab2KBNqb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 09:46:31 -0400
Message-ID: <1351863973.2970.1.camel@phoenix>
Subject: [PATCH] pinctrl: exynos: Add terminating entry for of_device_id
 table
From: Axel Lin <axel.lin@ingics.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Tomasz Figa <t.figa@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        linux-kernel@vger.kernel.org
Date: Fri, 02 Nov 2012 21:46:13 +0800
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
 drivers/pinctrl/pinctrl-exynos.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pinctrl/pinctrl-exynos.c b/drivers/pinctrl/pinctrl-exynos.c
index 73a0aa2..b023254 100644
--- a/drivers/pinctrl/pinctrl-exynos.c
+++ b/drivers/pinctrl/pinctrl-exynos.c
@@ -36,6 +36,7 @@
 /* list of external wakeup controllers supported */
 static const struct of_device_id exynos_wkup_irq_ids[] = {
 	{ .compatible = "samsung,exynos4210-wakeup-eint", },
+	{ }
 };
 
 static void exynos_gpio_irq_unmask(struct irq_data *irqd)
-- 
1.7.9.5



