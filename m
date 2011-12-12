Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752899Ab1LLD25 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Dec 2011 22:28:57 -0500
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:2725 "EHLO
	TX2EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752937Ab1LLD2i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Dec 2011 22:28:38 -0500
X-SpamScore: 2
X-BigFish: VS2(zzzz1202hzz8275bhz2ei87h2a8h668h839hb79i61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:137.71.25.55;KIP:(null);UIP:(null);IPV:NLI;H:nwd2mta1.analog.com;RD:nwd2mail10.analog.com;EFVD:NLI
X-FB-DOMAIN-IP-MATCH: fail
From: Bob Liu <lliubbo@gmail.com>
To: <linux-kernel@vger.kernel.org>
CC: <sonic.adi@gmail.com>, <uclinux-dist-devel@blackfin.uclinux.org>,
        <vapier@gentoo.org>, Scott Jiang <scott.jiang.linux@gmail.com>,
        Bob Liu <lliubbo@gmail.com>
Subject: [PATCH 05/11] blackfin: config: update def config for all boards
Date: Mon, 12 Dec 2011 11:28:27 +0800
Message-ID: <1323660513-9620-5-git-send-email-lliubbo@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1323660513-9620-1-git-send-email-lliubbo@gmail.com>
References: <1323660513-9620-1-git-send-email-lliubbo@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Scott Jiang <scott.jiang.linux@gmail.com>

Config name for spi controller driver has been modified in previous commit,
so update default config accordingly.

Signed-off-by: Scott Jiang <scott.jiang.linux@gmail.com>
Signed-off-by: Bob Liu <lliubbo@gmail.com>
---
 arch/blackfin/configs/BF518F-EZBRD_defconfig      |    2 +-
 arch/blackfin/configs/BF526-EZBRD_defconfig       |    2 +-
 arch/blackfin/configs/BF527-AD7160-EVAL_defconfig |    2 +-
 arch/blackfin/configs/BF527-EZKIT-V2_defconfig    |    2 +-
 arch/blackfin/configs/BF527-EZKIT_defconfig       |    2 +-
 arch/blackfin/configs/BF533-EZKIT_defconfig       |    2 +-
 arch/blackfin/configs/BF533-STAMP_defconfig       |    2 +-
 arch/blackfin/configs/BF537-STAMP_defconfig       |    2 +-
 arch/blackfin/configs/BF538-EZKIT_defconfig       |    2 +-
 arch/blackfin/configs/BF548-EZKIT_defconfig       |    2 +-
 arch/blackfin/configs/BF561-ACVILON_defconfig     |    2 +-
 arch/blackfin/configs/BF561-EZKIT-SMP_defconfig   |    2 +-
 arch/blackfin/configs/BF561-EZKIT_defconfig       |    2 +-
 arch/blackfin/configs/BlackStamp_defconfig        |    2 +-
 arch/blackfin/configs/CM-BF527_defconfig          |    2 +-
 arch/blackfin/configs/CM-BF533_defconfig          |    2 +-
 arch/blackfin/configs/CM-BF537E_defconfig         |    2 +-
 arch/blackfin/configs/CM-BF537U_defconfig         |    2 +-
 arch/blackfin/configs/CM-BF548_defconfig          |    2 +-
 arch/blackfin/configs/CM-BF561_defconfig          |    2 +-
 arch/blackfin/configs/DNP5370_defconfig           |    2 +-
 arch/blackfin/configs/H8606_defconfig             |    2 +-
 arch/blackfin/configs/IP0X_defconfig              |    2 +-
 arch/blackfin/configs/PNAV-10_defconfig           |    2 +-
 arch/blackfin/configs/SRV1_defconfig              |    2 +-
 arch/blackfin/configs/TCM-BF518_defconfig         |    2 +-
 arch/blackfin/configs/TCM-BF537_defconfig         |    2 +-
 27 files changed, 27 insertions(+), 27 deletions(-)

diff --git a/arch/blackfin/configs/BF518F-EZBRD_defconfig b/arch/blackfin/configs/BF518F-EZBRD_defconfig
index 5edcb58..0b7039c 100644
--- a/arch/blackfin/configs/BF518F-EZBRD_defconfig
+++ b/arch/blackfin/configs/BF518F-EZBRD_defconfig
@@ -80,7 +80,7 @@ CONFIG_I2C_CHARDEV=y
 CONFIG_I2C_BLACKFIN_TWI=y
 CONFIG_I2C_BLACKFIN_TWI_CLK_KHZ=100
 CONFIG_SPI=y
-CONFIG_SPI_BFIN=y
+CONFIG_SPI_BFIN5XX=y
 CONFIG_GPIOLIB=y
 CONFIG_GPIO_SYSFS=y
 # CONFIG_HWMON is not set
diff --git a/arch/blackfin/configs/BF526-EZBRD_defconfig b/arch/blackfin/configs/BF526-EZBRD_defconfig
index 2e54957..5553205 100644
--- a/arch/blackfin/configs/BF526-EZBRD_defconfig
+++ b/arch/blackfin/configs/BF526-EZBRD_defconfig
@@ -97,7 +97,7 @@ CONFIG_I2C_CHARDEV=m
 CONFIG_I2C_BLACKFIN_TWI=y
 CONFIG_I2C_BLACKFIN_TWI_CLK_KHZ=100
 CONFIG_SPI=y
-CONFIG_SPI_BFIN=y
+CONFIG_SPI_BFIN5XX=y
 CONFIG_GPIOLIB=y
 CONFIG_GPIO_SYSFS=y
 CONFIG_WATCHDOG=y
diff --git a/arch/blackfin/configs/BF527-AD7160-EVAL_defconfig b/arch/blackfin/configs/BF527-AD7160-EVAL_defconfig
index ad0881b..d95658f 100644
--- a/arch/blackfin/configs/BF527-AD7160-EVAL_defconfig
+++ b/arch/blackfin/configs/BF527-AD7160-EVAL_defconfig
@@ -68,7 +68,7 @@ CONFIG_I2C_ALGOBIT=y
 CONFIG_I2C_BLACKFIN_TWI=y
 CONFIG_I2C_BLACKFIN_TWI_CLK_KHZ=400
 CONFIG_SPI=y
-CONFIG_SPI_BFIN=y
+CONFIG_SPI_BFIN5XX=y
 CONFIG_GPIOLIB=y
 CONFIG_GPIO_SYSFS=y
 # CONFIG_HWMON is not set
diff --git a/arch/blackfin/configs/BF527-EZKIT-V2_defconfig b/arch/blackfin/configs/BF527-EZKIT-V2_defconfig
index 8465b3e..498f64a 100644
--- a/arch/blackfin/configs/BF527-EZKIT-V2_defconfig
+++ b/arch/blackfin/configs/BF527-EZKIT-V2_defconfig
@@ -105,7 +105,7 @@ CONFIG_I2C_CHARDEV=m
 CONFIG_I2C_BLACKFIN_TWI=y
 CONFIG_I2C_BLACKFIN_TWI_CLK_KHZ=100
 CONFIG_SPI=y
-CONFIG_SPI_BFIN=y
+CONFIG_SPI_BFIN5XX=y
 CONFIG_GPIOLIB=y
 CONFIG_GPIO_SYSFS=y
 # CONFIG_HWMON is not set
diff --git a/arch/blackfin/configs/BF527-EZKIT_defconfig b/arch/blackfin/configs/BF527-EZKIT_defconfig
index 5e7321b..72e0317 100644
--- a/arch/blackfin/configs/BF527-EZKIT_defconfig
+++ b/arch/blackfin/configs/BF527-EZKIT_defconfig
@@ -99,7 +99,7 @@ CONFIG_I2C_CHARDEV=m
 CONFIG_I2C_BLACKFIN_TWI=y
 CONFIG_I2C_BLACKFIN_TWI_CLK_KHZ=100
 CONFIG_SPI=y
-CONFIG_SPI_BFIN=y
+CONFIG_SPI_BFIN5XX=y
 CONFIG_GPIOLIB=y
 CONFIG_GPIO_SYSFS=y
 # CONFIG_HWMON is not set
diff --git a/arch/blackfin/configs/BF533-EZKIT_defconfig b/arch/blackfin/configs/BF533-EZKIT_defconfig
index a7eb54b..2f075e0 100644
--- a/arch/blackfin/configs/BF533-EZKIT_defconfig
+++ b/arch/blackfin/configs/BF533-EZKIT_defconfig
@@ -81,7 +81,7 @@ CONFIG_SERIAL_BFIN_CONSOLE=y
 # CONFIG_LEGACY_PTYS is not set
 # CONFIG_HW_RANDOM is not set
 CONFIG_SPI=y
-CONFIG_SPI_BFIN=y
+CONFIG_SPI_BFIN5XX=y
 CONFIG_GPIOLIB=y
 CONFIG_GPIO_SYSFS=y
 # CONFIG_HWMON is not set
diff --git a/arch/blackfin/configs/BF533-STAMP_defconfig b/arch/blackfin/configs/BF533-STAMP_defconfig
index b90d379..ab38a82 100644
--- a/arch/blackfin/configs/BF533-STAMP_defconfig
+++ b/arch/blackfin/configs/BF533-STAMP_defconfig
@@ -84,7 +84,7 @@ CONFIG_I2C=m
 CONFIG_I2C_CHARDEV=m
 CONFIG_I2C_GPIO=m
 CONFIG_SPI=y
-CONFIG_SPI_BFIN=y
+CONFIG_SPI_BFIN5XX=y
 CONFIG_GPIOLIB=y
 CONFIG_GPIO_SYSFS=y
 # CONFIG_HWMON is not set
diff --git a/arch/blackfin/configs/BF537-STAMP_defconfig b/arch/blackfin/configs/BF537-STAMP_defconfig
index 0053625..5c802d6 100644
--- a/arch/blackfin/configs/BF537-STAMP_defconfig
+++ b/arch/blackfin/configs/BF537-STAMP_defconfig
@@ -94,7 +94,7 @@ CONFIG_I2C_CHARDEV=m
 CONFIG_I2C_BLACKFIN_TWI=m
 CONFIG_I2C_BLACKFIN_TWI_CLK_KHZ=100
 CONFIG_SPI=y
-CONFIG_SPI_BFIN=y
+CONFIG_SPI_BFIN5XX=y
 CONFIG_GPIOLIB=y
 CONFIG_GPIO_SYSFS=y
 # CONFIG_HWMON is not set
diff --git a/arch/blackfin/configs/BF538-EZKIT_defconfig b/arch/blackfin/configs/BF538-EZKIT_defconfig
index 580bf42..972aa62 100644
--- a/arch/blackfin/configs/BF538-EZKIT_defconfig
+++ b/arch/blackfin/configs/BF538-EZKIT_defconfig
@@ -101,7 +101,7 @@ CONFIG_I2C=m
 CONFIG_I2C_BLACKFIN_TWI=m
 CONFIG_I2C_BLACKFIN_TWI_CLK_KHZ=100
 CONFIG_SPI=y
-CONFIG_SPI_BFIN=y
+CONFIG_SPI_BFIN5XX=y
 CONFIG_GPIOLIB=y
 CONFIG_GPIO_SYSFS=y
 # CONFIG_HWMON is not set
diff --git a/arch/blackfin/configs/BF548-EZKIT_defconfig b/arch/blackfin/configs/BF548-EZKIT_defconfig
index 0e6d841..7a1e3bf 100644
--- a/arch/blackfin/configs/BF548-EZKIT_defconfig
+++ b/arch/blackfin/configs/BF548-EZKIT_defconfig
@@ -113,7 +113,7 @@ CONFIG_I2C_CHARDEV=y
 CONFIG_I2C_BLACKFIN_TWI=y
 CONFIG_I2C_BLACKFIN_TWI_CLK_KHZ=100
 CONFIG_SPI=y
-CONFIG_SPI_BFIN=y
+CONFIG_SPI_BFIN5XX=y
 CONFIG_GPIOLIB=y
 CONFIG_GPIO_SYSFS=y
 # CONFIG_HWMON is not set
diff --git a/arch/blackfin/configs/BF561-ACVILON_defconfig b/arch/blackfin/configs/BF561-ACVILON_defconfig
index 77a27e3..0fdc4ec 100644
--- a/arch/blackfin/configs/BF561-ACVILON_defconfig
+++ b/arch/blackfin/configs/BF561-ACVILON_defconfig
@@ -85,7 +85,7 @@ CONFIG_I2C=y
 CONFIG_I2C_CHARDEV=y
 CONFIG_I2C_PCA_PLATFORM=y
 CONFIG_SPI=y
-CONFIG_SPI_BFIN=y
+CONFIG_SPI_BFIN5XX=y
 CONFIG_SPI_SPIDEV=y
 CONFIG_GPIOLIB=y
 CONFIG_GPIO_SYSFS=y
diff --git a/arch/blackfin/configs/BF561-EZKIT-SMP_defconfig b/arch/blackfin/configs/BF561-EZKIT-SMP_defconfig
index f5ed34e..78adbbf 100644
--- a/arch/blackfin/configs/BF561-EZKIT-SMP_defconfig
+++ b/arch/blackfin/configs/BF561-EZKIT-SMP_defconfig
@@ -84,7 +84,7 @@ CONFIG_SERIAL_BFIN_CONSOLE=y
 # CONFIG_LEGACY_PTYS is not set
 # CONFIG_HW_RANDOM is not set
 CONFIG_SPI=y
-CONFIG_SPI_BFIN=y
+CONFIG_SPI_BFIN5XX=y
 CONFIG_GPIOLIB=y
 CONFIG_GPIO_SYSFS=y
 # CONFIG_HWMON is not set
diff --git a/arch/blackfin/configs/BF561-EZKIT_defconfig b/arch/blackfin/configs/BF561-EZKIT_defconfig
index d7ff2ae..d3cd0f5 100644
--- a/arch/blackfin/configs/BF561-EZKIT_defconfig
+++ b/arch/blackfin/configs/BF561-EZKIT_defconfig
@@ -86,7 +86,7 @@ CONFIG_SERIAL_BFIN_CONSOLE=y
 # CONFIG_LEGACY_PTYS is not set
 # CONFIG_HW_RANDOM is not set
 CONFIG_SPI=y
-CONFIG_SPI_BFIN=y
+CONFIG_SPI_BFIN5XX=y
 CONFIG_GPIOLIB=y
 CONFIG_GPIO_SYSFS=y
 # CONFIG_HWMON is not set
diff --git a/arch/blackfin/configs/BlackStamp_defconfig b/arch/blackfin/configs/BlackStamp_defconfig
index 8501431..7b982d0 100644
--- a/arch/blackfin/configs/BlackStamp_defconfig
+++ b/arch/blackfin/configs/BlackStamp_defconfig
@@ -80,7 +80,7 @@ CONFIG_I2C=m
 CONFIG_I2C_CHARDEV=m
 CONFIG_I2C_GPIO=m
 CONFIG_SPI=y
-CONFIG_SPI_BFIN=y
+CONFIG_SPI_BFIN5XX=y
 CONFIG_SPI_SPIDEV=m
 # CONFIG_HWMON is not set
 CONFIG_WATCHDOG=y
diff --git a/arch/blackfin/configs/CM-BF527_defconfig b/arch/blackfin/configs/CM-BF527_defconfig
index dbf750c..c280a50 100644
--- a/arch/blackfin/configs/CM-BF527_defconfig
+++ b/arch/blackfin/configs/CM-BF527_defconfig
@@ -88,7 +88,7 @@ CONFIG_I2C_CHARDEV=m
 CONFIG_I2C_BLACKFIN_TWI=m
 CONFIG_I2C_BLACKFIN_TWI_CLK_KHZ=100
 CONFIG_SPI=y
-CONFIG_SPI_BFIN=y
+CONFIG_SPI_BFIN5XX=y
 CONFIG_GPIOLIB=y
 CONFIG_GPIO_SYSFS=y
 CONFIG_WATCHDOG=y
diff --git a/arch/blackfin/configs/CM-BF533_defconfig b/arch/blackfin/configs/CM-BF533_defconfig
index 07ffbda..c940a1e 100644
--- a/arch/blackfin/configs/CM-BF533_defconfig
+++ b/arch/blackfin/configs/CM-BF533_defconfig
@@ -57,7 +57,7 @@ CONFIG_SERIAL_BFIN_CONSOLE=y
 # CONFIG_LEGACY_PTYS is not set
 # CONFIG_HW_RANDOM is not set
 CONFIG_SPI=y
-CONFIG_SPI_BFIN=y
+CONFIG_SPI_BFIN5XX=y
 # CONFIG_HWMON is not set
 # CONFIG_USB_SUPPORT is not set
 CONFIG_MMC=y
diff --git a/arch/blackfin/configs/CM-BF537E_defconfig b/arch/blackfin/configs/CM-BF537E_defconfig
index 707cbf8..2e47df7 100644
--- a/arch/blackfin/configs/CM-BF537E_defconfig
+++ b/arch/blackfin/configs/CM-BF537E_defconfig
@@ -78,7 +78,7 @@ CONFIG_SERIAL_BFIN_UART1=y
 # CONFIG_LEGACY_PTYS is not set
 # CONFIG_HW_RANDOM is not set
 CONFIG_SPI=y
-CONFIG_SPI_BFIN=y
+CONFIG_SPI_BFIN5XX=y
 CONFIG_GPIOLIB=y
 CONFIG_GPIO_SYSFS=y
 CONFIG_USB_GADGET=m
diff --git a/arch/blackfin/configs/CM-BF537U_defconfig b/arch/blackfin/configs/CM-BF537U_defconfig
index 4596935..6da629f 100644
--- a/arch/blackfin/configs/CM-BF537U_defconfig
+++ b/arch/blackfin/configs/CM-BF537U_defconfig
@@ -72,7 +72,7 @@ CONFIG_SERIAL_BFIN_UART1=y
 # CONFIG_LEGACY_PTYS is not set
 # CONFIG_HW_RANDOM is not set
 CONFIG_SPI=y
-CONFIG_SPI_BFIN=y
+CONFIG_SPI_BFIN5XX=y
 CONFIG_GPIOLIB=y
 CONFIG_GPIO_SYSFS=y
 CONFIG_USB_GADGET=y
diff --git a/arch/blackfin/configs/CM-BF548_defconfig b/arch/blackfin/configs/CM-BF548_defconfig
index 9f1d084..349922b 100644
--- a/arch/blackfin/configs/CM-BF548_defconfig
+++ b/arch/blackfin/configs/CM-BF548_defconfig
@@ -89,7 +89,7 @@ CONFIG_I2C=y
 CONFIG_I2C_CHARDEV=y
 CONFIG_I2C_BLACKFIN_TWI=y
 CONFIG_SPI=y
-CONFIG_SPI_BFIN=y
+CONFIG_SPI_BFIN5XX=y
 # CONFIG_HWMON is not set
 CONFIG_WATCHDOG=y
 CONFIG_BFIN_WDT=y
diff --git a/arch/blackfin/configs/CM-BF561_defconfig b/arch/blackfin/configs/CM-BF561_defconfig
index 6c7b215..0456dea 100644
--- a/arch/blackfin/configs/CM-BF561_defconfig
+++ b/arch/blackfin/configs/CM-BF561_defconfig
@@ -78,7 +78,7 @@ CONFIG_SERIAL_BFIN_CONSOLE=y
 # CONFIG_LEGACY_PTYS is not set
 # CONFIG_HW_RANDOM is not set
 CONFIG_SPI=y
-CONFIG_SPI_BFIN=y
+CONFIG_SPI_BFIN5XX=y
 CONFIG_GPIOLIB=y
 CONFIG_GPIO_SYSFS=y
 CONFIG_USB_GADGET=m
diff --git a/arch/blackfin/configs/DNP5370_defconfig b/arch/blackfin/configs/DNP5370_defconfig
index b192acf..89162d0 100644
--- a/arch/blackfin/configs/DNP5370_defconfig
+++ b/arch/blackfin/configs/DNP5370_defconfig
@@ -78,7 +78,7 @@ CONFIG_I2C=y
 CONFIG_I2C_CHARDEV=y
 CONFIG_I2C_BLACKFIN_TWI=y
 CONFIG_SPI=y
-CONFIG_SPI_BFIN=y
+CONFIG_SPI_BFIN5XX=y
 CONFIG_SPI_SPIDEV=y
 CONFIG_GPIOLIB=y
 CONFIG_GPIO_SYSFS=y
diff --git a/arch/blackfin/configs/H8606_defconfig b/arch/blackfin/configs/H8606_defconfig
index 06e9f49..a26436b 100644
--- a/arch/blackfin/configs/H8606_defconfig
+++ b/arch/blackfin/configs/H8606_defconfig
@@ -68,7 +68,7 @@ CONFIG_SERIAL_BFIN_CONSOLE=y
 # CONFIG_LEGACY_PTYS is not set
 # CONFIG_HW_RANDOM is not set
 CONFIG_SPI=y
-CONFIG_SPI_BFIN=y
+CONFIG_SPI_BFIN5XX=y
 CONFIG_SPI_SPIDEV=y
 CONFIG_WATCHDOG=y
 CONFIG_SOUND=m
diff --git a/arch/blackfin/configs/IP0X_defconfig b/arch/blackfin/configs/IP0X_defconfig
index 5e797cf..6479915 100644
--- a/arch/blackfin/configs/IP0X_defconfig
+++ b/arch/blackfin/configs/IP0X_defconfig
@@ -70,7 +70,7 @@ CONFIG_SERIAL_BFIN_CONSOLE=y
 # CONFIG_LEGACY_PTYS is not set
 CONFIG_HW_RANDOM=y
 CONFIG_SPI=y
-CONFIG_SPI_BFIN=y
+CONFIG_SPI_BFIN5XX=y
 # CONFIG_HWMON is not set
 CONFIG_WATCHDOG=y
 CONFIG_USB=y
diff --git a/arch/blackfin/configs/PNAV-10_defconfig b/arch/blackfin/configs/PNAV-10_defconfig
index a566a2f..8fd9b44 100644
--- a/arch/blackfin/configs/PNAV-10_defconfig
+++ b/arch/blackfin/configs/PNAV-10_defconfig
@@ -84,7 +84,7 @@ CONFIG_I2C_CHARDEV=y
 CONFIG_I2C_BLACKFIN_TWI=y
 CONFIG_I2C_BLACKFIN_TWI_CLK_KHZ=100
 CONFIG_SPI=y
-CONFIG_SPI_BFIN=y
+CONFIG_SPI_BFIN5XX=y
 CONFIG_FB=y
 CONFIG_FIRMWARE_EDID=y
 CONFIG_BACKLIGHT_LCD_SUPPORT=y
diff --git a/arch/blackfin/configs/SRV1_defconfig b/arch/blackfin/configs/SRV1_defconfig
index 12e66cd..0520c16 100644
--- a/arch/blackfin/configs/SRV1_defconfig
+++ b/arch/blackfin/configs/SRV1_defconfig
@@ -71,7 +71,7 @@ CONFIG_I2C_CHARDEV=y
 CONFIG_I2C_BLACKFIN_TWI=y
 CONFIG_I2C_BLACKFIN_TWI_CLK_KHZ=100
 CONFIG_SPI=y
-CONFIG_SPI_BFIN=y
+CONFIG_SPI_BFIN5XX=y
 CONFIG_HWMON=m
 CONFIG_WATCHDOG=y
 CONFIG_BFIN_WDT=y
diff --git a/arch/blackfin/configs/TCM-BF518_defconfig b/arch/blackfin/configs/TCM-BF518_defconfig
index d496ae9..e4ed865 100644
--- a/arch/blackfin/configs/TCM-BF518_defconfig
+++ b/arch/blackfin/configs/TCM-BF518_defconfig
@@ -92,7 +92,7 @@ CONFIG_I2C_CHARDEV=y
 CONFIG_I2C_BLACKFIN_TWI=y
 CONFIG_I2C_BLACKFIN_TWI_CLK_KHZ=100
 CONFIG_SPI=y
-CONFIG_SPI_BFIN=y
+CONFIG_SPI_BFIN5XX=y
 CONFIG_GPIOLIB=y
 CONFIG_GPIO_SYSFS=y
 # CONFIG_HWMON is not set
diff --git a/arch/blackfin/configs/TCM-BF537_defconfig b/arch/blackfin/configs/TCM-BF537_defconfig
index 65f6421..c1f45f1 100644
--- a/arch/blackfin/configs/TCM-BF537_defconfig
+++ b/arch/blackfin/configs/TCM-BF537_defconfig
@@ -70,7 +70,7 @@ CONFIG_SERIAL_BFIN_UART1=y
 # CONFIG_LEGACY_PTYS is not set
 # CONFIG_HW_RANDOM is not set
 CONFIG_SPI=y
-CONFIG_SPI_BFIN=y
+CONFIG_SPI_BFIN5XX=y
 # CONFIG_HWMON is not set
 CONFIG_WATCHDOG=y
 CONFIG_BFIN_WDT=y
-- 
1.7.0.4


