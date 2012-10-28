Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752802Ab2J1OOd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 10:14:33 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:34638 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751528Ab2J1OOb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 10:14:31 -0400
From: Dmitry Osipenko <digetx@gmail.com>
To: digetx@gmail.com
Cc: vinod.koul@intel.com, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] dma: tegra20-apbdma: trivial err message correction
Date: Sun, 28 Oct 2012 18:13:43 +0400
Message-Id: <1351433623-13975-1-git-send-email-digetx@gmail.com>
X-Mailer: git-send-email 1.7.12
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed err msg params order on irq request fail.

Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
---
 drivers/dma/tegra20-apb-dma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/tegra20-apb-dma.c b/drivers/dma/tegra20-apb-dma.c
index 528c62d..4d816be 100644
--- a/drivers/dma/tegra20-apb-dma.c
+++ b/drivers/dma/tegra20-apb-dma.c
@@ -1300,7 +1300,7 @@ static int __devinit tegra_dma_probe(struct platform_device *pdev)
 		if (ret) {
 			dev_err(&pdev->dev,
 				"request_irq failed with err %d channel %d\n",
-				i, ret);
+				ret, i);
 			goto err_irq;
 		}
 
-- 
1.7.12

