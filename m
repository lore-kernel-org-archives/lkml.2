Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752421Ab2KSMUA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 07:20:00 -0500
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:34332 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752272Ab2KSMT5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 07:19:57 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1de0h1202h1d1ah1d2ahzz8275bhz2dh2a8h668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1155h)
From: Fabio Estevam <fabio.estevam@freescale.com>
To: <gregkh@linuxfoundation.org>
CC: <kernel@pengutronix.de>, <zbr@ioremap.net>, <linux-kernel@vger.kernel.org>,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH v3 2/3] w1: mxc_w1: Fix comment
Date: Mon, 19 Nov 2012 10:19:47 -0200
Message-ID: <1353327588-2797-2-git-send-email-fabio.estevam@freescale.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353327588-2797-1-git-send-email-fabio.estevam@freescale.com>
References: <1353327588-2797-1-git-send-email-fabio.estevam@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are dealing with mxc_w1 registers.

While at it use dev_err() instead.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
Changes since v2:
- No changes
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


