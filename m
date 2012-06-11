Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753849Ab2FKLEX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 07:04:23 -0400
Received: from mail.work-microwave.de ([62.245.205.51]:36759 "EHLO
	work-microwave.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753773Ab2FKLCo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 07:02:44 -0400
From: Roland Stigge <stigge@antcom.de>
To: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, kevin.wells@nxp.com,
        srinivas.bakki@nxp.com, aletes.xgr@gmail.com
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH 9/14] ARM: LPC32xx: Defconfig update
Date: Mon, 11 Jun 2012 13:02:12 +0200
Message-Id: <1339412537-24485-10-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1339412537-24485-1-git-send-email-stigge@antcom.de>
References: <1339412537-24485-1-git-send-email-stigge@antcom.de>
X-FEAS-SYSTEM-WL: rst@work-microwave.de, 192.168.11.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This defconfig update for the LPC32xx SoC platform adds the new drivers in v3.5
and drivers typically used in systems with the LPC32xx chip.

Signed-off-by: Roland Stigge <stigge@antcom.de>
---
 arch/arm/configs/lpc32xx_defconfig |   22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

--- linux-2.6.orig/arch/arm/configs/lpc32xx_defconfig
+++ linux-2.6/arch/arm/configs/lpc32xx_defconfig
@@ -1,5 +1,7 @@
 CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
+CONFIG_NO_HZ=y
+CONFIG_HIGH_RES_TIMERS=y
 CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=16
@@ -16,8 +18,6 @@ CONFIG_MODULE_UNLOAD=y
 # CONFIG_BLK_DEV_BSG is not set
 CONFIG_PARTITION_ADVANCED=y
 CONFIG_ARCH_LPC32XX=y
-CONFIG_NO_HZ=y
-CONFIG_HIGH_RES_TIMERS=y
 CONFIG_PREEMPT=y
 CONFIG_AEABI=y
 CONFIG_ZBOOT_ROM_TEXT=0x0
@@ -54,11 +54,14 @@ CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
 CONFIG_MTD_NAND=y
 CONFIG_MTD_NAND_MUSEUM_IDS=y
+CONFIG_MTD_NAND_SLC_LPC32XX=y
+CONFIG_MTD_NAND_MLC_LPC32XX=y
 CONFIG_BLK_DEV_LOOP=y
 CONFIG_BLK_DEV_CRYPTOLOOP=y
 CONFIG_BLK_DEV_RAM=y
 CONFIG_BLK_DEV_RAM_COUNT=1
 CONFIG_BLK_DEV_RAM_SIZE=16384
+CONFIG_EEPROM_AT24=y
 CONFIG_EEPROM_AT25=y
 CONFIG_SCSI=y
 CONFIG_BLK_DEV_SD=y
@@ -79,16 +82,22 @@ CONFIG_LPC_ENET=y
 # CONFIG_NET_VENDOR_STMICRO is not set
 CONFIG_SMSC_PHY=y
 # CONFIG_WLAN is not set
+CONFIG_INPUT_MATRIXKMAP=y
 # CONFIG_INPUT_MOUSEDEV_PSAUX is not set
 CONFIG_INPUT_MOUSEDEV_SCREEN_X=240
 CONFIG_INPUT_MOUSEDEV_SCREEN_Y=320
 CONFIG_INPUT_EVDEV=y
+# CONFIG_KEYBOARD_ATKBD is not set
+CONFIG_KEYBOARD_LPC32XX=y
 # CONFIG_INPUT_MOUSE is not set
 CONFIG_INPUT_TOUCHSCREEN=y
 CONFIG_TOUCHSCREEN_LPC32XX=y
+CONFIG_SERIO_LIBPS2=y
 # CONFIG_LEGACY_PTYS is not set
 CONFIG_SERIAL_8250=y
 CONFIG_SERIAL_8250_CONSOLE=y
+CONFIG_SERIAL_HS_LPC32XX=y
+CONFIG_SERIAL_OF_PLATFORM=y
 # CONFIG_HW_RANDOM is not set
 CONFIG_I2C=y
 CONFIG_I2C_CHARDEV=y
@@ -96,7 +105,8 @@ CONFIG_I2C_PNX=y
 CONFIG_SPI=y
 CONFIG_SPI_PL022=y
 CONFIG_GPIO_SYSFS=y
-# CONFIG_HWMON is not set
+CONFIG_SENSORS_DS620=y
+CONFIG_SENSORS_MAX6639=y
 CONFIG_WATCHDOG=y
 CONFIG_PNX4008_WATCHDOG=y
 CONFIG_FB=y
@@ -133,6 +143,8 @@ CONFIG_MMC=y
 CONFIG_MMC_ARMMMCI=y
 CONFIG_NEW_LEDS=y
 CONFIG_LEDS_CLASS=y
+CONFIG_LEDS_PCA9532=y
+CONFIG_LEDS_PCA9532_GPIO=y
 CONFIG_LEDS_GPIO=y
 CONFIG_LEDS_TRIGGERS=y
 CONFIG_LEDS_TRIGGER_TIMER=y
@@ -148,8 +160,9 @@ CONFIG_RTC_DRV_LPC32XX=y
 CONFIG_DMADEVICES=y
 CONFIG_AMBA_PL08X=y
 CONFIG_STAGING=y
-CONFIG_IIO=y
 CONFIG_LPC32XX_ADC=y
+CONFIG_MAX517=y
+CONFIG_IIO=y
 CONFIG_EXT2_FS=y
 CONFIG_AUTOFS4_FS=y
 CONFIG_MSDOS_FS=y
@@ -159,7 +172,6 @@ CONFIG_JFFS2_FS=y
 CONFIG_JFFS2_FS_WBUF_VERIFY=y
 CONFIG_CRAMFS=y
 CONFIG_NFS_FS=y
-CONFIG_NFS_V3=y
 CONFIG_ROOT_NFS=y
 CONFIG_NLS_CODEPAGE_437=y
 CONFIG_NLS_ASCII=y
