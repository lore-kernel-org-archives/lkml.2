Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755320Ab3ADRTm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 12:19:42 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:34125 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755222Ab3ADRTW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 12:19:22 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org
Cc: patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 3/4] mfd: wm5110: Mark wakes as inverted
Date: Fri,  4 Jan 2013 17:19:16 +0000
Message-Id: <1357319957-11480-3-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1357319957-11480-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1357319957-11480-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---

Seems sensible to merge this via regmap given that it uses the new
feature?

 drivers/mfd/wm5110-tables.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mfd/wm5110-tables.c b/drivers/mfd/wm5110-tables.c
index 59614d0..d0fb5b4 100644
--- a/drivers/mfd/wm5110-tables.c
+++ b/drivers/mfd/wm5110-tables.c
@@ -255,6 +255,7 @@ const struct regmap_irq_chip wm5110_aod = {
 	.mask_base = ARIZONA_AOD_IRQ_MASK_IRQ1,
 	.ack_base = ARIZONA_AOD_IRQ1,
 	.wake_base = ARIZONA_WAKE_CONTROL,
+	.wake_invert = 1,
 	.num_regs = 1,
 	.irqs = wm5110_aod_irqs,
 	.num_irqs = ARRAY_SIZE(wm5110_aod_irqs),
-- 
1.7.10.4

