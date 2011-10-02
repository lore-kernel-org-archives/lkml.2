Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753453Ab1JBOth (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Oct 2011 10:49:37 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:55172 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752769Ab1JBOrD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Oct 2011 10:47:03 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Tony Lindgren <tony@atomide.com>
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 27/30] ARM: omap: select L2X0 cache on omap4
Date: Sun,  2 Oct 2011 16:45:57 +0200
Message-Id: <1317566760-25681-28-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1317566760-25681-1-git-send-email-arnd@arndb.de>
References: <1317566760-25681-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:r/Tfg2vWG5tkJNnSpRUdIDU8PZ48EuOEHlljWS5LtMy
 uV0mofgxClHPUfFcgs2D47xcnPJrxCfGfiRxbXBApzo7bMlcTu
 0UjVWd0+0ErkCQGpwWquMbxpJL5LfPVwSPLrvjQvrcQVM6jg/u
 n+KVwxLQbIT0N7rJMP9qw9kgor6WQwbDNkFE4HHViEpzgjzBcK
 mDr89tfuXtat1amttukcG8DtPjlcaFR7MzMBL4BuTqhIS4uPke
 OYjvk7Rxj1RNKi8gQdmu71pn/BCg9+PZlVYGTiCvg2zLFMtEGt
 /E8/ovQtVfQQx0wWyu+9bI//MFywvJOc8/f1v+pGnJuQQ/4vLp
 y/rbyfOMbM6tuOA2AE0eV2uF5Vnlbcjmz5pGZBBu92iZpPstM4
 eYamaXEi+lJxQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The cache controller needs to be enabled for the
cortex-a9 specific errata that are also selected
to work.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm/mach-omap2/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-omap2/Kconfig b/arch/arm/mach-omap2/Kconfig
index fd0ab18..3921a95 100644
--- a/arch/arm/mach-omap2/Kconfig
+++ b/arch/arm/mach-omap2/Kconfig
@@ -47,6 +47,7 @@ config ARCH_OMAP4
 	select PL310_ERRATA_588369
 	select PL310_ERRATA_727915
 	select ARM_ERRATA_720789
+	select CACHE_L2X0
 	select ARCH_HAS_OPP
 	select PM_OPP if PM
 	select USB_ARCH_HAS_EHCI
-- 
1.7.5.4

