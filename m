Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756745Ab0F3P4u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 11:56:50 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:39664 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755730Ab0F3P4s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 11:56:48 -0400
Date: Wed, 30 Jun 2010 17:56:46 +0200
From: Christoph Egger <siccegge@cs.fau.de>
To: Russell King <linux@arm.linux.org.uk>, Andrew Victor <linux@maxim.org.za>,
       "Antonio R. Costa" <costa.antonior@gmail.com>,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: vamos@i4.informatik.uni-erlangen.de
Subject: [PATCH 09/33] Removing dead MAGICV
Message-ID: <a770ecd46d47e48a60d98e7aeaeb4c2583609a4a.1277911346.git.siccegge@cs.fau.de>
References: <cover.1277911345.git.siccegge@cs.fau.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1277911345.git.siccegge@cs.fau.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MAGICV doesn't exist in Kconfig, therefore removing all
references for it from the source code.

Signed-off-by: Christoph Egger <siccegge@cs.fau.de>
---
 arch/arm/mach-at91/at572d940hf_devices.c |   73 ------------------------------
 1 files changed, 0 insertions(+), 73 deletions(-)

diff --git a/arch/arm/mach-at91/at572d940hf_devices.c b/arch/arm/mach-at91/at572d940hf_devices.c
index 0fc20a2..bff703e 100644
--- a/arch/arm/mach-at91/at572d940hf_devices.c
+++ b/arch/arm/mach-at91/at572d940hf_devices.c
@@ -878,80 +878,7 @@ void __init at91_set_serial_console(unsigned portnr) {}
 void __init at91_add_device_serial(void) {}
 #endif
 
-
-/* --------------------------------------------------------------------
- *  mAgic
- * -------------------------------------------------------------------- */
-
-#ifdef CONFIG_MAGICV
-static struct resource mAgic_resources[] = {
-	{
-		.start = AT91_MAGIC_PM_BASE,
-		.end   = AT91_MAGIC_PM_BASE + AT91_MAGIC_PM_SIZE - 1,
-		.flags = IORESOURCE_MEM,
-	},
-	{
-		.start = AT91_MAGIC_DM_I_BASE,
-		.end   = AT91_MAGIC_DM_I_BASE + AT91_MAGIC_DM_I_SIZE - 1,
-		.flags = IORESOURCE_MEM,
-	},
-	{
-		.start = AT91_MAGIC_DM_F_BASE,
-		.end   = AT91_MAGIC_DM_F_BASE + AT91_MAGIC_DM_F_SIZE - 1,
-		.flags = IORESOURCE_MEM,
-	},
-	{
-		.start = AT91_MAGIC_DM_DB_BASE,
-		.end   = AT91_MAGIC_DM_DB_BASE + AT91_MAGIC_DM_DB_SIZE - 1,
-		.flags = IORESOURCE_MEM,
-	},
-	{
-		.start = AT91_MAGIC_REGS_BASE,
-		.end   = AT91_MAGIC_REGS_BASE + AT91_MAGIC_REGS_SIZE - 1,
-		.flags = IORESOURCE_MEM,
-	},
-	{
-		.start = AT91_MAGIC_EXTPAGE_BASE,
-		.end   = AT91_MAGIC_EXTPAGE_BASE + AT91_MAGIC_EXTPAGE_SIZE - 1,
-		.flags = IORESOURCE_MEM,
-	},
-	{
-		.start  = AT572D940HF_ID_MSIRQ0,
-		.end    = AT572D940HF_ID_MSIRQ0,
-		.flags  = IORESOURCE_IRQ,
-	},
-	{
-		.start  = AT572D940HF_ID_MHALT,
-		.end    = AT572D940HF_ID_MHALT,
-		.flags  = IORESOURCE_IRQ,
-	},
-	{
-		.start  = AT572D940HF_ID_MEXC,
-		.end    = AT572D940HF_ID_MEXC,
-		.flags  = IORESOURCE_IRQ,
-	},
-	{
-		.start  = AT572D940HF_ID_MEDMA,
-		.end    = AT572D940HF_ID_MEDMA,
-		.flags  = IORESOURCE_IRQ,
-	},
-};
-
-static struct platform_device mAgic_device = {
-	.name           = "mAgic",
-	.id             = -1,
-	.num_resources  = ARRAY_SIZE(mAgic_resources),
-	.resource       = mAgic_resources,
-};
-
-void __init at91_add_device_mAgic(void)
-{
-	platform_device_register(&mAgic_device);
-}
-#else
 void __init at91_add_device_mAgic(void) {}
-#endif
-
 
 /* -------------------------------------------------------------------- */
 
-- 
1.7.0.4

