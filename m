Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754944Ab1DITFj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Apr 2011 15:05:39 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59996 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754748Ab1DITFg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Apr 2011 15:05:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=JD7LaZSZdJch5T2g/kbeEr58l+5d3FrOfheYDpt8Zb5YBToUo/X8GvFO7iUQdmkNYu
         y3bqWCYcAzJzAu2pso6KIJ+elm1Juhiv55vAS/u+a2XpaslcSPOQ/1Ybk+UlOSs9LhTa
         vNObj77pPD0qAEpzrz2oIrSwN7MgAzxAJ2EUY=
From: wanlong.gao@gmail.com
To: linux@arm.linux.org.uk, hans-christian.egtvedt@atmel.com,
        ralf@linux-mips.org, benh@kernel.crashing.org, paulus@samba.org,
        david.woodhouse@intel.com, akpm@linux-foundation.org,
        u.kleine-koenig@pengutronix.de, mingo@elte.hu, rientjes@google.com,
        nicolas.ferre@atmel.com, eric@eukrea.com, tony@atomide.com,
        santosh.shilimkar@ti.com, khilman@deeprootsystems.com,
        ben-linux@fluff.org, sam@ravnborg.org, manuel.lauss@googlemail.com,
        galak@kernel.crashing.org, anton@samba.org, grant.likely@secretlab.ca,
        sfr@canb.auug.org.au, jwboyer@linux.vnet.ibm.com
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mips@linux-mips.org, linuxppc-dev@lists.ozlabs.org,
        Wanlong Gao <wanlong.gao@gmail.com>
Subject: [PATCH] fix build warnings on defconfigs
Date: Sun, 10 Apr 2011 03:04:18 +0800
Message-Id: <1302375858-11253-1-git-send-email-wanlong.gao@gmail.com>
X-Mailer: git-send-email 1.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wanlong Gao <wanlong.gao@gmail.com>

Change the BT_L2CAP and BT_SCO defconfigs from 'm' to 'y',
since BT_L2CAP and BT_SCO had changed to bool configs.

Signed-off-by: Wanlong Gao <wanlong.gao@gmail.com>
---
 arch/arm/configs/am200epdkit_defconfig     |    4 ++--
 arch/arm/configs/at572d940hfek_defconfig   |    2 +-
 arch/arm/configs/at91rm9200_defconfig      |    4 ++--
 arch/arm/configs/badge4_defconfig          |    2 +-
 arch/arm/configs/cm_x2xx_defconfig         |    4 ++--
 arch/arm/configs/cm_x300_defconfig         |    4 ++--
 arch/arm/configs/colibri_pxa270_defconfig  |    4 ++--
 arch/arm/configs/corgi_defconfig           |    4 ++--
 arch/arm/configs/davinci_all_defconfig     |    2 +-
 arch/arm/configs/em_x270_defconfig         |    4 ++--
 arch/arm/configs/magician_defconfig        |    4 ++--
 arch/arm/configs/mini2440_defconfig        |    4 ++--
 arch/arm/configs/nhk8815_defconfig         |    4 ++--
 arch/arm/configs/ns9xxx_defconfig          |    2 +-
 arch/arm/configs/omap2plus_defconfig       |    4 ++--
 arch/arm/configs/pxa3xx_defconfig          |    2 +-
 arch/arm/configs/s3c2410_defconfig         |    6 +++---
 arch/arm/configs/simpad_defconfig          |    4 ++--
 arch/arm/configs/spitz_defconfig           |    4 ++--
 arch/arm/configs/trizeps4_defconfig        |    4 ++--
 arch/arm/configs/viper_defconfig           |    2 +-
 arch/arm/configs/zeus_defconfig            |    4 ++--
 arch/avr32/configs/atngw100_mrmt_defconfig |    2 +-
 arch/mips/configs/lemote2f_defconfig       |    4 ++--
 arch/mips/configs/mtx1_defconfig           |    4 ++--
 arch/powerpc/configs/c2k_defconfig         |    4 ++--
 arch/powerpc/configs/pmac32_defconfig      |    4 ++--
 arch/powerpc/configs/ppc6xx_defconfig      |    4 ++--
 arch/powerpc/configs/ps3_defconfig         |    4 ++--
 29 files changed, 52 insertions(+), 52 deletions(-)

