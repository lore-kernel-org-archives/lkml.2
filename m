Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758231Ab1KVK4Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 05:56:16 -0500
Received: from newsmtp5.atmel.com ([204.2.163.5]:24028 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754654Ab1KVK4K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 05:56:10 -0500
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: vinod.koul@intel.com, linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, grant.likely@secretlab.ca,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH 2/3] dmaengine: at_hdmac: empty entry shape modification
Date: Tue, 22 Nov 2011 11:55:53 +0100
Message-Id: <ead9d5af63c24616a9e88fce3ca72860207477ca.1321959137.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <25000153a64c2845223be78ee55e01e034613601.1321959137.git.nicolas.ferre@atmel.com>
References: <25000153a64c2845223be78ee55e01e034613601.1321959137.git.nicolas.ferre@atmel.com>
In-Reply-To: <25000153a64c2845223be78ee55e01e034613601.1321959137.git.nicolas.ferre@atmel.com>
References: <25000153a64c2845223be78ee55e01e034613601.1321959137.git.nicolas.ferre@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trivial form modification to unify structure look.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 drivers/dma/at_hdmac.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/dma/at_hdmac.c b/drivers/dma/at_hdmac.c
index 3b44f24..30ec030 100644
--- a/drivers/dma/at_hdmac.c
+++ b/drivers/dma/at_hdmac.c
@@ -1185,7 +1185,9 @@ static const struct of_device_id atmel_dma_dt_ids[] = {
 	}, {
 		.compatible = "atmel,at91sam9g45-dma",
 		.data = (void *)ATDMA_DEVTYPE_SAM9G45
-	}, { /* sentinel */ }
+	}, {
+		/* sentinel */
+	}
 };
 
 MODULE_DEVICE_TABLE(of, atmel_dma_dt_ids);
-- 
1.7.5.4

