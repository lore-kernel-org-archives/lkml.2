Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754370Ab2A0LIX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 06:08:23 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:63152 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752758Ab2A0LIW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 06:08:22 -0500
From: Tomoya MORINAGA <tomoya.rohm@gmail.com>
To: Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org
Cc: qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, Tomoya MORINAGA <tomoya.rohm@gmail.com>
Subject: [PATCH] gpio-ml-ioh: Change company name OKI SEMICONDUCTOR to LAPIS Semiconductor
Date: Fri, 27 Jan 2012 20:08:23 +0900
Message-Id: <1327662503-5603-1-git-send-email-tomoya.rohm@gmail.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On October 1 in 2011,
    OKI SEMICONDUCTOR Co., Ltd. changed the company name in to LAPIS Semiconductor Co., Ltd.

Signed-off-by: Tomoya MORINAGA <tomoya.rohm@gmail.com>
---
 drivers/gpio/Kconfig       |    4 ++--
 drivers/gpio/gpio-ml-ioh.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index d0c4118..bdb5161 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -402,12 +402,12 @@ config GPIO_PCH
 	  ML7223/ML7831 is completely compatible for Intel EG20T PCH.
 
 config GPIO_ML_IOH
-	tristate "OKI SEMICONDUCTOR ML7213 IOH GPIO support"
+	tristate "LAPIS SEMICONDUCTOR ML7213 IOH GPIO support"
 	depends on PCI
 	select GENERIC_IRQ_CHIP
 	help
 	  ML7213 is companion chip for Intel Atom E6xx series.
-	  This driver can be used for OKI SEMICONDUCTOR ML7213 IOH(Input/Output
+	  This driver can be used for LAPIS SEMICONDUCTOR ML7213 IOH(Input/Output
 	  Hub) which is for IVI(In-Vehicle Infotainment) use.
 	  This driver can access the IOH's GPIO device.
 
diff --git a/drivers/gpio/gpio-ml-ioh.c b/drivers/gpio/gpio-ml-ioh.c
index 03d6dd5..bf852a5 100644
--- a/drivers/gpio/gpio-ml-ioh.c
+++ b/drivers/gpio/gpio-ml-ioh.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (C) 2010 OKI SEMICONDUCTOR Co., LTD.
+ * Copyright (C) 2010 LAPIS SEMICONDUCTOR Co., LTD.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -622,5 +622,5 @@ static void __exit ioh_gpio_pci_exit(void)
 }
 module_exit(ioh_gpio_pci_exit);
 
-MODULE_DESCRIPTION("OKI SEMICONDUCTOR ML-IOH series GPIO Driver");
+MODULE_DESCRIPTION("LAPIS SEMICONDUCTOR ML-IOH series GPIO Driver");
 MODULE_LICENSE("GPL");
-- 
1.7.7.6