diff --git a/arch/arm/configs/am200epdkit_defconfig b/arch/arm/configs/am200epdkit_defconfig
index f0dea52..0a7d807 100644
--- a/arch/arm/configs/am200epdkit_defconfig
+++ b/arch/arm/configs/am200epdkit_defconfig
@@ -34,8 +34,8 @@ CONFIG_INET=y
 # CONFIG_INET_DIAG is not set
 # CONFIG_IPV6 is not set
 CONFIG_BT=m
-CONFIG_BT_L2CAP=m
-CONFIG_BT_SCO=m
+CONFIG_BT_L2CAP=y
+CONFIG_BT_SCO=y
 CONFIG_BT_RFCOMM=m
 CONFIG_BT_RFCOMM_TTY=y
 CONFIG_BT_BNEP=m
diff --git a/arch/arm/configs/at572d940hfek_defconfig b/arch/arm/configs/at572d940hfek_defconfig
index 1b1158a..8409374 100644
--- a/arch/arm/configs/at572d940hfek_defconfig
+++ b/arch/arm/configs/at572d940hfek_defconfig
@@ -280,7 +280,7 @@ CONFIG_SDIO_UART=m
 CONFIG_MMC_AT91=m
 CONFIG_MMC_SPI=m
 CONFIG_NEW_LEDS=y
-CONFIG_LEDS_CLASS=m
+CONFIG_LEDS_CLASS=y
 CONFIG_LEDS_GPIO=m
 CONFIG_LEDS_TRIGGERS=y
 CONFIG_LEDS_TRIGGER_TIMER=m
diff --git a/arch/arm/configs/at91rm9200_defconfig b/arch/arm/configs/at91rm9200_defconfig
index 38cb7c9..b21dd9e 100644
--- a/arch/arm/configs/at91rm9200_defconfig
+++ b/arch/arm/configs/at91rm9200_defconfig
@@ -75,8 +75,8 @@ CONFIG_IPV6_TUNNEL=m
 CONFIG_BRIDGE=m
 CONFIG_VLAN_8021Q=m
 CONFIG_BT=m
-CONFIG_BT_L2CAP=m
-CONFIG_BT_SCO=m
+CONFIG_BT_L2CAP=y
+CONFIG_BT_SCO=y
 CONFIG_BT_RFCOMM=m
 CONFIG_BT_RFCOMM_TTY=y
 CONFIG_BT_BNEP=m
diff --git a/arch/arm/configs/badge4_defconfig b/arch/arm/configs/badge4_defconfig
index 5b54abb..ddd8eb2 100644
--- a/arch/arm/configs/badge4_defconfig
+++ b/arch/arm/configs/badge4_defconfig
@@ -24,7 +24,7 @@ CONFIG_IRCOMM=y
 CONFIG_IRDA_ULTRA=y
 CONFIG_SA1100_FIR=y
 CONFIG_BT=m
-CONFIG_BT_L2CAP=m
+CONFIG_BT_L2CAP=y
 CONFIG_BT_HCIUART=m
 CONFIG_BT_HCIVHCI=m
 # CONFIG_FW_LOADER is not set
diff --git a/arch/arm/configs/cm_x2xx_defconfig b/arch/arm/configs/cm_x2xx_defconfig
index a93ff8d..04bf923 100644
--- a/arch/arm/configs/cm_x2xx_defconfig
+++ b/arch/arm/configs/cm_x2xx_defconfig
@@ -43,8 +43,8 @@ CONFIG_IP_PNP_BOOTP=y
 # CONFIG_INET_DIAG is not set
 # CONFIG_IPV6 is not set
 CONFIG_BT=m
-CONFIG_BT_L2CAP=m
-CONFIG_BT_SCO=m
+CONFIG_BT_L2CAP=y
+CONFIG_BT_SCO=y
 CONFIG_BT_RFCOMM=m
 CONFIG_BT_BNEP=m
 CONFIG_BT_HIDP=m
