Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754875Ab1BMUFx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Feb 2011 15:05:53 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55798 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754836Ab1BMUFr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Feb 2011 15:05:47 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] mfd: Remove bitrotted genirq comment from wm831x IRQ code
Date: Sun, 13 Feb 2011 20:06:06 +0000
Message-Id: <1297627566-16844-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm831x-irq.c |    9 ---------
 1 files changed, 0 insertions(+), 9 deletions(-)

diff --git a/drivers/mfd/wm831x-irq.c b/drivers/mfd/wm831x-irq.c
index 03eb61d..2e45f60 100644
--- a/drivers/mfd/wm831x-irq.c
+++ b/drivers/mfd/wm831x-irq.c
@@ -26,15 +26,6 @@
 
 #include <linux/delay.h>
 
-/*
- * Since generic IRQs don't currently support interrupt controllers on
- * interrupt driven buses we don't use genirq but instead provide an
- * interface that looks very much like the standard ones.  This leads
- * to some bodges, including storing interrupt handler information in
- * the static irq_data table we use to look up the data for individual
- * interrupts, but hopefully won't last too long.
- */
-
 struct wm831x_irq_data {
 	int primary;
 	int reg;
-- 
1.7.2.3

