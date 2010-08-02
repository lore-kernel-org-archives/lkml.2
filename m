Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754114Ab0HBQDa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 12:03:30 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:64565 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753924Ab0HBQD2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 12:03:28 -0400
Date: Mon, 2 Aug 2010 18:03:25 +0200
From: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
To: Mike Frysinger <vapier@gentoo.org>,
        Michael Hennerich <michael.hennerich@analog.com>,
        Sonic Zhang <sonic.zhang@analog.com>,
        Barry Song <barry.song@analog.com>, Jean Delvare <khali@linux-fr.org>,
        Cliff Cai <cliff.cai@analog.com>, Robin Getz <robin.getz@analog.com>,
        Yi Li <yi.li@analog.com>,
        Harald Krapfenbauer <Harald.Krapfenbauer@bluetechnix.at>,
        uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org
Cc: vamos-dev@i4.informatik.uni-erlangen.de
Subject: [PATCH 6/6] arch/blackfin: Removing dead SND_BLACKFIN_AD183X
Message-ID: <ccdd80e85789f8b5cc2606195f331b3339e565a2.1280764206.git.qy03fugy@stud.informatik.uni-erlangen.de>
References: <cover.1280764206.git.qy03fugy@stud.informatik.uni-erlangen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1280764206.git.qy03fugy@stud.informatik.uni-erlangen.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CONFIG_SND_BLACKFIN_AD183X doesn't exist in Kconfig, therefore removing
all references to it from the source.

Signed-off-by: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
---
 arch/blackfin/mach-bf527/boards/cm_bf527.c  |   18 ------------------
 arch/blackfin/mach-bf527/boards/ezkit.c     |   18 ------------------
 arch/blackfin/mach-bf533/boards/H8606.c     |   17 -----------------
 arch/blackfin/mach-bf533/boards/cm_bf533.c  |   17 -----------------
 arch/blackfin/mach-bf533/boards/ezkit.c     |   16 ----------------
 arch/blackfin/mach-bf533/boards/stamp.c     |   17 -----------------
 arch/blackfin/mach-bf537/boards/cm_bf537e.c |   17 -----------------
 arch/blackfin/mach-bf537/boards/cm_bf537u.c |   17 -----------------
 arch/blackfin/mach-bf537/boards/pnav10.c    |   18 ------------------
 arch/blackfin/mach-bf537/boards/tcm_bf537.c |   17 -----------------
 arch/blackfin/mach-bf548/boards/ezkit.c     |   18 ------------------
 arch/blackfin/mach-bf561/boards/cm_bf561.c  |   16 ----------------
 arch/blackfin/mach-bf561/boards/ezkit.c     |   18 ------------------
 13 files changed, 0 insertions(+), 224 deletions(-)

diff --git a/arch/blackfin/mach-bf527/boards/cm_bf527.c b/arch/blackfin/mach-bf527/boards/cm_bf527.c
index f392af6..7747f5d 100644
--- a/arch/blackfin/mach-bf527/boards/cm_bf527.c
+++ b/arch/blackfin/mach-bf527/boards/cm_bf527.c
@@ -343,14 +343,6 @@ static struct bfin5xx_spi_chip spi_adc_chip_info = {
 };
 #endif
 
