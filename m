Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756367Ab2F0Pv4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 11:51:56 -0400
Received: from mail.work-microwave.de ([62.245.205.51]:36190 "EHLO
	work-microwave.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751546Ab2F0Pvv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 11:51:51 -0400
From: Roland Stigge <stigge@antcom.de>
To: dedekind1@gmail.com, linux-mtd@lists.infradead.org, aletes.xgr@gmail.com,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, dwmw2@infradead.org,
        kevin.wells@nxp.com, srinivas.bakki@nxp.com,
        linux-arm-kernel@lists.infradead.org, hechtb@googlemail.com,
        lars@metafoo.de, b32955@freescale.com, leiwen@marvell.com,
        linux@arm.linux.org.uk
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH 1/4] mtd: lpc32xx_slc: Select AMBA_PL08X in Kconfig
Date: Wed, 27 Jun 2012 17:51:12 +0200
Message-Id: <1340812275-1197-1-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 1.7.10.4
X-FEAS-SYSTEM-WL: rst@work-microwave.de, 192.168.11.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexandre Pereira da Silva <aletes.xgr@gmail.com>

Since this driver depends on the amba pl08x dma driver, select it in Kconfig.

Signed-off-by: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
Signed-off-by: Roland Stigge <stigge@antcom.de>
---
 drivers/mtd/nand/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mtd/nand/Kconfig b/drivers/mtd/nand/Kconfig
index de69978..a9e8b73 100644
--- a/drivers/mtd/nand/Kconfig
+++ b/drivers/mtd/nand/Kconfig
@@ -417,6 +417,7 @@ config MTD_NAND_PXA3xx
 config MTD_NAND_SLC_LPC32XX
 	tristate "NXP LPC32xx SLC Controller"
 	depends on ARCH_LPC32XX
+	select AMBA_PL08X
 	help
 	  Enables support for NXP's LPC32XX SLC (i.e. for Single Level Cell
 	  chips) NAND controller. This is the default for the PHYTEC 3250
-- 
1.7.10.4

