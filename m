Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753421Ab1J1Ada (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 20:33:30 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:1098 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751619Ab1J1Ad2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 20:33:28 -0400
From: Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>
To: linux-kernel@vger.kernel.org, alan@lxorguk.ukuu.org.uk, gregkh@suse.de
Cc: qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com,
        Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>
Subject: [PATCH 2/2] pch_phub: Change company name OKI SEMICONDUCTOR to LAPIS Semiconductor
Date: Fri, 28 Oct 2011 09:33:14 +0900
Message-Id: <1319761994-6950-2-git-send-email-tomoya-linux@dsn.lapis-semi.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1319761994-6950-1-git-send-email-tomoya-linux@dsn.lapis-semi.com>
References: <1319761994-6950-1-git-send-email-tomoya-linux@dsn.lapis-semi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On October 1 in 2011,
OKI SEMICONDUCTOR Co., Ltd. changed the company name in to LAPIS Semiconductor Co., Ltd.

Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>
---
 drivers/misc/pch_phub.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/misc/pch_phub.c b/drivers/misc/pch_phub.c
index b50f48a..e7c5995 100644
--- a/drivers/misc/pch_phub.c
+++ b/drivers/misc/pch_phub.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (C) 2010 OKI SEMICONDUCTOR CO., LTD.
+ * Copyright (C) 2011 LAPIS Semiconductor Co., Ltd.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -41,10 +41,10 @@
 #define PCH_PHUB_ROM_START_ADDR_EG20T 0x80 /* ROM data area start address offset
 					      (Intel EG20T PCH)*/
 #define PCH_PHUB_ROM_START_ADDR_ML7213 0x400 /* ROM data area start address
-						offset(OKI SEMICONDUCTOR ML7213)
+						offset(LAPIS Semicon ML7213)
 					      */
 #define PCH_PHUB_ROM_START_ADDR_ML7223 0x400 /* ROM data area start address
-						offset(OKI SEMICONDUCTOR ML7223)
+						offset(LAPIS Semicon ML7223)
 					      */
 
 /* MAX number of INT_REDUCE_CONTROL registers */
@@ -893,5 +893,5 @@ static void __exit pch_phub_pci_exit(void)
 module_init(pch_phub_pci_init);
 module_exit(pch_phub_pci_exit);
 
-MODULE_DESCRIPTION("Intel EG20T PCH/OKI SEMICONDUCTOR IOH(ML7213/ML7223) PHUB");
+MODULE_DESCRIPTION("Intel EG20T PCH/LAPIS Semiconductor IOH(ML7213/ML7223) PHUB");
 MODULE_LICENSE("GPL");
-- 
1.7.4.4

