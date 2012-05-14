Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756049Ab2ENLCO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 07:02:14 -0400
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:27961
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755200Ab2ENLBa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 07:01:30 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 3
X-BigFish: VS3(zzzz1202h1082kzz8275dhz2dh2a8h668h839hd24he5bh)
From: Dong Aisheng <b29396@freescale.com>
To: <linux-kernel@vger.kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linus.walleij@stericsson.com>,
        <swarren@wwwdotorg.org>, <haojian.zhuang@marvell.com>,
        <shawn.guo@freescale.com>
Subject: [PATCH 3/5] pinctrl: pinctrl-imx: remove empty pinmux disable function
Date: Mon, 14 May 2012 19:06:38 +0800
Message-ID: <1336993600-30065-3-git-send-email-b29396@freescale.com>
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
 drivers/pinctrl/pinctrl-imx.c |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-imx.c b/drivers/pinctrl/pinctrl-imx.c
index 8faf613..f6e7c67 100644
--- a/drivers/pinctrl/pinctrl-imx.c
+++ b/drivers/pinctrl/pinctrl-imx.c
@@ -269,12 +269,6 @@ static int imx_pmx_enable(struct pinctrl_dev *pctldev, unsigned selector,
 	return 0;
 }
 
-static void imx_pmx_disable(struct pinctrl_dev *pctldev, unsigned func_selector,
-			    unsigned group_selector)
-{
-	/* nothing to do here */
-}
-
 static int imx_pmx_get_funcs_count(struct pinctrl_dev *pctldev)
 {
 	struct imx_pinctrl *ipctl = pinctrl_dev_get_drvdata(pctldev);
@@ -310,7 +304,6 @@ static struct pinmux_ops imx_pmx_ops = {
 	.get_function_name = imx_pmx_get_func_name,
 	.get_function_groups = imx_pmx_get_groups,
 	.enable = imx_pmx_enable,
-	.disable = imx_pmx_disable,
 };
 
 static int imx_pinconf_get(struct pinctrl_dev *pctldev,
-- 
1.7.0.4


