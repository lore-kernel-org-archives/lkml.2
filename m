Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753814Ab1HHMui (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 08:50:38 -0400
Received: from mail.karo-electronics.de ([81.173.242.67]:64048 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753763Ab1HHMug (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 08:50:36 -0400
From: =?utf-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
To: Vinod Koul <vinod.koul@intel.com>, Dan Williams <dan.j.williams@intel.com>,
        linux-kernel@vger.kernel.org, shawn.guo@freescale.com,
        u.kleine-koenig@pengutronix.de
Cc: =?utf-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
Subject: [RESEND][PATCH 1/2] mxs-dma: Add missing end of list marker for platform_id table
Date: Mon,  8 Aug 2011 14:47:46 +0200
Message-Id: <1312807667-24373-2-git-send-email-LW@KARO-electronics.de>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1312807667-24373-1-git-send-email-LW@KARO-electronics.de>
References: <dc6791e4e926902967a182107d4558d5e0a16381.1303373126.git.LW@KARO-electronics.de>
 <1312807667-24373-1-git-send-email-LW@KARO-electronics.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Lothar Waßmann <LW@KARO-electronics.de>
---
 drivers/dma/mxs-dma.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/dma/mxs-dma.c b/drivers/dma/mxs-dma.c
index 88aad4f..f2ddcbd 100644
--- a/drivers/dma/mxs-dma.c
+++ b/drivers/dma/mxs-dma.c
@@ -707,7 +707,8 @@ static struct platform_device_id mxs_dma_type[] = {
 	}, {
 		.name = "mxs-dma-apbx",
 		.driver_data = MXS_DMA_APBX,
-	}
+	},
+	{ /* end of list marker */ }
 };
 
 static struct platform_driver mxs_dma_driver = {
-- 
1.5.6.5

