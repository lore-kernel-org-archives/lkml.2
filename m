Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755124Ab2FSVld (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 17:41:33 -0400
Received: from eu1sys200aog103.obsmtp.com ([207.126.144.115]:37401 "EHLO
	eu1sys200aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753517Ab2FSVlc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 17:41:32 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Cc: Stephen Warren <swarren@nvidia.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH] pinctrl/u300: drop unused variable
Date: Tue, 19 Jun 2012 23:40:54 +0200
Message-ID: <1340142054-14077-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.9.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

The "i" variable was left after the GPIO range cleanup
moved to core.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/pinctrl/pinctrl-u300.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/pinctrl/pinctrl-u300.c b/drivers/pinctrl/pinctrl-u300.c
index 5f43f9a..a7ad8c1 100644
--- a/drivers/pinctrl/pinctrl-u300.c
+++ b/drivers/pinctrl/pinctrl-u300.c
@@ -1173,7 +1173,6 @@ out_no_resource:
 static int __devexit u300_pmx_remove(struct platform_device *pdev)
 {
 	struct u300_pmx *upmx = platform_get_drvdata(pdev);
-	int i;
 
 	pinctrl_unregister(upmx->pctl);
 	iounmap(upmx->virtbase);
-- 
1.7.9.2

