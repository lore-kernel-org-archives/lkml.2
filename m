Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752141Ab2KFP2n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 10:28:43 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:47273 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326Ab2KFP2m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 10:28:42 -0500
Message-ID: <1352215711.3692.1.camel@phoenix>
Subject: [PATCH] pinctrl: samsung: Remove a redundant settting for
 ctrldesc->npins
From: Axel Lin <axel.lin@ingics.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Tomasz Figa <t.figa@samsung.com>, linux-kernel@vger.kernel.org
Date: Tue, 06 Nov 2012 23:28:31 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Set it once is enough.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/pinctrl/pinctrl-samsung.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/pinctrl/pinctrl-samsung.c b/drivers/pinctrl/pinctrl-samsung.c
index fc34cac..1307283 100644
--- a/drivers/pinctrl/pinctrl-samsung.c
+++ b/drivers/pinctrl/pinctrl-samsung.c
@@ -714,7 +714,6 @@ static int __devinit samsung_pinctrl_register(struct platform_device *pdev,
 	}
 	ctrldesc->pins = pindesc;
 	ctrldesc->npins = drvdata->ctrl->nr_pins;
-	ctrldesc->npins = drvdata->ctrl->nr_pins;
 
 	/* dynamically populate the pin number and pin name for pindesc */
 	for (pin = 0, pdesc = pindesc; pin < ctrldesc->npins; pin++, pdesc++)
-- 
1.7.9.5



