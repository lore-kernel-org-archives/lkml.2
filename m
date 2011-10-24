Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932552Ab1JXNKO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 09:10:14 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58916 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932369Ab1JXNKN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 09:10:13 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] mfd: Remove unused wm831x_irq_data_to_mask_reg()
Date: Mon, 24 Oct 2011 15:10:10 +0200
Message-Id: <1319461810-16592-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm831x-irq.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/drivers/mfd/wm831x-irq.c b/drivers/mfd/wm831x-irq.c
index f4747a4..7be5f09 100644
--- a/drivers/mfd/wm831x-irq.c
+++ b/drivers/mfd/wm831x-irq.c
@@ -325,11 +325,6 @@ static inline int irq_data_to_status_reg(struct wm831x_irq_data *irq_data)
 	return WM831X_INTERRUPT_STATUS_1 - 1 + irq_data->reg;
 }
 
-static inline int irq_data_to_mask_reg(struct wm831x_irq_data *irq_data)
-{
-	return WM831X_INTERRUPT_STATUS_1_MASK - 1 + irq_data->reg;
-}
-
 static inline struct wm831x_irq_data *irq_to_wm831x_irq(struct wm831x *wm831x,
 							int irq)
 {
-- 
1.7.6.3

