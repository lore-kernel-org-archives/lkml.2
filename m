Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752729Ab2GPI4K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 04:56:10 -0400
Received: from co1ehsobe004.messaging.microsoft.com ([216.32.180.187]:34950
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750754Ab2GPI4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 04:56:08 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1202hzz8275bhz2dh2a8h668h839hd24he5bhf0ah107ah)
From: Richard Zhao <richard.zhao@freescale.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
CC: <sameo@linux.intel.com>, <paulliu@debian.org>, <shawn.guo@linaro.org>,
        Richard Zhao <richard.zhao@freescale.com>
Subject: [PATCH] mfd: anatop: matches should be NULL when populate child devices
Date: Mon, 16 Jul 2012 16:55:57 +0800
Message-ID: <1342428957-14321-1-git-send-email-richard.zhao@freescale.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Richard Zhao <richard.zhao@freescale.com>
---
 drivers/mfd/anatop-mfd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/anatop-mfd.c b/drivers/mfd/anatop-mfd.c
index 6da0634..5576e07 100644
--- a/drivers/mfd/anatop-mfd.c
+++ b/drivers/mfd/anatop-mfd.c
@@ -83,7 +83,7 @@ static int __devinit of_anatop_probe(struct platform_device *pdev)
 	drvdata->ioreg = ioreg;
 	spin_lock_init(&drvdata->reglock);
 	platform_set_drvdata(pdev, drvdata);
-	of_platform_populate(np, of_anatop_match, NULL, dev);
+	of_platform_populate(np, NULL, NULL, dev);
 
 	return 0;
 }
-- 
1.7.9.5


