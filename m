Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755491Ab2FNKXJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 06:23:09 -0400
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:45134 "EHLO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755436Ab2FNKXG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 06:23:06 -0400
From: Felipe Balbi <balbi@ti.com>
To: ben-linux@fluff.org
Cc: Tony Lindgren <tony@atomide.com>, w.sang@pengutronix.de,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        linux-i2c@vger.kernel.org,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>
Subject: [PATCH 03/17] i2c: omap: add blank lines
Date: Thu, 14 Jun 2012 13:20:36 +0300
Message-Id: <1339669250-9183-4-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1339669250-9183-1-git-send-email-balbi@ti.com>
References: <1339669250-9183-1-git-send-email-balbi@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

trivial patch to aid readability. No functional
changes.

Signed-off-by: Felipe Balbi <balbi@ti.com>
---
 drivers/i2c/busses/i2c-omap.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/i2c/busses/i2c-omap.c b/drivers/i2c/busses/i2c-omap.c
index 39d5583..07ae391 100644
--- a/drivers/i2c/busses/i2c-omap.c
+++ b/drivers/i2c/busses/i2c-omap.c
@@ -829,6 +829,7 @@ complete:
 			dev_err(dev->dev, "Arbitration lost\n");
 			err |= OMAP_I2C_STAT_AL;
 		}
+
 		/*
 		 * ProDB0017052: Clear ARDY bit twice
 		 */
@@ -841,6 +842,7 @@ complete:
 			omap_i2c_complete_cmd(dev, err);
 			return IRQ_HANDLED;
 		}
+
 		if (stat & (OMAP_I2C_STAT_RRDY | OMAP_I2C_STAT_RDR)) {
 			u8 num_bytes = 1;
 
@@ -887,6 +889,7 @@ complete:
 				stat & (OMAP_I2C_STAT_RRDY | OMAP_I2C_STAT_RDR));
 			continue;
 		}
+
 		if (stat & (OMAP_I2C_STAT_XRDY | OMAP_I2C_STAT_XDR)) {
 			u8 num_bytes = 1;
 			if (dev->fifo_size) {
@@ -934,10 +937,12 @@ complete:
 				stat & (OMAP_I2C_STAT_XRDY | OMAP_I2C_STAT_XDR));
 			continue;
 		}
+
 		if (stat & OMAP_I2C_STAT_ROVR) {
 			dev_err(dev->dev, "Receive overrun\n");
 			dev->cmd_err |= OMAP_I2C_STAT_ROVR;
 		}
+
 		if (stat & OMAP_I2C_STAT_XUDF) {
 			dev_err(dev->dev, "Transmit underflow\n");
 			dev->cmd_err |= OMAP_I2C_STAT_XUDF;
-- 
1.7.10.4