diff --git a/arch/arm/configs/cm_x300_defconfig b/arch/arm/configs/cm_x300_defconfig
index 921e56a..d7c7d99 100644
--- a/arch/arm/configs/cm_x300_defconfig
+++ b/arch/arm/configs/cm_x300_defconfig
@@ -40,8 +40,8 @@ CONFIG_IP_PNP_RARP=y
 # CONFIG_INET_DIAG is not set
 # CONFIG_IPV6 is not set
 CONFIG_BT=m
-CONFIG_BT_L2CAP=m
-CONFIG_BT_SCO=m
+CONFIG_BT_L2CAP=y
+CONFIG_BT_SCO=y
 CONFIG_BT_RFCOMM=m
 CONFIG_BT_RFCOMM_TTY=y
 CONFIG_BT_BNEP=m
diff --git a/arch/arm/configs/colibri_pxa270_defconfig b/arch/arm/configs/colibri_pxa270_defconfig
index 2ef2c5e..a381317 100644
--- a/arch/arm/configs/colibri_pxa270_defconfig
+++ b/arch/arm/configs/colibri_pxa270_defconfig
@@ -45,8 +45,8 @@ CONFIG_IRDA_CACHE_LAST_LSAP=y
 CONFIG_IRDA_FAST_RR=y
 CONFIG_IRTTY_SIR=m
 CONFIG_BT=m
-CONFIG_BT_L2CAP=m
-CONFIG_BT_SCO=m
+CONFIG_BT_L2CAP=y
+CONFIG_BT_SCO=y
 CONFIG_BT_RFCOMM=m
 CONFIG_BT_RFCOMM_TTY=y
 CONFIG_BT_BNEP=m
diff --git a/arch/arm/configs/corgi_defconfig b/arch/arm/configs/corgi_defconfig
index e53c475..ee85811 100644
--- a/arch/arm/configs/corgi_defconfig
+++ b/arch/arm/configs/corgi_defconfig
@@ -69,8 +69,8 @@ CONFIG_IRNET=m
 CONFIG_IRCOMM=m
 CONFIG_PXA_FICP=m
 CONFIG_BT=m
-CONFIG_BT_L2CAP=m
-CONFIG_BT_SCO=m
+CONFIG_BT_L2CAP=y
+CONFIG_BT_SCO=y
 CONFIG_BT_RFCOMM=m
 CONFIG_BT_RFCOMM_TTY=y
 CONFIG_BT_BNEP=m
diff --git a/arch/arm/configs/davinci_all_defconfig b/arch/arm/configs/davinci_all_defconfig
index 889922a..9739ee2 100644
--- a/arch/arm/configs/davinci_all_defconfig
+++ b/arch/arm/configs/davinci_all_defconfig
@@ -152,7 +152,7 @@ CONFIG_MMC=m
 # CONFIG_MMC_BLOCK_BOUNCE is not set
 CONFIG_MMC_DAVINCI=m
 CONFIG_NEW_LEDS=y
-CONFIG_LEDS_CLASS=m
+CONFIG_LEDS_CLASS=y
 CONFIG_LEDS_GPIO=m
 CONFIG_LEDS_TRIGGERS=y
 CONFIG_LEDS_TRIGGER_TIMER=m
diff --git a/arch/arm/configs/em_x270_defconfig b/arch/arm/configs/em_x270_defconfig
index 60a21e0..9910c68 100644
--- a/arch/arm/configs/em_x270_defconfig
+++ b/arch/arm/configs/em_x270_defconfig
@@ -38,8 +38,8 @@ CONFIG_IP_PNP_BOOTP=y
 # CONFIG_INET_DIAG is not set
 # CONFIG_IPV6 is not set
 CONFIG_BT=m
-CONFIG_BT_L2CAP=m
-CONFIG_BT_SCO=m
+CONFIG_BT_L2CAP=y
+CONFIG_BT_SCO=y
 CONFIG_BT_RFCOMM=m
 CONFIG_BT_BNEP=m
 CONFIG_BT_HIDP=m
