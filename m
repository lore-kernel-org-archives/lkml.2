Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752927Ab2A2M7j (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jan 2012 07:59:39 -0500
Received: from i118-21-156-233.s30.a048.ap.plala.or.jp ([118.21.156.233]:35601
	"EHLO rinabert.homeip.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752646Ab2A2M7i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jan 2012 07:59:38 -0500
From: Masanari Iida <standby24x7@gmail.com>
To: ben-linux@fluff.org
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org, standby24x7@gmail.com
Subject: [PATCH] [trivial] mmc: Fix typo in s3cmci.c
Date: Sun, 29 Jan 2012 21:58:57 +0900
Message-Id: <1327841937-1808-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.7.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct typo "resouce" to "resource" in
drivers/mmc/host/s3cmci.c

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 drivers/mmc/host/s3cmci.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mmc/host/s3cmci.c b/drivers/mmc/host/s3cmci.c
index 1bcfd6d..c3622a6 100644
--- a/drivers/mmc/host/s3cmci.c
+++ b/drivers/mmc/host/s3cmci.c
@@ -1606,7 +1606,7 @@ static int __devinit s3cmci_probe(struct platform_device *pdev)
 	host->mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!host->mem) {
 		dev_err(&pdev->dev,
-			"failed to get io memory region resouce.\n");
+			"failed to get io memory region resource.\n");
 
 		ret = -ENOENT;
 		goto probe_free_gpio;
@@ -1630,7 +1630,7 @@ static int __devinit s3cmci_probe(struct platform_device *pdev)
 
 	host->irq = platform_get_irq(pdev, 0);
 	if (host->irq == 0) {
-		dev_err(&pdev->dev, "failed to get interrupt resouce.\n");
+		dev_err(&pdev->dev, "failed to get interrupt resource.\n");
 		ret = -EINVAL;
 		goto probe_iounmap;
 	}
-- 
1.7.6.5

