Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756773Ab2HFRMk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 13:12:40 -0400
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:35833
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756570Ab2HFRMi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 13:12:38 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1202hzz8275bhz2dh2a8h668h839hd24he5bhf0ah107ah)
From: Fabio Estevam <fabio.estevam@freescale.com>
To: <thierry.reding@avionic-design.de>
CC: <shawn.guo@linaro.org>, <kernel@pengutronix.de>,
        <linux-kernel@vger.kernel.org>,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH 1/2] pwm: pwm-mxs: Provide information that driver is registered
Date: Mon, 6 Aug 2012 14:12:29 -0300
Message-ID: <1344273150-22927-1-git-send-email-fabio.estevam@freescale.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is useful to have a message indicating that the pwm driver has
been successfully registered.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 drivers/pwm/pwm-mxs.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/pwm/pwm-mxs.c b/drivers/pwm/pwm-mxs.c
index e585264..2873a21 100644
--- a/drivers/pwm/pwm-mxs.c
+++ b/drivers/pwm/pwm-mxs.c
@@ -171,6 +171,8 @@ static int mxs_pwm_probe(struct platform_device *pdev)
 
 	stmp_reset_block(mxs->base);
 
+	dev_info(&pdev->dev, "driver registered\n");
+
 	return 0;
 }
 
-- 
1.7.1


