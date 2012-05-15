Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756772Ab2EOGtm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 02:49:42 -0400
Received: from slimlogic.co.uk ([89.16.172.20]:39776 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756411Ab2EOGtR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 02:49:17 -0400
From: Graeme Gregory <gg@slimlogic.co.uk>
To: linux-kernel@vger.kernel.org
Cc: sameo@linux.intel.com, lrg@ti.com, broonie@opensource.wolfsonmicro.com,
        b-cousson@ti.com, linux-omap@vger.kernel.org,
        Graeme Gregory <gg@slimlogic.co.uk>
Subject: [PATCHv2 2/4] MFD: palmas PMIC device support Kconfig
Date: Tue, 15 May 2012 15:48:57 +0900
Message-Id: <1337064539-3014-3-git-send-email-gg@slimlogic.co.uk>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1337064539-3014-1-git-send-email-gg@slimlogic.co.uk>
References: <1337064539-3014-1-git-send-email-gg@slimlogic.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the new palmas MFD to Kconfig and Makefile

Signed-off-by: Graeme Gregory <gg@slimlogic.co.uk>
---
 drivers/mfd/Kconfig  |   10 ++++++++++
 drivers/mfd/Makefile |    1 +
 2 files changed, 11 insertions(+)

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 9846424..8565658 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -909,6 +909,16 @@ config MFD_ANATOP
 	  MFD controller. This controller embeds regulator and
 	  thermal devices for Freescale i.MX platforms.
 
+config MFD_PALMAS
+	bool "Support for the TI Palmas series chips"
+	select MFD_CORE
+	select REGMAP_I2C
+	select REGMAP_IRQ
+	depends on I2C=y
+	help
+	  If you say yes here you get support for the Palmas
+	  series of PMIC chips from Texas Instruments.
+
 endmenu
 endif
 
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index acc888d..9ab5e37 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -118,3 +118,4 @@ obj-$(CONFIG_MFD_RC5T583)	+= rc5t583.o rc5t583-irq.o
 obj-$(CONFIG_MFD_S5M_CORE)	+= s5m-core.o s5m-irq.o
 obj-$(CONFIG_MFD_ANATOP)	+= anatop-mfd.o
 obj-$(CONFIG_MFD_LM3533)	+= lm3533-core.o lm3533-ctrlbank.o
+obj-$(CONFIG_MFD_PALMAS)	+= palmas.o
-- 
1.7.9.5

