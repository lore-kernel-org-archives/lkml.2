Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759727Ab2IEWCE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 18:02:04 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:51048 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759693Ab2IEWBi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 18:01:38 -0400
From: Fabio Estevam <festevam@gmail.com>
To: zbr@ioremap.net
Cc: s.hauer@pengutronix.de, linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH 2/3] w1: mxc_w1: Fix comment
Date: Wed,  5 Sep 2012 19:01:19 -0300
Message-Id: <1346882480-18254-2-git-send-email-festevam@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1346882480-18254-1-git-send-email-festevam@gmail.com>
References: <1346882480-18254-1-git-send-email-festevam@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabio Estevam <fabio.estevam@freescale.com>

We are dealing with mxc_w1 registers.

While at it use dev_err() instead.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 drivers/w1/masters/mxc_w1.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/w1/masters/mxc_w1.c b/drivers/w1/masters/mxc_w1.c
index 14f0f66..25b234c 100644
--- a/drivers/w1/masters/mxc_w1.c
+++ b/drivers/w1/masters/mxc_w1.c
@@ -134,7 +134,7 @@ static int __devinit mxc_w1_probe(struct platform_device *pdev)
 
 	mdev->regs = ioremap(res->start, resource_size(res));
 	if (!mdev->regs) {
-		printk(KERN_ERR "Cannot map frame buffer registers\n");
+		dev_err(&pdev->dev, "Cannot map mxc_w1 registers\n");
 		goto failed_ioremap;
 	}
 
-- 
1.7.9.5

