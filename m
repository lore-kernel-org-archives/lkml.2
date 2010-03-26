Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753503Ab0CZOrJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 10:47:09 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47255 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751408Ab0CZOrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 10:47:08 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] mfd: Remove unused wm831x IRQ handler data
Date: Fri, 26 Mar 2010 14:47:04 +0000
Message-Id: <1269614824-29056-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This was used by the old, pre-genirq IRQ implementation but is no
longer required.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm831x-irq.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/wm831x-irq.c b/drivers/mfd/wm831x-irq.c
index 3013276..b1d66b8 100644
--- a/drivers/mfd/wm831x-irq.c
+++ b/drivers/mfd/wm831x-irq.c
@@ -38,8 +38,6 @@ struct wm831x_irq_data {
 	int primary;
 	int reg;
 	int mask;
-	irq_handler_t handler;
-	void *handler_data;
 };
 
 static struct wm831x_irq_data wm831x_irqs[] = {
-- 
1.7.0.2

