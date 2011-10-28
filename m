Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754134Ab1J1Akh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 20:40:37 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:40203 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753736Ab1J1Ak2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 20:40:28 -0400
From: Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>
To: Jean Delvare <khali@linux-fr.org>, Ben Dooks <ben-linux@fluff.org>,
        Wolfram Sang <w.sang@pengutronix.de>, Qi Wang <qi.wang@intel.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: yong.y.wang@intel.com, joel.clark@intel.com, kok.howg.ewe@intel.com,
        Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>
Subject: [PATCH 2/2] i2c-eg20t: Change-company-name-OKI-SEMICONDUCTOR to LAPIS Semiconductor
Date: Fri, 28 Oct 2011 09:40:11 +0900
Message-Id: <1319762411-7174-2-git-send-email-tomoya-linux@dsn.lapis-semi.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1319762411-7174-1-git-send-email-tomoya-linux@dsn.lapis-semi.com>
References: <1319762411-7174-1-git-send-email-tomoya-linux@dsn.lapis-semi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On October 1 in 2011,
OKI SEMICONDUCTOR Co., Ltd. changed the company name in to LAPIS Semiconductor Co., Ltd.

Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>
---
 drivers/i2c/busses/i2c-eg20t.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/i2c/busses/i2c-eg20t.c b/drivers/i2c/busses/i2c-eg20t.c
index 62135bc..e81e838 100644
--- a/drivers/i2c/busses/i2c-eg20t.c
+++ b/drivers/i2c/busses/i2c-eg20t.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (C) 2010 OKI SEMICONDUCTOR CO., LTD.
+ * Copyright (C) 2011 LAPIS Semiconductor Co., Ltd.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -135,8 +135,8 @@
 /*
 Set the number of I2C instance max
 Intel EG20T PCH :		1ch
-OKI SEMICONDUCTOR ML7213 IOH :	2ch
-OKI SEMICONDUCTOR ML7831 IOH :	1ch
+LAPIS Semiconductor ML7213 IOH :	2ch
+LAPIS Semiconductor ML7831 IOH :	1ch
 */
 #define PCH_I2C_MAX_DEV			2
 
@@ -180,7 +180,7 @@ static int pch_clk = 50000;	/* specifies I2C clock speed in KHz */
 static wait_queue_head_t pch_event;
 static DEFINE_MUTEX(pch_mutex);
 
-/* Definition for ML7213 by OKI SEMICONDUCTOR */
+/* Definition for ML7213 by LAPIS Semiconductor */
 #define PCI_VENDOR_ID_ROHM		0x10DB
 #define PCI_DEVICE_ID_ML7213_I2C	0x802D
 #define PCI_DEVICE_ID_ML7223_I2C	0x8010
@@ -937,8 +937,8 @@ static void __exit pch_pci_exit(void)
 }
 module_exit(pch_pci_exit);
 
-MODULE_DESCRIPTION("Intel EG20T PCH/OKI SEMICONDUCTOR ML7213 IOH I2C Driver");
+MODULE_DESCRIPTION("Intel EG20T PCH/LAPIS Semico ML7213/ML7223/ML7831 IOH I2C");
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Tomoya MORINAGA. <tomoya-linux@dsn.okisemi.com>");
+MODULE_AUTHOR("Tomoya MORINAGA. <tomoya-linux@dsn.lapis-semi.com>");
 module_param(pch_i2c_speed, int, (S_IRUSR | S_IWUSR));
 module_param(pch_clk, int, (S_IRUSR | S_IWUSR));
-- 
1.7.4.4

