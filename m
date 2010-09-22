Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755265Ab0IVTWl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 15:22:41 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:43801 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754933Ab0IVTWk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 15:22:40 -0400
From: Thomas Weber <weber@corscience.de>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org, Thomas Weber O <weber@corscience.de>
Subject: [PATCH] Fix typo: configuation => configuration
Date: Wed, 22 Sep 2010 21:23:38 +0200
Message-Id: <1285183418-28272-1-git-send-email-weber@corscience.de>
X-Mailer: git-send-email 1.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Weber O <weber@corscience.de>

Signed-off-by: Thomas Weber <weber@corscience.de>
---
 arch/arm/mach-omap2/hsmmc.h         |    2 +-
 arch/mips/sibyte/common/sb_tbprof.c |    2 +-
 drivers/net/bnx2x/bnx2x_link.c      |    2 +-
 drivers/net/irda/ali-ircc.c         |    2 +-
 drivers/net/sb1250-mac.c            |    6 +++---
 5 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/arm/mach-omap2/hsmmc.h b/arch/arm/mach-omap2/hsmmc.h
index 36f0ba8..6536c31 100644
--- a/arch/arm/mach-omap2/hsmmc.h
+++ b/arch/arm/mach-omap2/hsmmc.h
@@ -21,7 +21,7 @@ struct omap2_hsmmc_info {
 	char	*name;		/* or NULL for default */
 	struct device *dev;	/* returned: pointer to mmc adapter */
 	int	ocr_mask;	/* temporary HACK */
-	/* Remux (pad configuation) when powering on/off */
+	/* Remux (pad configuration) when powering on/off */
 	void (*remux)(struct device *dev, int slot, int power_on);
 };
 
diff --git a/arch/mips/sibyte/common/sb_tbprof.c b/arch/mips/sibyte/common/sb_tbprof.c
index d4ed7a9..a2bdb2e 100644
--- a/arch/mips/sibyte/common/sb_tbprof.c
+++ b/arch/mips/sibyte/common/sb_tbprof.c
@@ -43,7 +43,7 @@
 #include <asm/sibyte/sb1250_scd.h>
 #include <asm/sibyte/sb1250_int.h>
 #else
-#error invalid SiByte UART configuation
+#error invalid SiByte UART configuration
 #endif
 
 #if defined(CONFIG_SIBYTE_BCM1x55) || defined(CONFIG_SIBYTE_BCM1x80)
diff --git a/drivers/net/bnx2x/bnx2x_link.c b/drivers/net/bnx2x/bnx2x_link.c
index 0383e30..c2146e7 100644
--- a/drivers/net/bnx2x/bnx2x_link.c
+++ b/drivers/net/bnx2x/bnx2x_link.c
@@ -3735,7 +3735,7 @@ static u8 bnx2x_ext_phy_init(struct link_params *params, struct link_vars *vars)
 					/* Clear first 3 bits of the control */
 					val &= ~0x7;
 					/* Set control bits according to
-					configuation */
+					configuration */
 					val |= (params->xgxs_config_rx[i] &
 						0x7);
 					DP(NETIF_MSG_LINK, "Setting RX"
diff --git a/drivers/net/irda/ali-ircc.c b/drivers/net/irda/ali-ircc.c
index a3cb109..92631eb 100644
--- a/drivers/net/irda/ali-ircc.c
+++ b/drivers/net/irda/ali-ircc.c
@@ -142,7 +142,7 @@ static void SetCOMInterrupts(struct ali_ircc_cb *self , unsigned char enable);
  * Function ali_ircc_init ()
  *
  *    Initialize chip. Find out whay kinds of chips we are dealing with
- *    and their configuation registers address
+ *    and their configuration registers address
  */
 static int __init ali_ircc_init(void)
 {
diff --git a/drivers/net/sb1250-mac.c b/drivers/net/sb1250-mac.c
index 8e6bd45..a3f36be 100644
--- a/drivers/net/sb1250-mac.c
+++ b/drivers/net/sb1250-mac.c
@@ -95,7 +95,7 @@ MODULE_PARM_DESC(int_timeout_rx, "RX timeout value");
 #include <asm/sibyte/sb1250_regs.h>
 #include <asm/sibyte/sb1250_int.h>
 #else
-#error invalid SiByte MAC configuation
+#error invalid SiByte MAC configuration
 #endif
 #include <asm/sibyte/sb1250_scd.h>
 #include <asm/sibyte/sb1250_mac.h>
@@ -106,7 +106,7 @@ MODULE_PARM_DESC(int_timeout_rx, "RX timeout value");
 #elif defined(CONFIG_SIBYTE_SB1250) || defined(CONFIG_SIBYTE_BCM112X)
 #define UNIT_INT(n)		(K_INT_MAC_0 + (n))
 #else
-#error invalid SiByte MAC configuation
+#error invalid SiByte MAC configuration
 #endif
 
 #ifdef K_INT_PHY
@@ -1568,7 +1568,7 @@ static void sbmac_channel_start(struct sbmac_softc *s)
 		       M_MAC_RX_ENABLE |
 		       M_MAC_TX_ENABLE, s->sbm_macenable);
 #else
-#error invalid SiByte MAC configuation
+#error invalid SiByte MAC configuration
 #endif
 
 #ifdef CONFIG_SBMAC_COALESCE
-- 
1.7.3

