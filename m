Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753064Ab1LLD3H (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Dec 2011 22:29:07 -0500
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:31752
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752953Ab1LLD2n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Dec 2011 22:28:43 -0500
X-SpamScore: 2
X-BigFish: VS2(zzzz1202hzz8275bhz2ei87h2a8h668h839hb79i)
X-Forefront-Antispam-Report: CIP:137.71.25.55;KIP:(null);UIP:(null);IPV:NLI;H:nwd2mta1.analog.com;RD:nwd2mail10.analog.com;EFVD:NLI
X-FB-DOMAIN-IP-MATCH: fail
From: Bob Liu <lliubbo@gmail.com>
To: <linux-kernel@vger.kernel.org>
CC: <sonic.adi@gmail.com>, <uclinux-dist-devel@blackfin.uclinux.org>,
        <vapier@gentoo.org>, Sonic Zhang <sonic.zhang@analog.com>,
        Bob Liu <lliubbo@gmail.com>
Subject: [PATCH 06/11] blackfin: config: update macro SPI_BFIN in board file
Date: Mon, 12 Dec 2011 11:28:28 +0800
Message-ID: <1323660513-9620-6-git-send-email-lliubbo@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1323660513-9620-1-git-send-email-lliubbo@gmail.com>
References: <1323660513-9620-1-git-send-email-lliubbo@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sonic Zhang <sonic.zhang@analog.com>

Macro name for spi controller driver has been modified, so update default
board file accordingly.

Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
Signed-off-by: Bob Liu <lliubbo@gmail.com>
---
 arch/blackfin/mach-bf518/boards/ezbrd.c      |    8 ++++----
 arch/blackfin/mach-bf518/boards/tcm-bf518.c  |    4 ++--
 arch/blackfin/mach-bf527/boards/ad7160eval.c |    4 ++--
 arch/blackfin/mach-bf527/boards/cm_bf527.c   |    4 ++--
 arch/blackfin/mach-bf527/boards/ezbrd.c      |    4 ++--
 arch/blackfin/mach-bf527/boards/ezkit.c      |    4 ++--
 arch/blackfin/mach-bf527/boards/tll6527m.c   |    4 ++--
 arch/blackfin/mach-bf533/boards/H8606.c      |    6 +++---
 arch/blackfin/mach-bf533/boards/blackstamp.c |    4 ++--
 arch/blackfin/mach-bf533/boards/cm_bf533.c   |    6 +++---
 arch/blackfin/mach-bf533/boards/ezkit.c      |    4 ++--
 arch/blackfin/mach-bf533/boards/ip0x.c       |    4 ++--
 arch/blackfin/mach-bf533/boards/stamp.c      |    4 ++--
 arch/blackfin/mach-bf537/boards/cm_bf537e.c  |    6 +++---
 arch/blackfin/mach-bf537/boards/cm_bf537u.c  |    6 +++---
 arch/blackfin/mach-bf537/boards/dnp5370.c    |    4 ++--
 arch/blackfin/mach-bf537/boards/minotaur.c   |    6 +++---
 arch/blackfin/mach-bf537/boards/pnav10.c     |    6 +++---
 arch/blackfin/mach-bf537/boards/stamp.c      |    4 ++--
 arch/blackfin/mach-bf537/boards/tcm_bf537.c  |    6 +++---
 arch/blackfin/mach-bf538/boards/ezkit.c      |    6 +++---
 arch/blackfin/mach-bf548/boards/cm_bf548.c   |    6 +++---
 arch/blackfin/mach-bf548/boards/ezkit.c      |    4 ++--
 arch/blackfin/mach-bf561/boards/acvilon.c    |    4 ++--
 arch/blackfin/mach-bf561/boards/cm_bf561.c   |    6 +++---
 arch/blackfin/mach-bf561/boards/ezkit.c      |    4 ++--
 26 files changed, 64 insertions(+), 64 deletions(-)

diff --git a/arch/blackfin/mach-bf518/boards/ezbrd.c b/arch/blackfin/mach-bf518/boards/ezbrd.c
index d1c0c0c..c4de8f9 100644
--- a/arch/blackfin/mach-bf518/boards/ezbrd.c
+++ b/arch/blackfin/mach-bf518/boards/ezbrd.c
@@ -61,7 +61,7 @@ static struct physmap_flash_data ezbrd_flash_data = {
 
 static struct resource ezbrd_flash_resource = {
 	.start = 0x20000000,
-#if defined(CONFIG_SPI_BFIN) || defined(CONFIG_SPI_BFIN_MODULE)
+#if defined(CONFIG_SPI_BFIN5XX) || defined(CONFIG_SPI_BFIN5XX_MODULE)
 	.end   = 0x202fffff,
 #else
 	.end   = 0x203fffff,
@@ -292,7 +292,7 @@ static struct spi_board_info bfin_spi_board_info[] __initdata = {
 };
 
 /* SPI controller data */
-#if defined(CONFIG_SPI_BFIN) || defined(CONFIG_SPI_BFIN_MODULE)
+#if defined(CONFIG_SPI_BFIN5XX) || defined(CONFIG_SPI_BFIN5XX_MODULE)
 /* SPI (0) */
 static struct bfin5xx_spi_master bfin_spi0_info = {
 	.num_chipselect = 6,
@@ -715,7 +715,7 @@ static struct platform_device *stamp_devices[] __initdata = {
 #endif
 #endif
 
-#if defined(CONFIG_SPI_BFIN) || defined(CONFIG_SPI_BFIN_MODULE)
+#if defined(CONFIG_SPI_BFIN5XX) || defined(CONFIG_SPI_BFIN5XX_MODULE)
 	&bfin_spi0_device,
 	&bfin_spi1_device,
 #endif
@@ -777,7 +777,7 @@ static int __init ezbrd_init(void)
 	spi_register_board_info(bfin_spi_board_info, ARRAY_SIZE(bfin_spi_board_info));
 	/* setup BF518-EZBRD GPIO pin PG11 to AMS2, PG15 to AMS3. */
 	peripheral_request(P_AMS2, "ParaFlash");
-#if !defined(CONFIG_SPI_BFIN) && !defined(CONFIG_SPI_BFIN_MODULE)
+#if !defined(CONFIG_SPI_BFIN5XX) && !defined(CONFIG_SPI_BFIN5XX_MODULE)
 	peripheral_request(P_AMS3, "ParaFlash");
 #endif
 	return 0;
diff --git a/arch/blackfin/mach-bf518/boards/tcm-bf518.c b/arch/blackfin/mach-bf518/boards/tcm-bf518.c
index 5470bf8..f271310 100644
--- a/arch/blackfin/mach-bf518/boards/tcm-bf518.c
+++ b/arch/blackfin/mach-bf518/boards/tcm-bf518.c
@@ -228,7 +228,7 @@ static struct spi_board_info bfin_spi_board_info[] __initdata = {
 };
 
 /* SPI controller data */
-#if defined(CONFIG_SPI_BFIN) || defined(CONFIG_SPI_BFIN_MODULE)
+#if defined(CONFIG_SPI_BFIN5XX) || defined(CONFIG_SPI_BFIN5XX_MODULE)
 /* SPI (0) */
 static struct bfin5xx_spi_master bfin_spi0_info = {
 	.num_chipselect = 6,
@@ -635,7 +635,7 @@ static struct platform_device *tcm_devices[] __initdata = {
 	&bfin_mac_device,
 #endif
 
-#if defined(CONFIG_SPI_BFIN) || defined(CONFIG_SPI_BFIN_MODULE)
+#if defined(CONFIG_SPI_BFIN5XX) || defined(CONFIG_SPI_BFIN5XX_MODULE)
 	&bfin_spi0_device,
 	&bfin_spi1_device,
 #endif
diff --git a/arch/blackfin/mach-bf527/boards/ad7160eval.c b/arch/blackfin/mach-bf527/boards/ad7160eval.c
index 5bc6938..c8d5d2b 100644
--- a/arch/blackfin/mach-bf527/boards/ad7160eval.c
+++ b/arch/blackfin/mach-bf527/boards/ad7160eval.c
@@ -334,7 +334,7 @@ static struct spi_board_info bfin_spi_board_info[] __initdata = {
 #endif
 };
 
-#if defined(CONFIG_SPI_BFIN) || defined(CONFIG_SPI_BFIN_MODULE)
+#if defined(CONFIG_SPI_BFIN5XX) || defined(CONFIG_SPI_BFIN5XX_MODULE)
 /* SPI controller data */
 static struct bfin5xx_spi_master bfin_spi0_info = {
 	.num_chipselect = MAX_CTRL_CS + MAX_BLACKFIN_GPIOS,
@@ -744,7 +744,7 @@ static struct platform_device *stamp_devices[] __initdata = {
 	&bfin_mac_device,
 #endif
 
-#if defined(CONFIG_SPI_BFIN) || defined(CONFIG_SPI_BFIN_MODULE)
+#if defined(CONFIG_SPI_BFIN5XX) || defined(CONFIG_SPI_BFIN5XX_MODULE)
 	&bfin_spi0_device,
 #endif
 
diff --git a/arch/blackfin/mach-bf527/boards/cm_bf527.c b/arch/blackfin/mach-bf527/boards/cm_bf527.c
index cd28969..7330607 100644
--- a/arch/blackfin/mach-bf527/boards/cm_bf527.c
+++ b/arch/blackfin/mach-bf527/boards/cm_bf527.c
@@ -444,7 +444,7 @@ static struct spi_board_info bfin_spi_board_info[] __initdata = {
 #endif
 };
 
-#if defined(CONFIG_SPI_BFIN) || defined(CONFIG_SPI_BFIN_MODULE)
+#if defined(CONFIG_SPI_BFIN5XX) || defined(CONFIG_SPI_BFIN5XX_MODULE)
 /* SPI controller data */
 static struct bfin5xx_spi_master bfin_spi0_info = {
 	.num_chipselect = 8,
@@ -893,7 +893,7 @@ static struct platform_device *cmbf527_devices[] __initdata = {
 	&net2272_bfin_device,
 #endif
 
-#if defined(CONFIG_SPI_BFIN) || defined(CONFIG_SPI_BFIN_MODULE)
+#if defined(CONFIG_SPI_BFIN5XX) || defined(CONFIG_SPI_BFIN5XX_MODULE)
 	&bfin_spi0_device,
 #endif
 
diff --git a/arch/blackfin/mach-bf527/boards/ezbrd.c b/arch/blackfin/mach-bf527/boards/ezbrd.c
index 9f792ea..db3ecfc 100644
--- a/arch/blackfin/mach-bf527/boards/ezbrd.c
+++ b/arch/blackfin/mach-bf527/boards/ezbrd.c
@@ -371,7 +371,7 @@ static struct spi_board_info bfin_spi_board_info[] __initdata = {
 #endif
 };
 
-#if defined(CONFIG_SPI_BFIN) || defined(CONFIG_SPI_BFIN_MODULE)
+#if defined(CONFIG_SPI_BFIN5XX) || defined(CONFIG_SPI_BFIN5XX_MODULE)
 /* SPI controller data */
 static struct bfin5xx_spi_master bfin_spi0_info = {
 	.num_chipselect = 8,
@@ -776,7 +776,7 @@ static struct platform_device *stamp_devices[] __initdata = {
 	&bfin_mac_device,
 #endif
 
-#if defined(CONFIG_SPI_BFIN) || defined(CONFIG_SPI_BFIN_MODULE)
+#if defined(CONFIG_SPI_BFIN5XX) || defined(CONFIG_SPI_BFIN5XX_MODULE)
 	&bfin_spi0_device,
 #endif
 
diff --git a/arch/blackfin/mach-bf527/boards/ezkit.c b/arch/blackfin/mach-bf527/boards/ezkit.c
index 3ecafff..dfdd8e6 100644
--- a/arch/blackfin/mach-bf527/boards/ezkit.c
+++ b/arch/blackfin/mach-bf527/boards/ezkit.c
@@ -664,7 +664,7 @@ static struct spi_board_info bfin_spi_board_info[] __initdata = {
 #endif
 };
 
-#if defined(CONFIG_SPI_BFIN) || defined(CONFIG_SPI_BFIN_MODULE)
+#if defined(CONFIG_SPI_BFIN5XX) || defined(CONFIG_SPI_BFIN5XX_MODULE)
 /* SPI controller data */
 static struct bfin5xx_spi_master bfin_spi0_info = {
 	.num_chipselect = 8,
@@ -1189,7 +1189,7 @@ static struct platform_device *stamp_devices[] __initdata = {
 	&net2272_bfin_device,
 #endif
 
-#if defined(CONFIG_SPI_BFIN) || defined(CONFIG_SPI_BFIN_MODULE)
+#if defined(CONFIG_SPI_BFIN5XX) || defined(CONFIG_SPI_BFIN5XX_MODULE)
 	&bfin_spi0_device,
 #endif
 
diff --git a/arch/blackfin/mach-bf527/boards/tll6527m.c b/arch/blackfin/mach-bf527/boards/tll6527m.c
index 3a92c43..360e97f 100644
--- a/arch/blackfin/mach-bf527/boards/tll6527m.c
+++ b/arch/blackfin/mach-bf527/boards/tll6527m.c
@@ -448,7 +448,7 @@ static struct spi_board_info bfin_spi_board_info[] __initdata = {
 #endif
 };
 
-#if defined(CONFIG_SPI_BFIN) || defined(CONFIG_SPI_BFIN_MODULE)
+#if defined(CONFIG_SPI_BFIN5XX) || defined(CONFIG_SPI_BFIN5XX_MODULE)
 /* SPI controller data */
 static struct bfin5xx_spi_master bfin_spi0_info = {
 	.num_chipselect = EXP_GPIO_SPISEL_BASE + 8 + MAX_CTRL_CS,
@@ -831,7 +831,7 @@ static struct platform_device *tll6527m_devices[] __initdata = {
 	&bfin_mac_device,
 #endif
 
-#if defined(CONFIG_SPI_BFIN) || defined(CONFIG_SPI_BFIN_MODULE)
+#if defined(CONFIG_SPI_BFIN5XX) || defined(CONFIG_SPI_BFIN5XX_MODULE)
 	&bfin_spi0_device,
 #endif
 
diff --git a/arch/blackfin/mach-bf533/boards/H8606.c b/arch/blackfin/mach-bf533/boards/H8606.c
index 47cadd3..6cb7b3e 100644
--- a/arch/blackfin/mach-bf533/boards/H8606.c
+++ b/arch/blackfin/mach-bf533/boards/H8606.c
@@ -125,7 +125,7 @@ static struct platform_device net2272_bfin_device = {
 };
 #endif
 
-#if defined(CONFIG_SPI_BFIN) || defined(CONFIG_SPI_BFIN_MODULE)
+#if defined(CONFIG_SPI_BFIN5XX) || defined(CONFIG_SPI_BFIN5XX_MODULE)
 /* all SPI peripherals info goes here */
 
 #if defined(CONFIG_MTD_M25P80) || defined(CONFIG_MTD_M25P80_MODULE)
@@ -398,7 +398,7 @@ static struct platform_device *h8606_devices[] __initdata = {
 	&net2272_bfin_device,
 #endif
 
-#if defined(CONFIG_SPI_BFIN) || defined(CONFIG_SPI_BFIN_MODULE)
+#if defined(CONFIG_SPI_BFIN5XX) || defined(CONFIG_SPI_BFIN5XX_MODULE)
 	&bfin_spi0_device,
 #endif
 
@@ -428,7 +428,7 @@ static int __init H8606_init(void)
 	printk(KERN_INFO "HV Sistemas H8606 board support by http://www.hvsistemas.com\n");
 	printk(KERN_INFO "%s(): registering device resources\n", __func__);
 	platform_add_devices(h8606_devices, ARRAY_SIZE(h8606_devices));
-#if defined(CONFIG_SPI_BFIN) || defined(CONFIG_SPI_BFIN_MODULE)
+#if defined(CONFIG_SPI_BFIN5XX) || defined(CONFIG_SPI_BFIN5XX_MODULE)
 	spi_register_board_info(bfin_spi_board_info, ARRAY_SIZE(bfin_spi_board_info));
 #endif
 	return 0;
diff --git a/arch/blackfin/mach-bf533/boards/blackstamp.c b/arch/blackfin/mach-bf533/boards/blackstamp.c
index 18817d5..de44a37 100644
--- a/arch/blackfin/mach-bf533/boards/blackstamp.c
+++ b/arch/blackfin/mach-bf533/boards/blackstamp.c
@@ -146,7 +146,7 @@ static struct spi_board_info bfin_spi_board_info[] __initdata = {
 #endif
 };
 
-#if defined(CONFIG_SPI_BFIN) || defined(CONFIG_SPI_BFIN_MODULE)
+#if defined(CONFIG_SPI_BFIN5XX) || defined(CONFIG_SPI_BFIN5XX_MODULE)
 /* SPI (0) */
 static struct resource bfin_spi0_resource[] = {
 	[0] = {
@@ -422,7 +422,7 @@ static struct platform_device *stamp_devices[] __initdata = {
 #endif
 
 
-#if defined(CONFIG_SPI_BFIN) || defined(CONFIG_SPI_BFIN_MODULE)
+#if defined(CONFIG_SPI_BFIN5XX) || defined(CONFIG_SPI_BFIN5XX_MODULE)
 	&bfin_spi0_device,
 #endif
 
diff --git a/arch/blackfin/mach-bf533/boards/cm_bf533.c b/arch/blackfin/mach-bf533/boards/cm_bf533.c
index 2c8f30e..fe47e04 100644
--- a/arch/blackfin/mach-bf533/boards/cm_bf533.c
+++ b/arch/blackfin/mach-bf533/boards/cm_bf533.c
@@ -29,7 +29,7 @@
  */
 const char bfin_board_name[] = "Bluetechnix CM BF533";
 
-#if defined(CONFIG_SPI_BFIN) || defined(CONFIG_SPI_BFIN_MODULE)
+#if defined(CONFIG_SPI_BFIN5XX) || defined(CONFIG_SPI_BFIN5XX_MODULE)
 /* all SPI peripherals info goes here */
 #if defined(CONFIG_MTD_M25P80) || defined(CONFIG_MTD_M25P80_MODULE)
 static struct mtd_partition bfin_spi_flash_partitions[] = {
@@ -536,7 +536,7 @@ static struct platform_device *cm_bf533_devices[] __initdata = {
 	&net2272_bfin_device,
 #endif
 
-#if defined(CONFIG_SPI_BFIN) || defined(CONFIG_SPI_BFIN_MODULE)
+#if defined(CONFIG_SPI_BFIN5XX) || defined(CONFIG_SPI_BFIN5XX_MODULE)
 	&bfin_spi0_device,
 #endif
 
@@ -549,7 +549,7 @@ static int __init cm_bf533_init(void)
 {
 	printk(KERN_INFO "%s(): registering device resources\n", __func__);
 	platform_add_devices(cm_bf533_devices, ARRAY_SIZE(cm_bf533_devices));
-#if defined(CONFIG_SPI_BFIN) || defined(CONFIG_SPI_BFIN_MODULE)
+#if defined(CONFIG_SPI_BFIN5XX) || defined(CONFIG_SPI_BFIN5XX_MODULE)
 	spi_register_board_info(bfin_spi_board_info, ARRAY_SIZE(bfin_spi_board_info));
 #endif
 	return 0;
diff --git a/arch/blackfin/mach-bf533/boards/ezkit.c b/arch/blackfin/mach-bf533/boards/ezkit.c
index 144556e..07811c2 100644
--- a/arch/blackfin/mach-bf533/boards/ezkit.c
+++ b/arch/blackfin/mach-bf533/boards/ezkit.c
@@ -245,7 +245,7 @@ static struct spi_board_info bfin_spi_board_info[] __initdata = {
 #endif
 };
 
-#if defined(CONFIG_SPI_BFIN) || defined(CONFIG_SPI_BFIN_MODULE)
+#if defined(CONFIG_SPI_BFIN5XX) || defined(CONFIG_SPI_BFIN5XX_MODULE)
 /* SPI (0) */
 static struct resource bfin_spi0_resource[] = {
 	[0] = {
@@ -484,7 +484,7 @@ static struct platform_device *ezkit_devices[] __initdata = {
 	&smc91x_device,
 #endif
 
-#if defined(CONFIG_SPI_BFIN) || defined(CONFIG_SPI_BFIN_MODULE)
+#if defined(CONFIG_SPI_BFIN5XX) || defined(CONFIG_SPI_BFIN5XX_MODULE)
 	&bfin_spi0_device,
 #endif
 
diff --git a/arch/blackfin/mach-bf533/boards/ip0x.c b/arch/blackfin/mach-bf533/boards/ip0x.c
index b597d4e..e303dae 100644
--- a/arch/blackfin/mach-bf533/boards/ip0x.c
+++ b/arch/blackfin/mach-bf533/boards/ip0x.c
@@ -104,7 +104,7 @@ static struct platform_device dm9000_device2 = {
 #endif
 
 
-#if defined(CONFIG_SPI_BFIN) || defined(CONFIG_SPI_BFIN_MODULE)
+#if defined(CONFIG_SPI_BFIN5XX) || defined(CONFIG_SPI_BFIN5XX_MODULE)
 /* all SPI peripherals info goes here */
 
 #if defined(CONFIG_MMC_SPI) || defined(CONFIG_MMC_SPI_MODULE)
@@ -270,7 +270,7 @@ static struct platform_device *ip0x_devices[] __initdata = {
 #endif
 #endif
 
-#if defined(CONFIG_SPI_BFIN) || defined(CONFIG_SPI_BFIN_MODULE)
+#if defined(CONFIG_SPI_BFIN5XX) || defined(CONFIG_SPI_BFIN5XX_MODULE)
 	&spi_bfin_master_device,
 #endif
 
diff --git a/arch/blackfin/mach-bf533/boards/stamp.c b/arch/blackfin/mach-bf533/boards/stamp.c
index 2ba4d0b..edd057d 100644
--- a/arch/blackfin/mach-bf533/boards/stamp.c
+++ b/arch/blackfin/mach-bf533/boards/stamp.c
@@ -252,7 +252,7 @@ static struct spi_board_info bfin_spi_board_info[] __initdata = {
 #endif
 };
 
-#if defined(CONFIG_SPI_BFIN) || defined(CONFIG_SPI_BFIN_MODULE)
+#if defined(CONFIG_SPI_BFIN5XX) || defined(CONFIG_SPI_BFIN5XX_MODULE)
 /* SPI (0) */
 static struct resource bfin_spi0_resource[] = {
 	[0] = {
@@ -704,7 +704,7 @@ static struct platform_device *stamp_devices[] __initdata = {
 	&net2272_bfin_device,
 #endif
 
-#if defined(CONFIG_SPI_BFIN) || defined(CONFIG_SPI_BFIN_MODULE)
+#if defined(CONFIG_SPI_BFIN5XX) || defined(CONFIG_SPI_BFIN5XX_MODULE)
 	&bfin_spi0_device,
 #endif
 
diff --git a/arch/blackfin/mach-bf537/boards/cm_bf537e.c b/arch/blackfin/mach-bf537/boards/cm_bf537e.c
index 604a430..0d4a2f6 100644
--- a/arch/blackfin/mach-bf537/boards/cm_bf537e.c
+++ b/arch/blackfin/mach-bf537/boards/cm_bf537e.c
@@ -31,7 +31,7 @@
  */
 const char bfin_board_name[] = "Bluetechnix CM BF537E";
 
-#if defined(CONFIG_SPI_BFIN) || defined(CONFIG_SPI_BFIN_MODULE)
+#if defined(CONFIG_SPI_BFIN5XX) || defined(CONFIG_SPI_BFIN5XX_MODULE)
 /* all SPI peripherals info goes here */
 
 #if defined(CONFIG_MTD_M25P80) || defined(CONFIG_MTD_M25P80_MODULE)
@@ -735,7 +735,7 @@ static struct platform_device *cm_bf537e_devices[] __initdata = {
 	&net2272_bfin_device,
 #endif
 
-#if defined(CONFIG_SPI_BFIN) || defined(CONFIG_SPI_BFIN_MODULE)
+#if defined(CONFIG_SPI_BFIN5XX) || defined(CONFIG_SPI_BFIN5XX_MODULE)
 	&bfin_spi0_device,
 #endif
 
@@ -770,7 +770,7 @@ static int __init cm_bf537e_init(void)
 {
 	printk(KERN_INFO "%s(): registering device resources\n", __func__);
 	platform_add_devices(cm_bf537e_devices, ARRAY_SIZE(cm_bf537e_devices));
-#if defined(CONFIG_SPI_BFIN) || defined(CONFIG_SPI_BFIN_MODULE)
+#if defined(CONFIG_SPI_BFIN5XX) || defined(CONFIG_SPI_BFIN5XX_MODULE)
 	spi_register_board_info(bfin_spi_board_info, ARRAY_SIZE(bfin_spi_board_info));
 #endif
 
diff --git a/arch/blackfin/mach-bf537/boards/cm_bf537u.c b/arch/blackfin/mach-bf537/boards/cm_bf537u.c
index d916b46..f553698 100644
--- a/arch/blackfin/mach-bf537/boards/cm_bf537u.c
+++ b/arch/blackfin/mach-bf537/boards/cm_bf537u.c
@@ -32,7 +32,7 @@
  */
 const char bfin_board_name[] = "Bluetechnix CM BF537U";
 
-#if defined(CONFIG_SPI_BFIN) || defined(CONFIG_SPI_BFIN_MODULE)
+#if defined(CONFIG_SPI_BFIN5XX) || defined(CONFIG_SPI_BFIN5XX_MODULE)
 /* all SPI peripherals info goes here */
 
 #if defined(CONFIG_MTD_M25P80) || defined(CONFIG_MTD_M25P80_MODULE)
@@ -700,7 +700,7 @@ static struct platform_device *cm_bf537u_devices[] __initdata = {
 	&net2272_bfin_device,
 #endif
 
-#if defined(CONFIG_SPI_BFIN) || defined(CONFIG_SPI_BFIN_MODULE)
+#if defined(CONFIG_SPI_BFIN5XX) || defined(CONFIG_SPI_BFIN5XX_MODULE)
 	&bfin_spi0_device,
 #endif
 
@@ -747,7 +747,7 @@ static int __init cm_bf537u_init(void)
 {
 	printk(KERN_INFO "%s(): registering device resources\n", __func__);
 	platform_add_devices(cm_bf537u_devices, ARRAY_SIZE(cm_bf537u_devices));
-#if defined(CONFIG_SPI_BFIN) || defined(CONFIG_SPI_BFIN_MODULE)
+#if defined(CONFIG_SPI_BFIN5XX) || defined(CONFIG_SPI_BFIN5XX_MODULE)
 	spi_register_board_info(bfin_spi_board_info, ARRAY_SIZE(bfin_spi_board_info));
 #endif
 
diff --git a/arch/blackfin/mach-bf537/boards/dnp5370.c b/arch/blackfin/mach-bf537/boards/dnp5370.c
index 5f30722..11dadeb 100644
--- a/arch/blackfin/mach-bf537/boards/dnp5370.c
+++ b/arch/blackfin/mach-bf537/boards/dnp5370.c
@@ -125,7 +125,7 @@ static struct platform_device asmb_flash_device = {
 };
 #endif
 
-#if defined(CONFIG_SPI_BFIN) || defined(CONFIG_SPI_BFIN_MODULE)
+#if defined(CONFIG_SPI_BFIN5XX) || defined(CONFIG_SPI_BFIN5XX_MODULE)
 
 #if defined(CONFIG_MMC_SPI) || defined(CONFIG_MMC_SPI_MODULE)
 
@@ -370,7 +370,7 @@ static struct platform_device *dnp5370_devices[] __initdata = {
 	&bfin_mac_device,
 #endif
 
-#if defined(CONFIG_SPI_BFIN) || defined(CONFIG_SPI_BFIN_MODULE)
+#if defined(CONFIG_SPI_BFIN5XX) || defined(CONFIG_SPI_BFIN5XX_MODULE)
 	&spi_bfin_master_device,
 #endif
 
diff --git a/arch/blackfin/mach-bf537/boards/minotaur.c b/arch/blackfin/mach-bf537/boards/minotaur.c
index 3901dd0..d2d7128 100644
--- a/arch/blackfin/mach-bf537/boards/minotaur.c
+++ b/arch/blackfin/mach-bf537/boards/minotaur.c
@@ -121,7 +121,7 @@ static struct platform_device net2272_bfin_device = {
 };
 #endif
 
-#if defined(CONFIG_SPI_BFIN) || defined(CONFIG_SPI_BFIN_MODULE)
+#if defined(CONFIG_SPI_BFIN5XX) || defined(CONFIG_SPI_BFIN5XX_MODULE)
 /* all SPI peripherals info goes here */
 
 #if defined(CONFIG_MTD_M25P80) \
@@ -496,7 +496,7 @@ static struct platform_device *minotaur_devices[] __initdata = {
 	&net2272_bfin_device,
 #endif
 
-#if defined(CONFIG_SPI_BFIN) || defined(CONFIG_SPI_BFIN_MODULE)
+#if defined(CONFIG_SPI_BFIN5XX) || defined(CONFIG_SPI_BFIN5XX_MODULE)
 	&bfin_spi0_device,
 #endif
 
@@ -537,7 +537,7 @@ static int __init minotaur_init(void)
 {
 	printk(KERN_INFO "%s(): registering device resources\n", __func__);
 	platform_add_devices(minotaur_devices, ARRAY_SIZE(minotaur_devices));
-#if defined(CONFIG_SPI_BFIN) || defined(CONFIG_SPI_BFIN_MODULE)
+#if defined(CONFIG_SPI_BFIN5XX) || defined(CONFIG_SPI_BFIN5XX_MODULE)
 	spi_register_board_info(bfin_spi_board_info,
 				ARRAY_SIZE(bfin_spi_board_info));
 #endif
diff --git a/arch/blackfin/mach-bf537/boards/pnav10.c b/arch/blackfin/mach-bf537/boards/pnav10.c
index aebd31c..6fd8470 100644
--- a/arch/blackfin/mach-bf537/boards/pnav10.c
+++ b/arch/blackfin/mach-bf537/boards/pnav10.c
@@ -154,7 +154,7 @@ static struct platform_device net2272_bfin_device = {
 };
 #endif
 
-#if defined(CONFIG_SPI_BFIN) || defined(CONFIG_SPI_BFIN_MODULE)
+#if defined(CONFIG_SPI_BFIN5XX) || defined(CONFIG_SPI_BFIN5XX_MODULE)
 /* all SPI peripherals info goes here */
 
 #if defined(CONFIG_MTD_M25P80) \
@@ -477,7 +477,7 @@ static struct platform_device *stamp_devices[] __initdata = {
 	&net2272_bfin_device,
 #endif
 
-#if defined(CONFIG_SPI_BFIN) || defined(CONFIG_SPI_BFIN_MODULE)
+#if defined(CONFIG_SPI_BFIN5XX) || defined(CONFIG_SPI_BFIN5XX_MODULE)
 	&bfin_spi0_device,
 #endif
 
@@ -508,7 +508,7 @@ static int __init pnav_init(void)
 {
 	printk(KERN_INFO "%s(): registering device resources\n", __func__);
 	platform_add_devices(stamp_devices, ARRAY_SIZE(stamp_devices));
-#if defined(CONFIG_SPI_BFIN) || defined(CONFIG_SPI_BFIN_MODULE)
+#if defined(CONFIG_SPI_BFIN5XX) || defined(CONFIG_SPI_BFIN5XX_MODULE)
 	spi_register_board_info(bfin_spi_board_info,
 				ARRAY_SIZE(bfin_spi_board_info));
 #endif
diff --git a/arch/blackfin/mach-bf537/boards/stamp.c b/arch/blackfin/mach-bf537/boards/stamp.c
index 7fbb0bb..c59d21f 100644
--- a/arch/blackfin/mach-bf537/boards/stamp.c
+++ b/arch/blackfin/mach-bf537/boards/stamp.c
@@ -1420,7 +1420,7 @@ static struct spi_board_info bfin_spi_board_info[] __initdata = {
 #endif
 };
 
-#if defined(CONFIG_SPI_BFIN) || defined(CONFIG_SPI_BFIN_MODULE)
+#if defined(CONFIG_SPI_BFIN5XX) || defined(CONFIG_SPI_BFIN5XX_MODULE)
 /* SPI controller data */
 static struct bfin5xx_spi_master bfin_spi0_info = {
 	.num_chipselect = MAX_CTRL_CS + MAX_BLACKFIN_GPIOS,
@@ -2716,7 +2716,7 @@ static struct platform_device *stamp_devices[] __initdata = {
 	&net2272_bfin_device,
 #endif
 
-#if defined(CONFIG_SPI_BFIN) || defined(CONFIG_SPI_BFIN_MODULE)
+#if defined(CONFIG_SPI_BFIN5XX) || defined(CONFIG_SPI_BFIN5XX_MODULE)
 	&bfin_spi0_device,
 #endif
 
diff --git a/arch/blackfin/mach-bf537/boards/tcm_bf537.c b/arch/blackfin/mach-bf537/boards/tcm_bf537.c
index 6917ce2..9885176 100644
--- a/arch/blackfin/mach-bf537/boards/tcm_bf537.c
+++ b/arch/blackfin/mach-bf537/boards/tcm_bf537.c
@@ -32,7 +32,7 @@
  */
 const char bfin_board_name[] = "Bluetechnix TCM BF537";
 
-#if defined(CONFIG_SPI_BFIN) || defined(CONFIG_SPI_BFIN_MODULE)
+#if defined(CONFIG_SPI_BFIN5XX) || defined(CONFIG_SPI_BFIN5XX_MODULE)
 /* all SPI peripherals info goes here */
 
 #if defined(CONFIG_MTD_M25P80) || defined(CONFIG_MTD_M25P80_MODULE)
@@ -702,7 +702,7 @@ static struct platform_device *cm_bf537_devices[] __initdata = {
 	&net2272_bfin_device,
 #endif
 
-#if defined(CONFIG_SPI_BFIN) || defined(CONFIG_SPI_BFIN_MODULE)
+#if defined(CONFIG_SPI_BFIN5XX) || defined(CONFIG_SPI_BFIN5XX_MODULE)
 	&bfin_spi0_device,
 #endif
 
@@ -737,7 +737,7 @@ static int __init tcm_bf537_init(void)
 {
 	printk(KERN_INFO "%s(): registering device resources\n", __func__);
 	platform_add_devices(cm_bf537_devices, ARRAY_SIZE(cm_bf537_devices));
-#if defined(CONFIG_SPI_BFIN) || defined(CONFIG_SPI_BFIN_MODULE)
+#if defined(CONFIG_SPI_BFIN5XX) || defined(CONFIG_SPI_BFIN5XX_MODULE)
 	spi_register_board_info(bfin_spi_board_info, ARRAY_SIZE(bfin_spi_board_info));
 #endif
 
diff --git a/arch/blackfin/mach-bf538/boards/ezkit.c b/arch/blackfin/mach-bf538/boards/ezkit.c
index 8356eb5..1633a6f 100644
--- a/arch/blackfin/mach-bf538/boards/ezkit.c
+++ b/arch/blackfin/mach-bf538/boards/ezkit.c
@@ -490,7 +490,7 @@ static struct platform_device smc91x_device = {
 };
 #endif
 
-#if defined(CONFIG_SPI_BFIN) || defined(CONFIG_SPI_BFIN_MODULE)
+#if defined(CONFIG_SPI_BFIN5XX) || defined(CONFIG_SPI_BFIN5XX_MODULE)
 /* all SPI peripherals info goes here */
 #if defined(CONFIG_MTD_M25P80) \
 	|| defined(CONFIG_MTD_M25P80_MODULE)
@@ -874,7 +874,7 @@ static struct platform_device *cm_bf538_devices[] __initdata = {
 #endif
 #endif
 
-#if defined(CONFIG_SPI_BFIN) || defined(CONFIG_SPI_BFIN_MODULE)
+#if defined(CONFIG_SPI_BFIN5XX) || defined(CONFIG_SPI_BFIN5XX_MODULE)
 	&bf538_spi_master0,
 	&bf538_spi_master1,
 	&bf538_spi_master2,
@@ -938,7 +938,7 @@ static int __init ezkit_init(void)
 	printk(KERN_INFO "%s(): registering device resources\n", __func__);
 	platform_add_devices(cm_bf538_devices, ARRAY_SIZE(cm_bf538_devices));
 
-#if defined(CONFIG_SPI_BFIN) || defined(CONFIG_SPI_BFIN_MODULE)
+#if defined(CONFIG_SPI_BFIN5XX) || defined(CONFIG_SPI_BFIN5XX_MODULE)
 	spi_register_board_info(bf538_spi_board_info,
 			ARRAY_SIZE(bf538_spi_board_info));
 #endif
diff --git a/arch/blackfin/mach-bf548/boards/cm_bf548.c b/arch/blackfin/mach-bf548/boards/cm_bf548.c
index 0350eac..68af594 100644
--- a/arch/blackfin/mach-bf548/boards/cm_bf548.c
+++ b/arch/blackfin/mach-bf548/boards/cm_bf548.c
@@ -854,7 +854,7 @@ static struct platform_device para_flash_device = {
 };
 #endif
 
-#if defined(CONFIG_SPI_BFIN) || defined(CONFIG_SPI_BFIN_MODULE)
+#if defined(CONFIG_SPI_BFIN5XX) || defined(CONFIG_SPI_BFIN5XX_MODULE)
 /* all SPI peripherals info goes here */
 #if defined(CONFIG_MTD_M25P80) \
 	|| defined(CONFIG_MTD_M25P80_MODULE)
@@ -1175,7 +1175,7 @@ static struct platform_device *cm_bf548_devices[] __initdata = {
 	&bf54x_sdh_device,
 #endif
 
-#if defined(CONFIG_SPI_BFIN) || defined(CONFIG_SPI_BFIN_MODULE)
+#if defined(CONFIG_SPI_BFIN5XX) || defined(CONFIG_SPI_BFIN5XX_MODULE)
 	&bf54x_spi_master0,
 	&bf54x_spi_master1,
 #endif
@@ -1210,7 +1210,7 @@ static int __init cm_bf548_init(void)
 	printk(KERN_INFO "%s(): registering device resources\n", __func__);
 	platform_add_devices(cm_bf548_devices, ARRAY_SIZE(cm_bf548_devices));
 
-#if defined(CONFIG_SPI_BFIN) || defined(CONFIG_SPI_BFIN_MODULE)
+#if defined(CONFIG_SPI_BFIN5XX) || defined(CONFIG_SPI_BFIN5XX_MODULE)
 	spi_register_board_info(bf54x_spi_board_info,
 			ARRAY_SIZE(bf54x_spi_board_info));
 #endif
diff --git a/arch/blackfin/mach-bf548/boards/ezkit.c b/arch/blackfin/mach-bf548/boards/ezkit.c
index bb868ac..5ea6eca 100644
--- a/arch/blackfin/mach-bf548/boards/ezkit.c
+++ b/arch/blackfin/mach-bf548/boards/ezkit.c
@@ -1110,7 +1110,7 @@ static struct spi_board_info bfin_spi_board_info[] __initdata = {
 	},
 #endif
 };
-#if defined(CONFIG_SPI_BFIN) || defined(CONFIG_SPI_BFIN_MODULE)
+#if defined(CONFIG_SPI_BFIN5XX) || defined(CONFIG_SPI_BFIN5XX_MODULE)
 /* SPI (0) */
 static struct resource bfin_spi0_resource[] = {
 	[0] = {
@@ -1502,7 +1502,7 @@ static struct platform_device *ezkit_devices[] __initdata = {
 	&bf54x_sdh_device,
 #endif
 
-#if defined(CONFIG_SPI_BFIN) || defined(CONFIG_SPI_BFIN_MODULE)
+#if defined(CONFIG_SPI_BFIN5XX) || defined(CONFIG_SPI_BFIN5XX_MODULE)
 	&bf54x_spi_master0,
 	&bf54x_spi_master1,
 #endif
diff --git a/arch/blackfin/mach-bf561/boards/acvilon.c b/arch/blackfin/mach-bf561/boards/acvilon.c
index b1b7339..f6ffd6f 100644
--- a/arch/blackfin/mach-bf561/boards/acvilon.c
+++ b/arch/blackfin/mach-bf561/boards/acvilon.c
@@ -372,7 +372,7 @@ static struct bfin5xx_spi_chip data_flash_chip_info = {
 };
 #endif
 
-#if defined(CONFIG_SPI_BFIN) || defined(CONFIG_SPI_BFIN_MODULE)
+#if defined(CONFIG_SPI_BFIN5XX) || defined(CONFIG_SPI_BFIN5XX_MODULE)
 /* SPI (0) */
 static struct resource bfin_spi0_resource[] = {
 	[0] = {
@@ -475,7 +475,7 @@ static struct platform_device bfin_dpmc = {
 static struct platform_device *acvilon_devices[] __initdata = {
 	&bfin_dpmc,
 
-#if defined(CONFIG_SPI_BFIN) || defined(CONFIG_SPI_BFIN_MODULE)
+#if defined(CONFIG_SPI_BFIN5XX) || defined(CONFIG_SPI_BFIN5XX_MODULE)
 	&bfin_spi0_device,
 #endif
 
diff --git a/arch/blackfin/mach-bf561/boards/cm_bf561.c b/arch/blackfin/mach-bf561/boards/cm_bf561.c
index c017cf0..d81450f 100644
--- a/arch/blackfin/mach-bf561/boards/cm_bf561.c
+++ b/arch/blackfin/mach-bf561/boards/cm_bf561.c
@@ -29,7 +29,7 @@
  */
 const char bfin_board_name[] = "Bluetechnix CM BF561";
 
-#if defined(CONFIG_SPI_BFIN) || defined(CONFIG_SPI_BFIN_MODULE)
+#if defined(CONFIG_SPI_BFIN5XX) || defined(CONFIG_SPI_BFIN5XX_MODULE)
 /* all SPI peripherals info goes here */
 
 #if defined(CONFIG_MTD_M25P80) || defined(CONFIG_MTD_M25P80_MODULE)
@@ -488,7 +488,7 @@ static struct platform_device *cm_bf561_devices[] __initdata = {
 	&net2272_bfin_device,
 #endif
 
-#if defined(CONFIG_SPI_BFIN) || defined(CONFIG_SPI_BFIN_MODULE)
+#if defined(CONFIG_SPI_BFIN5XX) || defined(CONFIG_SPI_BFIN5XX_MODULE)
 	&bfin_spi0_device,
 #endif
 
@@ -523,7 +523,7 @@ static int __init cm_bf561_init(void)
 {
 	printk(KERN_INFO "%s(): registering device resources\n", __func__);
 	platform_add_devices(cm_bf561_devices, ARRAY_SIZE(cm_bf561_devices));
-#if defined(CONFIG_SPI_BFIN) || defined(CONFIG_SPI_BFIN_MODULE)
+#if defined(CONFIG_SPI_BFIN5XX) || defined(CONFIG_SPI_BFIN5XX_MODULE)
 	spi_register_board_info(bfin_spi_board_info, ARRAY_SIZE(bfin_spi_board_info));
 #endif
 
diff --git a/arch/blackfin/mach-bf561/boards/ezkit.c b/arch/blackfin/mach-bf561/boards/ezkit.c
index 27f22ed..5ade37d 100644
--- a/arch/blackfin/mach-bf561/boards/ezkit.c
+++ b/arch/blackfin/mach-bf561/boards/ezkit.c
@@ -291,7 +291,7 @@ static struct platform_device ezkit_flash_device = {
 };
 #endif
 
-#if defined(CONFIG_SPI_BFIN) || defined(CONFIG_SPI_BFIN_MODULE)
+#if defined(CONFIG_SPI_BFIN5XX) || defined(CONFIG_SPI_BFIN5XX_MODULE)
 /* SPI (0) */
 static struct resource bfin_spi0_resource[] = {
 	[0] = {
@@ -462,7 +462,7 @@ static struct platform_device *ezkit_devices[] __initdata = {
 	&bfin_isp1760_device,
 #endif
 
-#if defined(CONFIG_SPI_BFIN) || defined(CONFIG_SPI_BFIN_MODULE)
+#if defined(CONFIG_SPI_BFIN5XX) || defined(CONFIG_SPI_BFIN5XX_MODULE)
 	&bfin_spi0_device,
 #endif
 
-- 
1.7.0.4