diff --git a/arch/arm/configs/magician_defconfig b/arch/arm/configs/magician_defconfig
index a88e64d..eef5440 100644
--- a/arch/arm/configs/magician_defconfig
+++ b/arch/arm/configs/magician_defconfig
@@ -48,8 +48,8 @@ CONFIG_IRDA_DEBUG=y
 CONFIG_IRTTY_SIR=m
 CONFIG_PXA_FICP=m
 CONFIG_BT=m
-CONFIG_BT_L2CAP=m
-CONFIG_BT_SCO=m
+CONFIG_BT_L2CAP=y
+CONFIG_BT_SCO=y
 CONFIG_BT_RFCOMM=m
 CONFIG_BT_RFCOMM_TTY=y
 CONFIG_BT_BNEP=m
diff --git a/arch/arm/configs/mini2440_defconfig b/arch/arm/configs/mini2440_defconfig
index 2472a95..a0b5413 100644
--- a/arch/arm/configs/mini2440_defconfig
+++ b/arch/arm/configs/mini2440_defconfig
@@ -56,8 +56,8 @@ CONFIG_VLAN_8021Q=m
 CONFIG_VLAN_8021Q_GVRP=y
 CONFIG_NET_PKTGEN=m
 CONFIG_BT=m
-CONFIG_BT_L2CAP=m
-CONFIG_BT_SCO=m
+CONFIG_BT_L2CAP=y
+CONFIG_BT_SCO=y
 CONFIG_BT_RFCOMM=m
 CONFIG_BT_RFCOMM_TTY=y
 CONFIG_BT_BNEP=m
diff --git a/arch/arm/configs/nhk8815_defconfig b/arch/arm/configs/nhk8815_defconfig
index 37207d1..5129217 100644
--- a/arch/arm/configs/nhk8815_defconfig
+++ b/arch/arm/configs/nhk8815_defconfig
@@ -38,8 +38,8 @@ CONFIG_IP_MROUTE=y
 # CONFIG_INET_LRO is not set
 # CONFIG_IPV6 is not set
 CONFIG_BT=m
-CONFIG_BT_L2CAP=m
-CONFIG_BT_SCO=m
+CONFIG_BT_L2CAP=y
+CONFIG_BT_SCO=y
 CONFIG_BT_RFCOMM=m
 CONFIG_BT_RFCOMM_TTY=y
 CONFIG_BT_BNEP=m
diff --git a/arch/arm/configs/ns9xxx_defconfig b/arch/arm/configs/ns9xxx_defconfig
index 1f528a0..56c20fc 100644
--- a/arch/arm/configs/ns9xxx_defconfig
+++ b/arch/arm/configs/ns9xxx_defconfig
@@ -38,7 +38,7 @@ CONFIG_I2C_GPIO=m
 # CONFIG_VGA_CONSOLE is not set
 # CONFIG_USB_SUPPORT is not set
 CONFIG_NEW_LEDS=y
-CONFIG_LEDS_CLASS=m
+CONFIG_LEDS_CLASS=y
 CONFIG_LEDS_GPIO=m
 CONFIG_LEDS_TRIGGERS=y
 CONFIG_LEDS_TRIGGER_TIMER=m
diff --git a/arch/arm/configs/omap2plus_defconfig b/arch/arm/configs/omap2plus_defconfig
index 076db52..08cc79d 100644
--- a/arch/arm/configs/omap2plus_defconfig
+++ b/arch/arm/configs/omap2plus_defconfig
@@ -89,8 +89,8 @@ CONFIG_IP_PNP_RARP=y
 # CONFIG_IPV6 is not set
 CONFIG_NETFILTER=y
 CONFIG_BT=m
-CONFIG_BT_L2CAP=m
-CONFIG_BT_SCO=m
+CONFIG_BT_L2CAP=y
+CONFIG_BT_SCO=y
 CONFIG_BT_RFCOMM=y
 CONFIG_BT_RFCOMM_TTY=y
 CONFIG_BT_BNEP=m
