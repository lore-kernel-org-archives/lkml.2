Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755827Ab1KQHOh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 02:14:37 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:49082 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754151Ab1KQHOg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 02:14:36 -0500
From: Tomoya MORINAGA <tomoya.rohm@gmail.com>
To: Dan Williams <dan.j.williams@intel.com>, Vinod Koul <vinod.koul@intel.com>,
        linux-kernel@vger.kernel.org
Cc: qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, Tomoya MORINAGA <tomoya.rohm@gmail.com>
Subject: [PATCH 1/2 v2] pch_dma: Change company name OKI SEMICONDUCTOR to LAPIS Semiconductor
Date: Thu, 17 Nov 2011 16:14:22 +0900
Message-Id: <1321514063-14064-1-git-send-email-tomoya.rohm@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On October 1 in 2011,
OKI SEMICONDUCTOR Co., Ltd. changed the company name in to LAPIS Semiconductor
Co., Ltd.

Signed-off-by: Tomoya MORINAGA <tomoya.rohm@gmail.com>
---
 drivers/dma/Kconfig   |    4 ++--
 drivers/dma/pch_dma.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
index ab8f469..495e841 100644
--- a/drivers/dma/Kconfig
+++ b/drivers/dma/Kconfig
@@ -201,13 +201,13 @@ config PL330_DMA
 	  platform_data for a dma-pl330 device.
 
 config PCH_DMA
-	tristate "Intel EG20T PCH / OKI Semi IOH(ML7213/ML7223) DMA support"
+	tristate "Intel EG20T PCH / LAPIS Semi IOH(ML7213/ML7223) DMA support"
 	depends on PCI && X86
 	select DMA_ENGINE
 	help
 	  Enable support for Intel EG20T PCH DMA engine.
 
-	  This driver also can be used for OKI SEMICONDUCTOR IOH(Input/
+	  This driver also can be used for LAPIS Semiconductor IOH(Input/
 	  Output Hub), ML7213 and ML7223.
 	  ML7213 IOH is for IVI(In-Vehicle Infotainment) use and ML7223 IOH is
 	  for MP(Media Phone) use.
diff --git a/drivers/dma/pch_dma.c b/drivers/dma/pch_dma.c
index a6d0e3d..a9b8a79 100644
--- a/drivers/dma/pch_dma.c
+++ b/drivers/dma/pch_dma.c
@@ -1,7 +1,7 @@
 /*
  * Topcliff PCH DMA controller driver
  * Copyright (c) 2010 Intel Corporation
- * Copyright (C) 2011 OKI SEMICONDUCTOR CO., LTD.
+ * Copyright (C) 2011 LAPIS Semiconductor Co., Ltd.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -1057,7 +1057,7 @@ static void __exit pch_dma_exit(void)
 module_init(pch_dma_init);
 module_exit(pch_dma_exit);
 
-MODULE_DESCRIPTION("Intel EG20T PCH / OKI SEMICONDUCTOR ML7213 IOH "
+MODULE_DESCRIPTION("Intel EG20T PCH / LAPIS Semiconductor ML7213/ML7223 IOH "
 		   "DMA controller driver");
 MODULE_AUTHOR("Yong Wang <yong.y.wang@intel.com>");
 MODULE_LICENSE("GPL v2");
-- 
1.7.4.4

