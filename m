Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757864Ab1KVBMQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 20:12:16 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41047 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754943Ab1KVBLK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 20:11:10 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 4/7] pch_phub: Change company name OKI SEMICONDUCTOR to LAPIS Semiconductor
Date: Mon, 21 Nov 2011 17:10:31 -0800
Message-Id: <1321924234-26258-4-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1321924234-26258-1-git-send-email-gregkh@suse.de>
References: <20111122005836.GA25420@kroah.com>
 <1321924234-26258-1-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>

On October 1 in 2011,
OKI SEMICONDUCTOR Co., Ltd. changed the company name in to LAPIS Semiconductor Co., Ltd.

Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
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
1.7.7.3

