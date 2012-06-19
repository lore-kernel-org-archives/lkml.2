Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753699Ab2FSMDc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 08:03:32 -0400
Received: from eu1sys200aog117.obsmtp.com ([207.126.144.143]:50776 "EHLO
	eu1sys200aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751344Ab2FSMDb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 08:03:31 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Cc: Stephen Warren <swarren@nvidia.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH] pinctrl/u300: delete pointless debug print
Date: Tue, 19 Jun 2012 14:03:14 +0200
Message-ID: <1340107394-2364-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.9.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

This is some leftover from earlier development, let's get rid
of it.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/pinctrl/pinctrl-u300.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-u300.c b/drivers/pinctrl/pinctrl-u300.c
index 49b91c2..5f43f9a 100644
--- a/drivers/pinctrl/pinctrl-u300.c
+++ b/drivers/pinctrl/pinctrl-u300.c
@@ -1113,8 +1113,6 @@ static int __devinit u300_pmx_probe(struct platform_device *pdev)
 	int ret;
 	int i;
 
-	pr_err("U300 PMX PROBE\n");
-
 	/* Create state holders etc for this driver */
 	upmx = devm_kzalloc(&pdev->dev, sizeof(*upmx), GFP_KERNEL);
 	if (!upmx)
-- 
1.7.9.2

