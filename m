Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755104Ab2A0OBW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 09:01:22 -0500
Received: from i118-21-156-233.s30.a048.ap.plala.or.jp ([118.21.156.233]:53555
	"EHLO rinabert.homeip.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754979Ab2A0OBV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 09:01:21 -0500
From: Masanari Iida <standby24x7@gmail.com>
To: dan.j.williams@intel.com, linux-kernel@vger.kernel.org
Cc: trivial@kernel.org, standby24x7@gmail.com
Subject: [PATCH] [trivial] dma: Fix typo in iop-adma.c
Date: Fri, 27 Jan 2012 23:00:53 +0900
Message-Id: <1327672853-2058-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.7.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct spelling "allocted" to "allocated" in
drivers/dma/iop-adma.c

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 drivers/dma/iop-adma.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/dma/iop-adma.c b/drivers/dma/iop-adma.c
index 04be90b..faf88b7 100644
--- a/drivers/dma/iop-adma.c
+++ b/drivers/dma/iop-adma.c
@@ -1482,7 +1482,7 @@ static int __devinit iop_adma_probe(struct platform_device *pdev)
 		goto err_free_adev;
 	}
 
-	dev_dbg(&pdev->dev, "%s: allocted descriptor pool virt %p phys %p\n",
+	dev_dbg(&pdev->dev, "%s: allocated descriptor pool virt %p phys %p\n",
 		__func__, adev->dma_desc_pool_virt,
 		(void *) adev->dma_desc_pool);
 
-- 
1.7.6.5