diff --git a/arch/arm/configs/pxa3xx_defconfig b/arch/arm/configs/pxa3xx_defconfig
index 1677a06..573d882 100644
--- a/arch/arm/configs/pxa3xx_defconfig
+++ b/arch/arm/configs/pxa3xx_defconfig
@@ -99,7 +99,7 @@ CONFIG_LOGO=y
 CONFIG_MMC=y
 CONFIG_MMC_PXA=y
 CONFIG_NEW_LEDS=y
-CONFIG_LEDS_CLASS=m
+CONFIG_LEDS_CLASS=y
 CONFIG_LEDS_GPIO=m
 CONFIG_LEDS_DA903X=m
 CONFIG_LEDS_TRIGGERS=y
diff --git a/arch/arm/configs/s3c2410_defconfig b/arch/arm/configs/s3c2410_defconfig
index f9096c1..3a0cd99 100644
--- a/arch/arm/configs/s3c2410_defconfig
+++ b/arch/arm/configs/s3c2410_defconfig
@@ -177,8 +177,8 @@ CONFIG_IP6_NF_TARGET_REJECT=m
 CONFIG_IP6_NF_MANGLE=m
 CONFIG_IP6_NF_RAW=m
 CONFIG_BT=m
-CONFIG_BT_L2CAP=m
-CONFIG_BT_SCO=m
+CONFIG_BT_L2CAP=y
+CONFIG_BT_SCO=y
 CONFIG_BT_RFCOMM=m
 CONFIG_BT_RFCOMM_TTY=y
 CONFIG_BT_BNEP=m
@@ -387,7 +387,7 @@ CONFIG_MMC_TEST=m
 CONFIG_MMC_SDHCI=m
 CONFIG_MMC_SPI=m
 CONFIG_MMC_S3C=y
-CONFIG_LEDS_CLASS=m
+CONFIG_LEDS_CLASS=y
 CONFIG_LEDS_S3C24XX=m
 CONFIG_LEDS_H1940=m
 CONFIG_LEDS_PCA9532=m
diff --git a/arch/arm/configs/simpad_defconfig b/arch/arm/configs/simpad_defconfig
index d335815..8c6f806 100644
--- a/arch/arm/configs/simpad_defconfig
+++ b/arch/arm/configs/simpad_defconfig
@@ -33,8 +33,8 @@ CONFIG_IRCOMM=m
 CONFIG_IRTTY_SIR=m
 CONFIG_SA1100_FIR=m
 CONFIG_BT=m
-CONFIG_BT_L2CAP=m
-CONFIG_BT_SCO=m
+CONFIG_BT_L2CAP=y
+CONFIG_BT_SCO=y
 CONFIG_BT_RFCOMM=m
 CONFIG_BT_RFCOMM_TTY=y
 CONFIG_BT_BNEP=m
diff --git a/arch/arm/configs/spitz_defconfig b/arch/arm/configs/spitz_defconfig
index 7015827..f0137dd 100644
--- a/arch/arm/configs/spitz_defconfig
+++ b/arch/arm/configs/spitz_defconfig
@@ -66,8 +66,8 @@ CONFIG_IRNET=m
 CONFIG_IRCOMM=m
 CONFIG_PXA_FICP=m
 CONFIG_BT=m
-CONFIG_BT_L2CAP=m
-CONFIG_BT_SCO=m
+CONFIG_BT_L2CAP=y
+CONFIG_BT_SCO=y
 CONFIG_BT_RFCOMM=m
 CONFIG_BT_RFCOMM_TTY=y
 CONFIG_BT_BNEP=m
diff --git a/arch/arm/configs/trizeps4_defconfig b/arch/arm/configs/trizeps4_defconfig
index 3162173..3d6ce92 100644
--- a/arch/arm/configs/trizeps4_defconfig
+++ b/arch/arm/configs/trizeps4_defconfig
@@ -49,8 +49,8 @@ CONFIG_IRDA_CACHE_LAST_LSAP=y
 CONFIG_IRDA_FAST_RR=y
 CONFIG_IRTTY_SIR=m
 CONFIG_BT=m
