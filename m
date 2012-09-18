Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756071Ab2IRGxT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 02:53:19 -0400
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:24564
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752110Ab2IRGxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 02:53:18 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1202h1d1ah1d2ahzz8275bhz2dh2a8h668h839hd24he5bhf0ah107ah1288h12a5h12a9h12bdh12e5h1155h)
From: Richard Zhao <richard.zhao@freescale.com>
To: <linux-kernel@vger.kernel.org>
CC: <linus.walleij@linaro.org>, <dong.aisheng@linaro.org>,
        <shawn.guo@linaro.org>, Richard Zhao <richard.zhao@freescale.com>
Subject: [PATCH] pinctrl: imx: remove duplicated const
Date: Tue, 18 Sep 2012 14:54:00 +0800
Message-ID: <1347951240-11548-1-git-send-email-richard.zhao@freescale.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fix smatch warning:
drivers/pinctrl/pinctrl-imx.c:435:21: warning: duplicate const

Signed-off-by: Richard Zhao <richard.zhao@freescale.com>
---
 drivers/pinctrl/pinctrl-imx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/pinctrl-imx.c b/drivers/pinctrl/pinctrl-imx.c
index a13b888..b3c994a 100644
--- a/drivers/pinctrl/pinctrl-imx.c
+++ b/drivers/pinctrl/pinctrl-imx.c
@@ -432,7 +432,7 @@ static int __devinit imx_pinctrl_parse_groups(struct device_node *np,
 {
 	unsigned int pin_func_id;
 	int ret, size;
-	const const __be32 *list;
+	const __be32 *list;
 	int i, j;
 	u32 config;
 
-- 
1.7.9.5


