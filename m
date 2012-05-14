Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755937Ab2ENLBi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 07:01:38 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:8538 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755562Ab2ENLBd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 07:01:33 -0400
X-SpamScore: 3
X-BigFish: VS3(zzzz1202h1082kzz8275dhz2dh2a8h668h839hd24he5bh)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Dong Aisheng <b29396@freescale.com>
To: <linux-kernel@vger.kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linus.walleij@stericsson.com>,
        <swarren@wwwdotorg.org>, <haojian.zhuang@marvell.com>,
        <shawn.guo@freescale.com>
Subject: [PATCH 4/5] pinctrl: pinctrl-mxs: remove empty pinmux disable function
Date: Mon, 14 May 2012 19:06:39 +0800
Message-ID: <1336993600-30065-4-git-send-email-b29396@freescale.com>
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
 drivers/pinctrl/pinctrl-mxs.c |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-mxs.c b/drivers/pinctrl/pinctrl-mxs.c
index 93cd959..e10eff7 100644
--- a/drivers/pinctrl/pinctrl-mxs.c
+++ b/drivers/pinctrl/pinctrl-mxs.c
@@ -203,18 +203,11 @@ static int mxs_pinctrl_enable(struct pinctrl_dev *pctldev, unsigned selector,
 	return 0;
 }
 
-static void mxs_pinctrl_disable(struct pinctrl_dev *pctldev,
-				unsigned function, unsigned group)
-{
-	/* Nothing to do here */
-}
-
 static struct pinmux_ops mxs_pinmux_ops = {
 	.get_functions_count = mxs_pinctrl_get_funcs_count,
 	.get_function_name = mxs_pinctrl_get_func_name,
 	.get_function_groups = mxs_pinctrl_get_func_groups,
 	.enable = mxs_pinctrl_enable,
-	.disable = mxs_pinctrl_disable,
 };
 
 static int mxs_pinconf_get(struct pinctrl_dev *pctldev,
-- 
1.7.0.4


