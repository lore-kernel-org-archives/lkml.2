Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754608Ab2KMIbO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 03:31:14 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:60110 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932087Ab2KMI3N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 03:29:13 -0500
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Samuel Ortiz <sameo@linux.intel.com>
CC: Tero Kristo <t-kristo@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 12/13] mfd: twl4030-irq: Change TWL4030_MODULE_* ids to TWL_MODULE_*
Date: Tue, 13 Nov 2012 09:28:53 +0100
Message-ID: <1352795334-7406-13-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1352795334-7406-1-git-send-email-peter.ujfalusi@ti.com>
References: <1352795334-7406-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To facilitate upcoming cleanup in twl stack.
No functional changes.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 drivers/mfd/twl4030-irq.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/twl4030-irq.c b/drivers/mfd/twl4030-irq.c
index e900402..518da0c 100644
--- a/drivers/mfd/twl4030-irq.c
+++ b/drivers/mfd/twl4030-irq.c
@@ -295,8 +295,8 @@ static irqreturn_t handle_twl4030_pih(int irq, void *devid)
 	irqreturn_t	ret;
 	u8		pih_isr;
 
-	ret = twl_i2c_read_u8(TWL4030_MODULE_PIH, &pih_isr,
-			REG_PIH_ISR_P1);
+	ret = twl_i2c_read_u8(TWL_MODULE_PIH, &pih_isr,
+			      REG_PIH_ISR_P1);
 	if (ret) {
 		pr_warning("twl4030: I2C error %d reading PIH ISR\n", ret);
 		return IRQ_NONE;
-- 
1.8.0

