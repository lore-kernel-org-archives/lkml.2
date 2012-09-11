Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757251Ab2IKPWA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 11:22:00 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:49803 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756384Ab2IKPV7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 11:21:59 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: <vinod.koul@linux.intel.com>
CC: <linux-arm-kernel@lists.infradead.org>, <plagnioj@jcrosoft.com>,
        <linux-kernel@vger.kernel.org>, <ludovic.desroches@atmel.com>,
        <nicolas.ferre@atmel.com>
Subject: [PATCH 1/2] dmaengine: at_hdmac: fix comment in atc_prep_slave_sg()
Date: Tue, 11 Sep 2012 17:21:44 +0200
Message-ID: <77b1e7252fbc9a31e1ed8806e017f8bd8a4605e0.1347375975.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.10
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

s/dma_memcpy/slave_sg/ and it is sg length that we are
talking about.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Stable <stable@vger.kernel.org> [2.6.31+]
---
 drivers/dma/at_hdmac.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/at_hdmac.c b/drivers/dma/at_hdmac.c
index 3934fcc..6c09e18 100644
--- a/drivers/dma/at_hdmac.c
+++ b/drivers/dma/at_hdmac.c
@@ -661,7 +661,7 @@ atc_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
 			flags);
 
 	if (unlikely(!atslave || !sg_len)) {
-		dev_dbg(chan2dev(chan), "prep_dma_memcpy: length is zero!\n");
+		dev_dbg(chan2dev(chan), "prep_slave_sg: sg length is zero!\n");
 		return NULL;
 	}
 
-- 
1.7.10

