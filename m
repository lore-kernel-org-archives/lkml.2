Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751919Ab2KLGdq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 01:33:46 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54960 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751050Ab2KLGdp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 01:33:45 -0500
Message-ID: <1352702020.15066.2.camel@phoenix>
Subject: [PATCH] pinctrl: Drop selecting PINCONF for MMP2, PXA168 and PXA910
From: Axel Lin <axel.lin@ingics.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Haojian Zhuang <haojian.zhuang@marvell.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Mon, 12 Nov 2012 14:33:40 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These drivers do not need to select PINCONF.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/pinctrl/Kconfig |    3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/pinctrl/Kconfig b/drivers/pinctrl/Kconfig
index 6d5a50b..1d61d89 100644
--- a/drivers/pinctrl/Kconfig
+++ b/drivers/pinctrl/Kconfig
@@ -96,7 +96,6 @@ config PINCTRL_MMP2
 	bool "MMP2 pin controller driver"
 	depends on ARCH_MMP
 	select PINCTRL_PXA3xx
-	select PINCONF
 
 config PINCTRL_MXS
 	bool
@@ -135,13 +134,11 @@ config PINCTRL_PXA168
 	bool "PXA168 pin controller driver"
 	depends on ARCH_MMP
 	select PINCTRL_PXA3xx
-	select PINCONF
 
 config PINCTRL_PXA910
 	bool "PXA910 pin controller driver"
 	depends on ARCH_MMP
 	select PINCTRL_PXA3xx
-	select PINCONF
 
 config PINCTRL_SINGLE
 	tristate "One-register-per-pin type device tree based pinctrl driver"
-- 
1.7.9.5



