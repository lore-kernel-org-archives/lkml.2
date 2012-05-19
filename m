Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754000Ab2ESRPS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2012 13:15:18 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:34516 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751248Ab2ESRPQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2012 13:15:16 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>,
        Thierry Reding <thierry.reding@avionic-design.de>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] mfd: tpx6586x:  Depend on regulator
Date: Sat, 19 May 2012 18:15:12 +0100
Message-Id: <1337447712-9879-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some of the OF binding stuff is done in the MFD.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---

It just went ahead and applied this.

 drivers/mfd/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 1f887a2..f15273c 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -175,6 +175,7 @@ config MFD_TPS6586X
 	bool "TPS6586x Power Management chips"
 	depends on I2C=y && GPIOLIB && GENERIC_HARDIRQS
 	select MFD_CORE
+	depends on REGULATOR
 	help
 	  If you say yes here you get support for the TPS6586X series of
 	  Power Management chips.
-- 
1.7.10

