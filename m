Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756001Ab2ENLBk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 07:01:40 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:37815 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755869Ab2ENLBf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 07:01:35 -0400
X-SpamScore: 3
X-BigFish: VS3(zzzz1202h1082kzz8275dhz2dh2a8h668h839hd24he5bh)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Dong Aisheng <b29396@freescale.com>
To: <linux-kernel@vger.kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linus.walleij@stericsson.com>,
        <swarren@wwwdotorg.org>, <haojian.zhuang@marvell.com>,
        <shawn.guo@freescale.com>
Subject: [PATCH 5/5] pinctrl: pinctrl-pxa3xx: remove empty pinmux disable function
Date: Mon, 14 May 2012 19:06:40 +0800
Message-ID: <1336993600-30065-5-git-send-email-b29396@freescale.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1336993600-30065-1-git-send-email-b29396@freescale.com>
References: <1336993600-30065-1-git-send-email-b29396@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dong Aisheng <dong.aisheng@linaro.org>

Signed-off-by: Dong Aisheng <dong.aisheng@linaro.org>
---
 drivers/pinctrl/pinctrl-pxa3xx.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-pxa3xx.c b/drivers/pinctrl/pinctrl-pxa3xx.c
index 7644e42..f14cd6b 100644
--- a/drivers/pinctrl/pinctrl-pxa3xx.c
+++ b/drivers/pinctrl/pinctrl-pxa3xx.c
@@ -138,11 +138,6 @@ static int pxa3xx_pmx_enable(struct pinctrl_dev *pctrldev, unsigned func,
 	return 0;
 }
 
-static void pxa3xx_pmx_disable(struct pinctrl_dev *pctrldev, unsigned func,
-			       unsigned group)
-{
-}
-
 static int pxa3xx_pmx_request_gpio(struct pinctrl_dev *pctrldev,
 				   struct pinctrl_gpio_range *range,
 				   unsigned pin)
@@ -170,7 +165,6 @@ static struct pinmux_ops pxa3xx_pmx_ops = {
 	.get_function_name	= pxa3xx_pmx_get_func_name,
 	.get_function_groups	= pxa3xx_pmx_get_groups,
 	.enable			= pxa3xx_pmx_enable,
-	.disable		= pxa3xx_pmx_disable,
 	.gpio_request_enable	= pxa3xx_pmx_request_gpio,
 };
 
-- 
1.7.0.4