-CONFIG_BT_L2CAP=m
-CONFIG_BT_SCO=m
+CONFIG_BT_L2CAP=y
+CONFIG_BT_SCO=y
 CONFIG_BT_RFCOMM=m
 CONFIG_BT_RFCOMM_TTY=y
 CONFIG_BT_BNEP=m
diff --git a/arch/arm/configs/viper_defconfig b/arch/arm/configs/viper_defconfig
index 8b0c717..4fe0c80 100644
--- a/arch/arm/configs/viper_defconfig
+++ b/arch/arm/configs/viper_defconfig
@@ -37,7 +37,7 @@ CONFIG_SYN_COOKIES=y
 # CONFIG_INET_LRO is not set
 # CONFIG_IPV6 is not set
 CONFIG_BT=m
-CONFIG_BT_L2CAP=m
+CONFIG_BT_L2CAP=y
 CONFIG_BT_RFCOMM=m
 CONFIG_BT_RFCOMM_TTY=y
 CONFIG_BT_BNEP=m
diff --git a/arch/arm/configs/zeus_defconfig b/arch/arm/configs/zeus_defconfig
index 960f655..f8f9910 100644
--- a/arch/arm/configs/zeus_defconfig
+++ b/arch/arm/configs/zeus_defconfig
@@ -32,7 +32,7 @@ CONFIG_SYN_COOKIES=y
 # CONFIG_INET_LRO is not set
 # CONFIG_IPV6 is not set
 CONFIG_BT=m
-CONFIG_BT_L2CAP=m
+CONFIG_BT_L2CAP=y
 CONFIG_BT_RFCOMM=m
 CONFIG_BT_RFCOMM_TTY=y
 CONFIG_BT_BNEP=m
@@ -150,7 +150,7 @@ CONFIG_MMC=y
 # CONFIG_MMC_BLOCK_BOUNCE is not set
 CONFIG_MMC_PXA=y
 CONFIG_NEW_LEDS=y
-CONFIG_LEDS_CLASS=m
+CONFIG_LEDS_CLASS=y
 CONFIG_LEDS_GPIO=m
 CONFIG_LEDS_TRIGGERS=y
 CONFIG_LEDS_TRIGGER_TIMER=m
diff --git a/arch/avr32/configs/atngw100_mrmt_defconfig b/arch/avr32/configs/atngw100_mrmt_defconfig
index 19f6cee..6f9ed2e 100644
--- a/arch/avr32/configs/atngw100_mrmt_defconfig
+++ b/arch/avr32/configs/atngw100_mrmt_defconfig
@@ -36,7 +36,7 @@ CONFIG_SYN_COOKIES=y
 # CONFIG_INET_LRO is not set
 # CONFIG_IPV6 is not set
 CONFIG_BT=m
-CONFIG_BT_L2CAP=m
+CONFIG_BT_L2CAP=y
 CONFIG_BT_RFCOMM=m
 CONFIG_BT_RFCOMM_TTY=y
 CONFIG_BT_HIDP=m
diff --git a/arch/mips/configs/lemote2f_defconfig b/arch/mips/configs/lemote2f_defconfig
index cb2c5ea..b6acd2f 100644
--- a/arch/mips/configs/lemote2f_defconfig
+++ b/arch/mips/configs/lemote2f_defconfig
@@ -86,8 +86,8 @@ CONFIG_NET_SCHED=y
 CONFIG_NET_EMATCH=y
 CONFIG_NET_CLS_ACT=y
 CONFIG_BT=m
-CONFIG_BT_L2CAP=m
-CONFIG_BT_SCO=m
+CONFIG_BT_L2CAP=y
+CONFIG_BT_SCO=y
 CONFIG_BT_RFCOMM=m
 CONFIG_BT_RFCOMM_TTY=y
 CONFIG_BT_BNEP=m
