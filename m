Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752062Ab2KLGaU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 01:30:20 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:52417 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290Ab2KLGaS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 01:30:18 -0500
Message-ID: <1352701807.15066.1.camel@phoenix>
Subject: [PATCH] ARM: select PINCTRL for ARCH_MMP
From: Axel Lin <axel.lin@ingics.com>
To: Russell King <linux@arm.linux.org.uk>
Cc: Haojian Zhuang <haojian.zhuang@marvell.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Mon, 12 Nov 2012 14:30:07 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This makes PINCTRL related config options visible.
Otherwise there is no way to build pinctrl drivers for MMP2, PXA168 and PXA910.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 arch/arm/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 48eea16..24e9339 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -581,6 +581,7 @@ config ARCH_MMP
 	select GPIO_PXA
 	select IRQ_DOMAIN
 	select NEED_MACH_GPIO_H
+	select PINCTRL
 	select PLAT_PXA
 	select SPARSE_IRQ
 	help
-- 
1.7.9.5



