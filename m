Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756783Ab3AICcS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 21:32:18 -0500
Received: from mail-ye0-f178.google.com ([209.85.213.178]:34617 "EHLO
	mail-ye0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756086Ab3AICcQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 21:32:16 -0500
From: Fabio Estevam <festevam@gmail.com>
To: gregkh@linuxfoundation.org
Cc: s.hauer@pengutronix.de, p.zabel@pengutronix.de,
        linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH] staging: imx-drm: ipu-common: Remove unused variable
Date: Wed,  9 Jan 2013 00:32:02 -0200
Message-Id: <1357698722-7187-1-git-send-email-festevam@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabio Estevam <fabio.estevam@freescale.com>

Fix the following warning when building with W=1 option:

drivers/staging/imx-drm/ipu-v3/ipu-common.c: In function 'ipu_remove':
drivers/staging/imx-drm/ipu-v3/ipu-common.c:1145:19: warning: variable 'res' set but not used [-Wunused-but-set-variable]

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 drivers/staging/imx-drm/ipu-v3/ipu-common.c |    3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/staging/imx-drm/ipu-v3/ipu-common.c b/drivers/staging/imx-drm/ipu-v3/ipu-common.c
index f7059cd..366f259 100644
--- a/drivers/staging/imx-drm/ipu-v3/ipu-common.c
+++ b/drivers/staging/imx-drm/ipu-v3/ipu-common.c
@@ -1142,9 +1142,6 @@ failed_ioremap:
 static int ipu_remove(struct platform_device *pdev)
 {
 	struct ipu_soc *ipu = platform_get_drvdata(pdev);
-	struct resource *res;
-
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 
 	platform_device_unregister_children(pdev);
 	ipu_submodules_exit(ipu);
-- 
1.7.9.5

