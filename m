Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755936Ab1LNIqQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 03:46:16 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:36963 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753420Ab1LNIqP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 03:46:15 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] mfd: Remove unused wm831x_irq_data_to_mask_reg()
Date: Wed, 14 Dec 2011 16:46:09 +0800
Message-Id: <1323852369-7900-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.7.3
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
1.7.7.3

