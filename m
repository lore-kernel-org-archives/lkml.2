Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752841Ab1HIOfS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 10:35:18 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:36537 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752641Ab1HIOfQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 10:35:16 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] mfd: Remove spurious newlines from wm831x-irq.c
Date: Tue,  9 Aug 2011 14:05:29 +0900
Message-Id: <1312866329-15601-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

More annoying than usual as they're in the middle of a function.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm831x-irq.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/wm831x-irq.c b/drivers/mfd/wm831x-irq.c
index ada1835..a10937c 100644
--- a/drivers/mfd/wm831x-irq.c
+++ b/drivers/mfd/wm831x-irq.c
@@ -596,8 +596,6 @@ int wm831x_irq_init(struct wm831x *wm831x, int irq)
 			 "No interrupt specified - functionality limited\n");
 	}
 
-
-
 	/* Enable top level interrupts, we mask at secondary level */
 	wm831x_reg_write(wm831x, WM831X_SYSTEM_INTERRUPTS_MASK, 0);
 
-- 
1.7.5.4

