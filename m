Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753108Ab1GLKyD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 06:54:03 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:47999 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753063Ab1GLKyB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 06:54:01 -0400
Subject: [PATCH] dma: mxs-dma: fix unterminated platform_device_id table
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Shawn Guo <shawn.guo@freescale.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 12 Jul 2011 18:53:52 +0800
Message-ID: <1310468032.6590.1.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/dma/mxs-dma.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/dma/mxs-dma.c b/drivers/dma/mxs-dma.c
index 88aad4f..72a2896 100644
--- a/drivers/dma/mxs-dma.c
+++ b/drivers/dma/mxs-dma.c
@@ -707,6 +707,8 @@ static struct platform_device_id mxs_dma_type[] = {
 	}, {
 		.name = "mxs-dma-apbx",
 		.driver_data = MXS_DMA_APBX,
+	}, {
+		/* end of list */
 	}
 };
 
-- 
1.7.4.1