diff --git a/arch/mips/configs/mtx1_defconfig b/arch/mips/configs/mtx1_defconfig
index a97a42c..37862b2 100644
--- a/arch/mips/configs/mtx1_defconfig
+++ b/arch/mips/configs/mtx1_defconfig
@@ -225,8 +225,8 @@ CONFIG_TOSHIBA_FIR=m
 CONFIG_VLSI_FIR=m
 CONFIG_MCS_FIR=m
 CONFIG_BT=m
-CONFIG_BT_L2CAP=m
-CONFIG_BT_SCO=m
+CONFIG_BT_L2CAP=y
+CONFIG_BT_SCO=y
 CONFIG_BT_RFCOMM=m
 CONFIG_BT_RFCOMM_TTY=y
 CONFIG_BT_BNEP=m
diff --git a/arch/powerpc/configs/c2k_defconfig b/arch/powerpc/configs/c2k_defconfig
index f9e6a3e..2a84fd7 100644
--- a/arch/powerpc/configs/c2k_defconfig
+++ b/arch/powerpc/configs/c2k_defconfig
@@ -132,8 +132,8 @@ CONFIG_NET_CLS_RSVP=m
 CONFIG_NET_CLS_RSVP6=m
 CONFIG_NET_CLS_IND=y
 CONFIG_BT=m
-CONFIG_BT_L2CAP=m
-CONFIG_BT_SCO=m
+CONFIG_BT_L2CAP=y
+CONFIG_BT_SCO=y
 CONFIG_BT_RFCOMM=m
 CONFIG_BT_RFCOMM_TTY=y
 CONFIG_BT_BNEP=m
diff --git a/arch/powerpc/configs/pmac32_defconfig b/arch/powerpc/configs/pmac32_defconfig
index ac4fc41..f8b394a 100644
--- a/arch/powerpc/configs/pmac32_defconfig
+++ b/arch/powerpc/configs/pmac32_defconfig
@@ -112,8 +112,8 @@ CONFIG_IRDA_CACHE_LAST_LSAP=y
 CONFIG_IRDA_FAST_RR=y
 CONFIG_IRTTY_SIR=m
 CONFIG_BT=m
-CONFIG_BT_L2CAP=m
-CONFIG_BT_SCO=m
+CONFIG_BT_L2CAP=y
+CONFIG_BT_SCO=y
 CONFIG_BT_RFCOMM=m
 CONFIG_BT_RFCOMM_TTY=y
 CONFIG_BT_BNEP=m
diff --git a/arch/powerpc/configs/ppc6xx_defconfig b/arch/powerpc/configs/ppc6xx_defconfig
index 0a10fb0..2142089 100644
--- a/arch/powerpc/configs/ppc6xx_defconfig
+++ b/arch/powerpc/configs/ppc6xx_defconfig
@@ -351,8 +351,8 @@ CONFIG_VLSI_FIR=m
 CONFIG_VIA_FIR=m
 CONFIG_MCS_FIR=m
 CONFIG_BT=m
-CONFIG_BT_L2CAP=m
-CONFIG_BT_SCO=m
+CONFIG_BT_L2CAP=y
+CONFIG_BT_SCO=y
 CONFIG_BT_RFCOMM=m
 CONFIG_BT_RFCOMM_TTY=y
 CONFIG_BT_BNEP=m
diff --git a/arch/powerpc/configs/ps3_defconfig b/arch/powerpc/configs/ps3_defconfig
index caba919..6472322 100644
--- a/arch/powerpc/configs/ps3_defconfig
+++ b/arch/powerpc/configs/ps3_defconfig
@@ -52,8 +52,8 @@ CONFIG_IP_PNP_DHCP=y
 # CONFIG_INET_DIAG is not set
 CONFIG_IPV6=y
 CONFIG_BT=m
-CONFIG_BT_L2CAP=m
-CONFIG_BT_SCO=m
+CONFIG_BT_L2CAP=y
+CONFIG_BT_SCO=y
 CONFIG_BT_RFCOMM=m
 CONFIG_BT_RFCOMM_TTY=y
 CONFIG_BT_BNEP=m
-- 
1.7.3

