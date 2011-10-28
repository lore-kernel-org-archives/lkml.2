Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753568Ab1J1Afm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 20:35:42 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:1265 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752756Ab1J1Afa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 20:35:30 -0400
From: Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>
To: Grant Likely <grant.likely@secretlab.ca>,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Cc: qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com,
        Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>
Subject: [PATCH 2/2] spi-topcliff-pch: Change company name OKI SEMICONDUCTOR to LAPIS Semiconductor
Date: Fri, 28 Oct 2011 09:35:22 +0900
Message-Id: <1319762122-7019-2-git-send-email-tomoya-linux@dsn.lapis-semi.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1319762122-7019-1-git-send-email-tomoya-linux@dsn.lapis-semi.com>
References: <1319762122-7019-1-git-send-email-tomoya-linux@dsn.lapis-semi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On October 1 in 2011,
OKI SEMICONDUCTOR Co., Ltd. changed the company name in to LAPIS Semiconductor Co., Ltd.

Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>
---
 drivers/spi/spi-topcliff-pch.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/spi/spi-topcliff-pch.c b/drivers/spi/spi-topcliff-pch.c
index 2b1e966..7086583 100644
--- a/drivers/spi/spi-topcliff-pch.c
+++ b/drivers/spi/spi-topcliff-pch.c
@@ -1,7 +1,7 @@
 /*
  * SPI bus driver for the Topcliff PCH used by Intel SoCs
  *
- * Copyright (C) 2010 OKI SEMICONDUCTOR Co., LTD.
+ * Copyright (C) 2011 LAPIS Semiconductor Co., Ltd.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -95,7 +95,7 @@
 #define PCH_CLOCK_HZ		50000000
 #define PCH_MAX_SPBR		1023
 
-/* Definition for ML7213/ML7831 by OKI SEMICONDUCTOR */
+/* Definition for ML7213/ML7223/ML7831 by LAPIS Semiconductor */
 #define PCI_VENDOR_ID_ROHM		0x10DB
 #define PCI_DEVICE_ID_ML7213_SPI	0x802c
 #define PCI_DEVICE_ID_ML7223_SPI	0x800F
@@ -104,9 +104,9 @@
 /*
  * Set the number of SPI instance max
  * Intel EG20T PCH :		1ch
- * OKI SEMICONDUCTOR ML7213 IOH :	2ch
- * OKI SEMICONDUCTOR ML7223 IOH :	1ch
- * OKI SEMICONDUCTOR ML7831 IOH :	1ch
+ * LAPIS Semiconductor ML7213 IOH :	2ch
+ * LAPIS Semiconductor ML7223 IOH :	1ch
+ * LAPIS Semiconductor ML7831 IOH :	1ch
 */
 #define PCH_SPI_MAX_DEV			2
 
@@ -1756,4 +1756,4 @@ MODULE_PARM_DESC(use_dma,
 		 "to use DMA for data transfers pass 1 else 0; default 1");
 
 MODULE_LICENSE("GPL");
-MODULE_DESCRIPTION("Intel EG20T PCH/OKI SEMICONDUCTOR ML7xxx IOH SPI Driver");
+MODULE_DESCRIPTION("Intel EG20T PCH/LAPIS Semiconductor ML7xxx IOH SPI Driver");
-- 
1.7.4.4

