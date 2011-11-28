Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754943Ab1K1WpB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 17:45:01 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60965 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753945Ab1K1Wo7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 17:44:59 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 1/8] mfd: Remove some unused functions in wm8894-irq
Date: Mon, 28 Nov 2011 22:44:27 +0000
Message-Id: <1322520274-13789-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <20111128224017.GA13163@opensource.wolfsonmicro.com>
References: <20111128224017.GA13163@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm8994-irq.c |   10 ----------
 1 files changed, 0 insertions(+), 10 deletions(-)

diff --git a/drivers/mfd/wm8994-irq.c b/drivers/mfd/wm8994-irq.c
index d682f7b..f9dd6b6 100644
--- a/drivers/mfd/wm8994-irq.c
+++ b/drivers/mfd/wm8994-irq.c
@@ -140,16 +140,6 @@ static struct wm8994_irq_data wm8994_irqs[] = {
 	},
 };
 
-static inline int irq_data_to_status_reg(struct wm8994_irq_data *irq_data)
-{
-	return WM8994_INTERRUPT_STATUS_1 - 1 + irq_data->reg;
-}
-
-static inline int irq_data_to_mask_reg(struct wm8994_irq_data *irq_data)
-{
-	return WM8994_INTERRUPT_STATUS_1_MASK - 1 + irq_data->reg;
-}
-
 static inline struct wm8994_irq_data *irq_to_wm8994_irq(struct wm8994 *wm8994,
 							int irq)
 {
-- 
1.7.7.3

