Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752577Ab2FVEPJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 00:15:09 -0400
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:14089 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752102Ab2FVEPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 00:15:07 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApwEAO3w40+WZb0z/2dsb2JhbABFtmiCRlKBPgESiAq6R4s3hXkDnlKGW4JxgUQ
From: Steve Bennett <steveb@workware.net.au>
To: Eric Miao <eric.y.miao@gmail.com>, linux-arm-kernel@lists.infradead.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Steve Bennett <steveb@workware.net.au>
Subject: [PATCH] usb: gadget: pxa25x_udc: compile fix
Date: Fri, 22 Jun 2012 14:14:12 +1000
Message-Id: <1340338452-885-1-git-send-email-steveb@workware.net.au>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Steve Bennett <steveb@workware.net.au>
---
 drivers/usb/gadget/pxa25x_udc.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/pxa25x_udc.h b/drivers/usb/gadget/pxa25x_udc.h
index 861f4df..2eca1e7 100644
--- a/drivers/usb/gadget/pxa25x_udc.h
+++ b/drivers/usb/gadget/pxa25x_udc.h
@@ -225,7 +225,7 @@ dump_state(struct pxa25x_udc *dev)
 		dev->stats.read.bytes, dev->stats.read.ops);
 
 	for (i = 1; i < PXA_UDC_NUM_ENDPOINTS; i++) {
-		if (dev->ep [i].desc == NULL)
+		if (dev->ep[i].ep.desc == NULL)
 			continue;
 		DMSG ("udccs%d = %02x\n", i, *dev->ep->reg_udccs);
 	}
-- 
1.7.10

