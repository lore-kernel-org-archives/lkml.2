Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753783Ab1IET7W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 15:59:22 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:54128 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753601Ab1IET7Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 15:59:16 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1+8qa1g5GG8aSwrQ9BI+pURR6Sh4S05wTOYDR9H2Z
	C3alaqYyH5GPsV
From: Peter Huewe <peterhuewe@gmx.de>
To: Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH] ARM: Footbridge: Sort KConfig Options alphabetically
Date: Mon,  5 Sep 2011 21:59:08 +0200
Message-Id: <1315252748-5689-1-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.3.4
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As per request of rmk, the options should be sorted alphabetically.

KernelVersion: Linux next-20110831

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 arch/arm/mach-footbridge/Kconfig |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-footbridge/Kconfig b/arch/arm/mach-footbridge/Kconfig
index c8e7afc..f643ef8 100644
--- a/arch/arm/mach-footbridge/Kconfig
+++ b/arch/arm/mach-footbridge/Kconfig
@@ -4,8 +4,8 @@ menu "Footbridge Implementations"
 
 config ARCH_CATS
 	bool "CATS"
-	select CLKSRC_I8253
 	select CLKEVT_I8253
+	select CLKSRC_I8253
 	select FOOTBRIDGE_HOST
 	select ISA
 	select ISA_DMA
@@ -61,8 +61,8 @@ config ARCH_EBSA285_HOST
 
 config ARCH_NETWINDER
 	bool "NetWinder"
-	select CLKSRC_I8253
 	select CLKEVT_I8253
+	select CLKSRC_I8253
 	select FOOTBRIDGE_HOST
 	select ISA
 	select ISA_DMA
-- 
1.7.3.4

