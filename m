Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753383Ab2HSLFT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2012 07:05:19 -0400
Received: from mail.work-microwave.de ([62.245.205.51]:43933 "EHLO
	work-microwave.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752273Ab2HSLFR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2012 07:05:17 -0400
From: Roland Stigge <stigge@antcom.de>
To: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, kevin.wells@nxp.com,
        srinivas.bakki@nxp.com, stern@rowland.harvard.edu,
        linux-arm-kernel@lists.infradead.org, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, bigeasy@linutronix.de, balbi@ti.com
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH] USB: isp1301: Remove unused static array and define
Date: Sun, 19 Aug 2012 13:04:29 +0200
Message-Id: <1345374269-5471-1-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 1.7.10.4
X-FEAS-SYSTEM-WL: rst@work-microwave.de, 192.168.11.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes an unused statically defined array and an associated #define.

Signed-off-by: Roland Stigge <stigge@antcom.de>

---
Applies to v3.6-rc2

 drivers/usb/phy/isp1301.c |    6 ------
 1 file changed, 6 deletions(-)

--- linux-2.6.orig/drivers/usb/phy/isp1301.c
+++ linux-2.6/drivers/usb/phy/isp1301.c
@@ -15,12 +15,6 @@
 
 #define DRV_NAME		"isp1301"
 
-#define ISP1301_I2C_ADDR	0x2C
-
-static const unsigned short normal_i2c[] = {
-	ISP1301_I2C_ADDR, ISP1301_I2C_ADDR + 1, I2C_CLIENT_END
-};
-
 static const struct i2c_device_id isp1301_id[] = {
 	{ "isp1301", 0 },
 	{ }