-#if defined(CONFIG_SND_BLACKFIN_AD183X) \
-	|| defined(CONFIG_SND_BLACKFIN_AD183X_MODULE)
-static struct bfin5xx_spi_chip ad1836_spi_chip_info = {
-	.enable_dma = 0,
-	.bits_per_word = 16,
-};
-#endif
-
 #if defined(CONFIG_MMC_SPI) || defined(CONFIG_MMC_SPI_MODULE)
 static struct bfin5xx_spi_chip  mmc_spi_chip_info = {
 	.enable_dma = 0,
@@ -421,16 +413,6 @@ static struct spi_board_info bfin_spi_board_info[] __initdata = {
 	},
 #endif
 
-#if defined(CONFIG_SND_BLACKFIN_AD183X) \
-	|| defined(CONFIG_SND_BLACKFIN_AD183X_MODULE)
-	{
-		.modalias = "ad1836",
-		.max_speed_hz = 3125000,     /* max spi clock (SCK) speed in HZ */
-		.bus_num = 0,
-		.chip_select = CONFIG_SND_BLACKFIN_SPI_PFBIT,
-		.controller_data = &ad1836_spi_chip_info,
-	},
-#endif
 #if defined(CONFIG_MMC_SPI) || defined(CONFIG_MMC_SPI_MODULE)
 	{
 		.modalias = "mmc_spi",
diff --git a/arch/blackfin/mach-bf527/boards/ezkit.c b/arch/blackfin/mach-bf527/boards/ezkit.c
index a05c967..cd53502 100644
--- a/arch/blackfin/mach-bf527/boards/ezkit.c
+++ b/arch/blackfin/mach-bf527/boards/ezkit.c
@@ -432,14 +432,6 @@ static struct bfin5xx_spi_chip spi_adc_chip_info = {
 };
 #endif
 
-#if defined(CONFIG_SND_BLACKFIN_AD183X) \
-	|| defined(CONFIG_SND_BLACKFIN_AD183X_MODULE)
-static struct bfin5xx_spi_chip ad1836_spi_chip_info = {
-	.enable_dma = 0,
-	.bits_per_word = 16,
-};
-#endif
-
 #if defined(CONFIG_MMC_SPI) || defined(CONFIG_MMC_SPI_MODULE)
 static struct bfin5xx_spi_chip  mmc_spi_chip_info = {
 	.enable_dma = 0,
@@ -548,16 +540,6 @@ static struct spi_board_info bfin_spi_board_info[] __initdata = {
 	},
 #endif
 
-#if defined(CONFIG_SND_BLACKFIN_AD183X) \
-	|| defined(CONFIG_SND_BLACKFIN_AD183X_MODULE)
-	{
-		.modalias = "ad1836",
-		.max_speed_hz = 3125000,     /* max spi clock (SCK) speed in HZ */
-		.bus_num = 0,
-		.chip_select = CONFIG_SND_BLACKFIN_SPI_PFBIT,
-		.controller_data = &ad1836_spi_chip_info,
-	},
-#endif
 #if defined(CONFIG_MMC_SPI) || defined(CONFIG_MMC_SPI_MODULE)
 	{
 		.modalias = "mmc_spi",
diff --git a/arch/blackfin/mach-bf533/boards/H8606.c b/arch/blackfin/mach-bf533/boards/H8606.c
index 175371a..026f6ca 100644
--- a/arch/blackfin/mach-bf533/boards/H8606.c
+++ b/arch/blackfin/mach-bf533/boards/H8606.c
@@ -171,13 +171,6 @@ static struct bfin5xx_spi_chip spi_adc_chip_info = {
 };
 #endif
 
-#if defined(CONFIG_SND_BLACKFIN_AD183X) || defined(CONFIG_SND_BLACKFIN_AD183X_MODULE)
-static struct bfin5xx_spi_chip ad1836_spi_chip_info = {
-	.enable_dma = 0,
-	.bits_per_word = 16,
-};
-#endif
-
 /* Notice: for blackfin, the speed_hz is the value of register
  * SPI_BAUD, not the real baudrate */
 static struct spi_board_info bfin_spi_board_info[] __initdata = {
@@ -206,16 +199,6 @@ static struct spi_board_info bfin_spi_board_info[] __initdata = {
 	},
 #endif
 
-#if defined(CONFIG_SND_BLACKFIN_AD183X) || defined(CONFIG_SND_BLACKFIN_AD183X_MODULE)
-	{
-		.modalias = "ad1836",
-		.max_speed_hz = 16,
-		.bus_num = 1,
-		.chip_select = CONFIG_SND_BLACKFIN_SPI_PFBIT,
-		.controller_data = &ad1836_spi_chip_info,
-	},
-#endif
-
 };
 
 /* SPI (0) */
diff --git a/arch/blackfin/mach-bf533/boards/cm_bf533.c b/arch/blackfin/mach-bf533/boards/cm_bf533.c
index fdcde61..a49b5b9 100644
--- a/arch/blackfin/mach-bf533/boards/cm_bf533.c
+++ b/arch/blackfin/mach-bf533/boards/cm_bf533.c
@@ -71,13 +71,6 @@ static struct bfin5xx_spi_chip spi_adc_chip_info = {
 };
 #endif
 
-#if defined(CONFIG_SND_BLACKFIN_AD183X) || defined(CONFIG_SND_BLACKFIN_AD183X_MODULE)
-static struct bfin5xx_spi_chip ad1836_spi_chip_info = {
-	.enable_dma = 0,
-	.bits_per_word = 16,
-};
-#endif
-
 #if defined(CONFIG_MMC_SPI) || defined(CONFIG_MMC_SPI_MODULE)
 static struct bfin5xx_spi_chip mmc_spi_chip_info = {
 	.enable_dma = 0,
@@ -110,16 +103,6 @@ static struct spi_board_info bfin_spi_board_info[] __initdata = {
 	},
 #endif
 
-#if defined(CONFIG_SND_BLACKFIN_AD183X) || defined(CONFIG_SND_BLACKFIN_AD183X_MODULE)
-	{
-		.modalias = "ad1836",
-		.max_speed_hz = 3125000,     /* max spi clock (SCK) speed in HZ */
-		.bus_num = 0,
-		.chip_select = CONFIG_SND_BLACKFIN_SPI_PFBIT,
-		.controller_data = &ad1836_spi_chip_info,
-	},
-#endif
-
 #if defined(CONFIG_MMC_SPI) || defined(CONFIG_MMC_SPI_MODULE)
 	{
 		.modalias = "mmc_spi",
diff --git a/arch/blackfin/mach-bf533/boards/ezkit.c b/arch/blackfin/mach-bf533/boards/ezkit.c
index 739773c..d0863e7 100644
--- a/arch/blackfin/mach-bf533/boards/ezkit.c
+++ b/arch/blackfin/mach-bf533/boards/ezkit.c
@@ -222,13 +222,6 @@ static struct bfin5xx_spi_chip spi_adc_chip_info = {
 };
 #endif
 
-#if defined(CONFIG_SND_BLACKFIN_AD183X) || defined(CONFIG_SND_BLACKFIN_AD183X_MODULE)
-static struct bfin5xx_spi_chip ad1836_spi_chip_info = {
-	.enable_dma = 0,
-	.bits_per_word = 16,
-};
-#endif
-
 #if defined(CONFIG_SPI_SPIDEV) || defined(CONFIG_SPI_SPIDEV_MODULE)
 static struct bfin5xx_spi_chip spidev_chip_info = {
 	.enable_dma = 0,
@@ -261,15 +254,6 @@ static struct spi_board_info bfin_spi_board_info[] __initdata = {
 	},
 #endif
 
-#if defined(CONFIG_SND_BLACKFIN_AD183X) || defined(CONFIG_SND_BLACKFIN_AD183X_MODULE)
-	{
-		.modalias = "ad1836",
-		.max_speed_hz = 3125000,     /* max spi clock (SCK) speed in HZ */
-		.bus_num = 0,
-		.chip_select = CONFIG_SND_BLACKFIN_SPI_PFBIT,
-		.controller_data = &ad1836_spi_chip_info,
-	},
-#endif
 #if defined(CONFIG_SPI_SPIDEV) || defined(CONFIG_SPI_SPIDEV_MODULE)
 	{
 		.modalias = "spidev",
diff --git a/arch/blackfin/mach-bf533/boards/stamp.c b/arch/blackfin/mach-bf533/boards/stamp.c
index c457eaa..25e4fbb 100644
--- a/arch/blackfin/mach-bf533/boards/stamp.c
+++ b/arch/blackfin/mach-bf533/boards/stamp.c
@@ -184,13 +184,6 @@ static struct bfin5xx_spi_chip spi_adc_chip_info = {
 };
 #endif
 
-#if defined(CONFIG_SND_BLACKFIN_AD183X) || defined(CONFIG_SND_BLACKFIN_AD183X_MODULE)
-static struct bfin5xx_spi_chip ad1836_spi_chip_info = {
-	.enable_dma = 0,
-	.bits_per_word = 16,
-};
-#endif
-
 #if defined(CONFIG_SPI_SPIDEV) || defined(CONFIG_SPI_SPIDEV_MODULE)
 static struct bfin5xx_spi_chip spidev_chip_info = {
 	.enable_dma = 0,
@@ -251,16 +244,6 @@ static struct spi_board_info bfin_spi_board_info[] __initdata = {
 	},
 #endif
 
-#if defined(CONFIG_SND_BLACKFIN_AD183X) || defined(CONFIG_SND_BLACKFIN_AD183X_MODULE)
-	{
-		.modalias = "ad1836",
-		.max_speed_hz = 3125000,     /* max spi clock (SCK) speed in HZ */
-		.bus_num = 0,
-		.chip_select = CONFIG_SND_BLACKFIN_SPI_PFBIT,
-		.controller_data = &ad1836_spi_chip_info,
-	},
-#endif
-
 #if defined(CONFIG_SPI_SPIDEV) || defined(CONFIG_SPI_SPIDEV_MODULE)
 	{
 		.modalias = "spidev",
diff --git a/arch/blackfin/mach-bf537/boards/cm_bf537e.c b/arch/blackfin/mach-bf537/boards/cm_bf537e.c
index d35fc5f..1881261 100644
--- a/arch/blackfin/mach-bf537/boards/cm_bf537e.c
+++ b/arch/blackfin/mach-bf537/boards/cm_bf537e.c
@@ -73,13 +73,6 @@ static struct bfin5xx_spi_chip spi_adc_chip_info = {
 };
 #endif
 
-#if defined(CONFIG_SND_BLACKFIN_AD183X) || defined(CONFIG_SND_BLACKFIN_AD183X_MODULE)
-static struct bfin5xx_spi_chip ad1836_spi_chip_info = {
-	.enable_dma = 0,
-	.bits_per_word = 16,
-};
-#endif
-
 #if defined(CONFIG_MMC_SPI) || defined(CONFIG_MMC_SPI_MODULE)
 static struct bfin5xx_spi_chip  mmc_spi_chip_info = {
 	.enable_dma = 0,
@@ -112,16 +105,6 @@ static struct spi_board_info bfin_spi_board_info[] __initdata = {
 	},
 #endif
 
-#if defined(CONFIG_SND_BLACKFIN_AD183X) || defined(CONFIG_SND_BLACKFIN_AD183X_MODULE)
-	{
-		.modalias = "ad1836",
-		.max_speed_hz = 3125000,     /* max spi clock (SCK) speed in HZ */
-		.bus_num = 0,
-		.chip_select = CONFIG_SND_BLACKFIN_SPI_PFBIT,
-		.controller_data = &ad1836_spi_chip_info,
-	},
-#endif
-
 #if defined(CONFIG_MMC_SPI) || defined(CONFIG_MMC_SPI_MODULE)
 	{
 		.modalias = "mmc_spi",
diff --git a/arch/blackfin/mach-bf537/boards/cm_bf537u.c b/arch/blackfin/mach-bf537/boards/cm_bf537u.c
index d464ad5..1ea78df 100644
--- a/arch/blackfin/mach-bf537/boards/cm_bf537u.c
+++ b/arch/blackfin/mach-bf537/boards/cm_bf537u.c
@@ -74,13 +74,6 @@ static struct bfin5xx_spi_chip spi_adc_chip_info = {
 };
 #endif
 
-#if defined(CONFIG_SND_BLACKFIN_AD183X) || defined(CONFIG_SND_BLACKFIN_AD183X_MODULE)
-static struct bfin5xx_spi_chip ad1836_spi_chip_info = {
-	.enable_dma = 0,
-	.bits_per_word = 16,
-};
-#endif
-
 #if defined(CONFIG_MMC_SPI) || defined(CONFIG_MMC_SPI_MODULE)
 static struct bfin5xx_spi_chip  mmc_spi_chip_info = {
 	.enable_dma = 0,
@@ -113,16 +106,6 @@ static struct spi_board_info bfin_spi_board_info[] __initdata = {
 	},
 #endif
 
-#if defined(CONFIG_SND_BLACKFIN_AD183X) || defined(CONFIG_SND_BLACKFIN_AD183X_MODULE)
-	{
-		.modalias = "ad1836",
-		.max_speed_hz = 3125000,     /* max spi clock (SCK) speed in HZ */
-		.bus_num = 0,
-		.chip_select = CONFIG_SND_BLACKFIN_SPI_PFBIT,
-		.controller_data = &ad1836_spi_chip_info,
-	},
-#endif
-
 #if defined(CONFIG_MMC_SPI) || defined(CONFIG_MMC_SPI_MODULE)
 	{
 		.modalias = "mmc_spi",
diff --git a/arch/blackfin/mach-bf537/boards/pnav10.c b/arch/blackfin/mach-bf537/boards/pnav10.c
index 812e8f9..1f8782b 100644
--- a/arch/blackfin/mach-bf537/boards/pnav10.c
+++ b/arch/blackfin/mach-bf537/boards/pnav10.c
@@ -175,14 +175,6 @@ static struct bfin5xx_spi_chip spi_adc_chip_info = {
 };
 #endif
 
-#if defined(CONFIG_SND_BLACKFIN_AD183X) \
-	|| defined(CONFIG_SND_BLACKFIN_AD183X_MODULE)
-static struct bfin5xx_spi_chip ad1836_spi_chip_info = {
-	.enable_dma = 0,
-	.bits_per_word = 16,
-};
-#endif
-
 #if defined(CONFIG_MMC_SPI) || defined(CONFIG_MMC_SPI_MODULE)
 static struct bfin5xx_spi_chip mmc_spi_chip_info = {
 	.enable_dma = 0,
@@ -238,16 +230,6 @@ static struct spi_board_info bfin_spi_board_info[] __initdata = {
 	},
 #endif
 
-#if defined(CONFIG_SND_BLACKFIN_AD183X) \
-	|| defined(CONFIG_SND_BLACKFIN_AD183X_MODULE)
-	{
-		.modalias = "ad1836",
-		.max_speed_hz = 3125000,     /* max spi clock (SCK) speed in HZ */
-		.bus_num = 0,
-		.chip_select = CONFIG_SND_BLACKFIN_SPI_PFBIT,
-		.controller_data = &ad1836_spi_chip_info,
-	},
-#endif
 #if defined(CONFIG_MMC_SPI) || defined(CONFIG_MMC_SPI_MODULE)
 	{
 		.modalias = "mmc_spi",
diff --git a/arch/blackfin/mach-bf537/boards/tcm_bf537.c b/arch/blackfin/mach-bf537/boards/tcm_bf537.c
index 4f0a2e7..50b571a 100644
--- a/arch/blackfin/mach-bf537/boards/tcm_bf537.c
+++ b/arch/blackfin/mach-bf537/boards/tcm_bf537.c
@@ -74,13 +74,6 @@ static struct bfin5xx_spi_chip spi_adc_chip_info = {
 };
 #endif
 
-#if defined(CONFIG_SND_BLACKFIN_AD183X) || defined(CONFIG_SND_BLACKFIN_AD183X_MODULE)
-static struct bfin5xx_spi_chip ad1836_spi_chip_info = {
-	.enable_dma = 0,
-	.bits_per_word = 16,
-};
-#endif
-
 #if defined(CONFIG_MMC_SPI) || defined(CONFIG_MMC_SPI_MODULE)
 static struct bfin5xx_spi_chip mmc_spi_chip_info = {
 	.enable_dma = 0,
@@ -113,16 +106,6 @@ static struct spi_board_info bfin_spi_board_info[] __initdata = {
 	},
 #endif
 
-#if defined(CONFIG_SND_BLACKFIN_AD183X) || defined(CONFIG_SND_BLACKFIN_AD183X_MODULE)
-	{
-		.modalias = "ad1836",
-		.max_speed_hz = 3125000,     /* max spi clock (SCK) speed in HZ */
-		.bus_num = 0,
-		.chip_select = CONFIG_SND_BLACKFIN_SPI_PFBIT,
-		.controller_data = &ad1836_spi_chip_info,
-	},
-#endif
-
 #if defined(CONFIG_MMC_SPI) || defined(CONFIG_MMC_SPI_MODULE)
 	{
 		.modalias = "mmc_spi",
diff --git a/arch/blackfin/mach-bf548/boards/ezkit.c b/arch/blackfin/mach-bf548/boards/ezkit.c
index 6fcfb91..326519e 100644
--- a/arch/blackfin/mach-bf548/boards/ezkit.c
+++ b/arch/blackfin/mach-bf548/boards/ezkit.c
@@ -967,14 +967,6 @@ static struct bfin5xx_spi_chip spi_flash_chip_info = {
 };
 #endif
 
-#if defined(CONFIG_SND_BLACKFIN_AD183X) \
-	|| defined(CONFIG_SND_BLACKFIN_AD183X_MODULE)
-static struct bfin5xx_spi_chip ad1836_spi_chip_info = {
-	.enable_dma = 0,
-	.bits_per_word = 16,
-};
-#endif
-
 #if defined(CONFIG_TOUCHSCREEN_AD7877) || defined(CONFIG_TOUCHSCREEN_AD7877_MODULE)
 static struct bfin5xx_spi_chip spi_ad7877_chip_info = {
 	.enable_dma = 0,
@@ -1024,16 +1016,6 @@ static struct spi_board_info bfin_spi_board_info[] __initdata = {
 		.mode = SPI_MODE_3,
 	},
 #endif
-#if defined(CONFIG_SND_BLACKFIN_AD183X) \
-	|| defined(CONFIG_SND_BLACKFIN_AD183X_MODULE)
-	{
-		.modalias = "ad1836",
-		.max_speed_hz = 3125000,     /* max spi clock (SCK) speed in HZ */
-		.bus_num = 1,
-		.chip_select = CONFIG_SND_BLACKFIN_SPI_PFBIT,
-		.controller_data = &ad1836_spi_chip_info,
-	},
-#endif
 #if defined(CONFIG_TOUCHSCREEN_AD7877) || defined(CONFIG_TOUCHSCREEN_AD7877_MODULE)
 	{
 		.modalias		= "ad7877",
diff --git a/arch/blackfin/mach-bf561/boards/cm_bf561.c b/arch/blackfin/mach-bf561/boards/cm_bf561.c
index e127aed..a0b9c37 100644
--- a/arch/blackfin/mach-bf561/boards/cm_bf561.c
+++ b/arch/blackfin/mach-bf561/boards/cm_bf561.c
@@ -72,13 +72,6 @@ static struct bfin5xx_spi_chip spi_adc_chip_info = {
 };
 #endif
 
-#if defined(CONFIG_SND_BLACKFIN_AD183X) || defined(CONFIG_SND_BLACKFIN_AD183X_MODULE)
-static struct bfin5xx_spi_chip ad1836_spi_chip_info = {
-	.enable_dma = 0,
-	.bits_per_word = 16,
-};
-#endif
-
 #if defined(CONFIG_MMC_SPI) || defined(CONFIG_MMC_SPI_MODULE)
 static struct bfin5xx_spi_chip mmc_spi_chip_info = {
 	.enable_dma = 0,
@@ -111,15 +104,6 @@ static struct spi_board_info bfin_spi_board_info[] __initdata = {
 	},
 #endif
 
-#if defined(CONFIG_SND_BLACKFIN_AD183X) || defined(CONFIG_SND_BLACKFIN_AD183X_MODULE)
-	{
-		.modalias = "ad1836",
-		.max_speed_hz = 3125000,     /* max spi clock (SCK) speed in HZ */
-		.bus_num = 0,
-		.chip_select = CONFIG_SND_BLACKFIN_SPI_PFBIT,
-		.controller_data = &ad1836_spi_chip_info,
-	},
-#endif
 #if defined(CONFIG_MMC_SPI) || defined(CONFIG_MMC_SPI_MODULE)
 	{
 		.modalias = "mmc_spi",
diff --git a/arch/blackfin/mach-bf561/boards/ezkit.c b/arch/blackfin/mach-bf561/boards/ezkit.c
index 9b93e2f..dc2f134 100644
--- a/arch/blackfin/mach-bf561/boards/ezkit.c
+++ b/arch/blackfin/mach-bf561/boards/ezkit.c
@@ -274,14 +274,6 @@ static struct platform_device ezkit_flash_device = {
 };
 #endif
 
-#if defined(CONFIG_SND_BLACKFIN_AD183X) \
-	|| defined(CONFIG_SND_BLACKFIN_AD183X_MODULE)
-static struct bfin5xx_spi_chip ad1836_spi_chip_info = {
-	.enable_dma = 0,
-	.bits_per_word = 16,
-};
-#endif
-
 #if defined(CONFIG_SPI_SPIDEV) || defined(CONFIG_SPI_SPIDEV_MODULE)
 static struct bfin5xx_spi_chip spidev_chip_info = {
 	.enable_dma = 0,
@@ -328,16 +320,6 @@ static struct platform_device bfin_spi0_device = {
 #endif
 
 static struct spi_board_info bfin_spi_board_info[] __initdata = {
-#if defined(CONFIG_SND_BLACKFIN_AD183X) \
-	|| defined(CONFIG_SND_BLACKFIN_AD183X_MODULE)
-	{
-		.modalias = "ad1836",
-		.max_speed_hz = 3125000,     /* max spi clock (SCK) speed in HZ */
-		.bus_num = 0,
-		.chip_select = CONFIG_SND_BLACKFIN_SPI_PFBIT,
-		.controller_data = &ad1836_spi_chip_info,
-	},
-#endif
 #if defined(CONFIG_SPI_SPIDEV) || defined(CONFIG_SPI_SPIDEV_MODULE)
 	{
 		.modalias = "spidev",
-- 
1.7.0.4

