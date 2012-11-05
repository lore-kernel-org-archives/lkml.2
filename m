Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964845Ab2KEX1s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 18:27:48 -0500
Received: from smtp.outflux.net ([198.145.64.163]:42805 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755077Ab2KEXFX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 18:05:23 -0500
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Ralf Baechle <ralf@linux-mips.org>,
        Manuel Lauss <manuel.lauss@googlemail.com>
Subject: [PATCH 050/104] drivers/i2c/busses: remove depends on CONFIG_EXPERIMENTAL
Date: Mon,  5 Nov 2012 15:04:07 -0800
Message-Id: <1352156701-4038-51-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1352156701-4038-1-git-send-email-keescook@chromium.org>
References: <1352156701-4038-1-git-send-email-keescook@chromium.org>
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The CONFIG_EXPERIMENTAL config item has not carried much meaning for a
while now and is almost always enabled by default. As agreed during the
Linux kernel summit, remove it from any "depends on" lines in Kconfigs.

CC: Ralf Baechle <ralf@linux-mips.org>
CC: Manuel Lauss <manuel.lauss@googlemail.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/i2c/busses/Kconfig |   16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
index e9df461..2597ddd 100644
--- a/drivers/i2c/busses/Kconfig
+++ b/drivers/i2c/busses/Kconfig
@@ -22,7 +22,7 @@ config I2C_ALI1535
 
 config I2C_ALI1563
 	tristate "ALI 1563"
-	depends on PCI && EXPERIMENTAL
+	depends on PCI
 	help
 	  If you say yes to this option, support will be included for the SMB
 	  Host controller on Acer Labs Inc. (ALI) M1563 South Bridges.  The SMB
@@ -56,7 +56,7 @@ config I2C_AMD756
 
 config I2C_AMD756_S4882
 	tristate "SMBus multiplexing on the Tyan S4882"
-	depends on I2C_AMD756 && X86 && EXPERIMENTAL
+	depends on I2C_AMD756 && X86
 	help
 	  Enabling this option will add specific SMBus support for the Tyan
 	  S4882 motherboard.  On this 4-CPU board, the SMBus is multiplexed
@@ -164,7 +164,7 @@ config I2C_NFORCE2
 
 config I2C_NFORCE2_S4985
 	tristate "SMBus multiplexing on the Tyan S4985"
-	depends on I2C_NFORCE2 && X86 && EXPERIMENTAL
+	depends on I2C_NFORCE2 && X86
 	help
 	  Enabling this option will add specific SMBus support for the Tyan
 	  S4985 motherboard.  On this 4-CPU board, the SMBus is multiplexed
@@ -215,7 +215,7 @@ config I2C_SIS96X
 
 config I2C_VIA
 	tristate "VIA VT82C586B"
-	depends on PCI && EXPERIMENTAL
+	depends on PCI
 	select I2C_ALGOBIT
 	help
 	  If you say yes to this option, support will be included for the VIA
@@ -267,7 +267,7 @@ comment "Mac SMBus host controller drivers"
 
 config I2C_HYDRA
 	tristate "CHRP Apple Hydra Mac I/O I2C interface"
-	depends on PCI && PPC_CHRP && EXPERIMENTAL
+	depends on PCI && PPC_CHRP
 	select I2C_ALGOBIT
 	help
 	  This supports the use of the I2C interface in the Apple Hydra Mac
@@ -293,7 +293,7 @@ comment "I2C system bus drivers (mostly embedded / system-on-chip)"
 
 config I2C_AT91
 	tristate "Atmel AT91 I2C Two-Wire interface (TWI)"
-	depends on ARCH_AT91 && EXPERIMENTAL
+	depends on ARCH_AT91
 	help
 	  This supports the use of the I2C interface on Atmel AT91
 	  processors.
@@ -509,7 +509,6 @@ config I2C_NUC900
 
 config I2C_OCORES
 	tristate "OpenCores I2C Controller"
-	depends on EXPERIMENTAL
 	help
 	  If you say yes to this option, support will be included for the
 	  OpenCores I2C controller. For details see
@@ -702,7 +701,7 @@ config I2C_OCTEON
 
 config I2C_XILINX
 	tristate "Xilinx I2C Controller"
-	depends on EXPERIMENTAL && HAS_IOMEM
+	depends on HAS_IOMEM
 	help
 	  If you say yes to this option, support will be included for the
 	  Xilinx I2C controller.
@@ -793,7 +792,6 @@ config I2C_PARPORT_LIGHT
 
 config I2C_TAOS_EVM
 	tristate "TAOS evaluation module"
-	depends on EXPERIMENTAL
 	select SERIO
 	select SERIO_SERPORT
 	default n
-- 
1.7.9.5

