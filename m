Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753082Ab2FRSLM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 14:11:12 -0400
Received: from eu1sys200aog110.obsmtp.com ([207.126.144.129]:33821 "EHLO
	eu1sys200aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751873Ab2FRSLK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 14:11:10 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Cc: Stephen Warren <swarren@nvidia.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH] pinctrl: select the proper symbol
Date: Mon, 18 Jun 2012 20:10:51 +0200
Message-ID: <1340043051-28746-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.9.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

The Kconfig entry for the COH901 pin controller depended on
PINMUX_U300 which is stale, use PINCTRL_U300 as it is called
these days.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/pinctrl/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/Kconfig b/drivers/pinctrl/Kconfig
index c6e6ae0..4c05fe8 100644
--- a/drivers/pinctrl/Kconfig
+++ b/drivers/pinctrl/Kconfig
@@ -130,7 +130,7 @@ config PINCTRL_U300
 
 config PINCTRL_COH901
 	bool "ST-Ericsson U300 COH 901 335/571 GPIO"
-	depends on GPIOLIB && ARCH_U300 && PINMUX_U300
+	depends on GPIOLIB && ARCH_U300 && PINCTRL_U300
 	help
 	  Say yes here to support GPIO interface on ST-Ericsson U300.
 	  The names of the two IP block variants supported are
-- 
1.7.9.2

