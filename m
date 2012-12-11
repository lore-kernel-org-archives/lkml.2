Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753148Ab2LKNgQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 08:36:16 -0500
Received: from eu1sys200aog104.obsmtp.com ([207.126.144.117]:48082 "EHLO
	eu1sys200aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752816Ab2LKNgP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 08:36:15 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Cc: Stephen Warren <swarren@nvidia.com>, Anmar Oueja <anmar.oueja@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 1/2] pinctrl: fix comment mistake
Date: Tue, 11 Dec 2012 14:35:54 +0100
Message-ID: <1355232954-16559-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.11.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

This variable pertains to pinctrl handles not muxes
specifically.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/pinctrl/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c
index 5cdee86..59f5a96 100644
--- a/drivers/pinctrl/core.c
+++ b/drivers/pinctrl/core.c
@@ -700,7 +700,7 @@ static struct pinctrl *create_pinctrl(struct device *dev)
 		}
 	}
 
-	/* Add the pinmux to the global list */
+	/* Add the pinctrl handle to the global list */
 	list_add_tail(&p->node, &pinctrl_list);
 
 	return p;
-- 
1.7.11.3

