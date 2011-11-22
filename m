Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754219Ab1KVHGq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 02:06:46 -0500
Received: from denmail01-v4020.amcc.com ([192.195.68.30]:33264 "EHLO
	denmail01.apm.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751302Ab1KVHGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 02:06:45 -0500
X-Greylist: delayed 2694 seconds by postgrey-1.27 at vger.kernel.org; Tue, 22 Nov 2011 02:06:45 EST
From: Tanmay Inamdar <tinamdar@apm.com>
To: dwmw2@infradead.org
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        Tanmay Inamdar <tinamdar@apm.com>
Subject: [PATCH 1/2] MTD: NAND: ndfc: fix compilation error
Date: Tue, 22 Nov 2011 11:50:50 +0530
Message-Id: <1321942850-20012-1-git-send-email-tinamdar@apm.com>
X-Mailer: git-send-email 1.6.1.rc3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes compilation error in ndfc flash driver
---
 drivers/mtd/nand/ndfc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mtd/nand/ndfc.c b/drivers/mtd/nand/ndfc.c
index ee17139..f8aacf4 100644
--- a/drivers/mtd/nand/ndfc.c
+++ b/drivers/mtd/nand/ndfc.c
@@ -188,7 +188,7 @@ static int ndfc_chip_init(struct ndfc_controller *ndfc,
 	if (!flash_np)
 		return -ENODEV;
 
-	ppdata->of_node = flash_np;
+	ppdata.of_node = flash_np;
 	ndfc->mtd.name = kasprintf(GFP_KERNEL, "%s.%s",
 			dev_name(&ndfc->ofdev->dev), flash_np->name);
 	if (!ndfc->mtd.name) {
-- 
1.6.1.rc3

