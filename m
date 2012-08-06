Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756717Ab2HFRMj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 13:12:39 -0400
Received: from co1ehsobe002.messaging.microsoft.com ([216.32.180.185]:18133
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756485Ab2HFRMi (ORCPT
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
Subject: [PATCH 2/2] pwm: pwm-imx: Provide information that driver is registered
Date: Mon, 6 Aug 2012 14:12:30 -0300
Message-ID: <1344273150-22927-2-git-send-email-fabio.estevam@freescale.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1344273150-22927-1-git-send-email-fabio.estevam@freescale.com>
References: <1344273150-22927-1-git-send-email-fabio.estevam@freescale.com>
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
 drivers/pwm/pwm-imx.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/pwm/pwm-imx.c b/drivers/pwm/pwm-imx.c
index 2a0b353..a112e9e 100644
--- a/drivers/pwm/pwm-imx.c
+++ b/drivers/pwm/pwm-imx.c
@@ -192,6 +192,8 @@ static int __devinit imx_pwm_probe(struct platform_device *pdev)
 		return ret;
 
 	platform_set_drvdata(pdev, imx);
+
+	dev_info(&pdev->dev, "driver registered\n");
 	return 0;
 }
 
-- 
1.7.1


