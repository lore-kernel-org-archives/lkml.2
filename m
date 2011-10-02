Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753639Ab1JBOun (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Oct 2011 10:50:43 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:61953 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752784Ab1JBOrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Oct 2011 10:47:08 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Tony Lindgren <tony@atomide.com>
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 29/30] ARM: omap: select USB_ARCH_HAS_EHCI only when USB is enabled
Date: Sun,  2 Oct 2011 16:45:59 +0200
Message-Id: <1317566760-25681-30-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1317566760-25681-1-git-send-email-arnd@arndb.de>
References: <1317566760-25681-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:bwKxHoZjR7luTWyfhJDXK4kXeySoC9DVIW3yITqd7wA
 5s0GvzMmgaKSbBVQow8HbKhu2Yh/6XPzHefBThVrD1LyWn7eQk
 78bLR0DFDEvAL+CmjjJeX1O+kACmg4SHzAQLUfOdaeBppPE6Dl
 0lo3xI1/WnGVlx5jzmGGFMMTMxARIp2HIUnGRMjpj6LRlEVYN/
 87/IrSbeBnz8NbzSLTbbbiNEZi2DQpJx6DgvlzJr39Q9PDA8mH
 ztlZQRTTiBh1RTHuVBSwrdb0p/WHTn7Y1BzvK/lHap8sdmKAZ3
 akDj/anfAE2u/b/eXVq7QctIT6mc490HPytEBAntCbYG872XnY
 nI7F1D9JNeIN7KPIP/RoDVJuDcguUbbpTQH5Eoq3KSHyExGMj8
 LL+OHzuX1vAxQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This avoids a warning from Kconfig about missing dependencies.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm/mach-omap2/Kconfig |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-omap2/Kconfig b/arch/arm/mach-omap2/Kconfig
index 3921a95..fdd45dd 100644
--- a/arch/arm/mach-omap2/Kconfig
+++ b/arch/arm/mach-omap2/Kconfig
@@ -32,7 +32,7 @@ config ARCH_OMAP3
 	depends on ARCH_OMAP2PLUS
 	default y
 	select CPU_V7
-	select USB_ARCH_HAS_EHCI
+	select USB_ARCH_HAS_EHCI if USB_SUPPORT
 	select ARM_L1_CACHE_SHIFT_6 if !ARCH_OMAP4
 	select ARCH_HAS_OPP
 	select PM_OPP if PM
@@ -50,7 +50,7 @@ config ARCH_OMAP4
 	select CACHE_L2X0
 	select ARCH_HAS_OPP
 	select PM_OPP if PM
-	select USB_ARCH_HAS_EHCI
+	select USB_ARCH_HAS_EHCI if USB_SUPPORT
 
 config ARCH_OMAP2_AUTO
 	bool
-- 
1.7.5.4

