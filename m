Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753329Ab2KIMgo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 07:36:44 -0500
Received: from eu1sys200aog113.obsmtp.com ([207.126.144.135]:44295 "EHLO
	eu1sys200aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753082Ab2KIMgn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 07:36:43 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Cc: Stephen Warren <swarren@nvidia.com>, Anmar Oueja <anmar.oueja@linaro.org>,
        Jean-Nicolas Graux <jean-nicolas.graux@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH] pinctrl/nomadik: db8540: fix moduartstmmux_oc4_1 pin group definition.
Date: Fri, 9 Nov 2012 13:36:25 +0100
Message-ID: <1352464585-481-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.11.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jean-Nicolas Graux <jean-nicolas.graux@stericsson.com>

One group definition was missing, so add it.

Signed-off-by: Jean-Nicolas Graux <jean-nicolas.graux@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/pinctrl/pinctrl-nomadik-db8540.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pinctrl/pinctrl-nomadik-db8540.c b/drivers/pinctrl/pinctrl-nomadik-db8540.c
index 52fc301..bce0583 100644
--- a/drivers/pinctrl/pinctrl-nomadik-db8540.c
+++ b/drivers/pinctrl/pinctrl-nomadik-db8540.c
@@ -822,6 +822,7 @@ static const struct nmk_pingroup nmk_db8540_groups[] = {
 	DB8540_PIN_GROUP(modaccuarttxrx_oc4_1, NMK_GPIO_ALT_C4),
 	DB8540_PIN_GROUP(modaccuartrtscts_oc4_1, NMK_GPIO_ALT_C4),
 	DB8540_PIN_GROUP(stmmod_oc4_1, NMK_GPIO_ALT_C4),
+	DB8540_PIN_GROUP(moduartstmmux_oc4_1, NMK_GPIO_ALT_C4),
 
 };
 
-- 
1.7.11.3

