Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755762Ab3AHKjN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 05:39:13 -0500
Received: from [212.90.139.82] ([212.90.139.82]:26825 "EHLO smtp2.goneo.de"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755419Ab3AHKjL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 05:39:11 -0500
X-Spam-Flag: NO
X-Spam-Score: -2.898
From: Lars Poeschel <poeschel@lemonage.de>
To: linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH for-next] mfd: tps65910: add REGMAP_IRQ to Kconfig
Date: Tue, 8 Jan 2013 11:39:03 +0100
User-Agent: KMail/1.13.7 (Linux/3.2.0-4-amd64; KDE/4.8.4; x86_64; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201301081139.03471.poeschel@lemonage.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lars Poeschel <poeschel@lemonage.de>

tps65910 driver is using regmap irq, so selecting it in
Kconfig to honor this.

Signed-off-by: Lars Poeschel <poeschel@lemonage.de>
---
 drivers/mfd/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 50bbe88..69a8d8c 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -238,6 +238,7 @@ config MFD_TPS65910
 	depends on I2C=y && GPIOLIB
 	select MFD_CORE
 	select REGMAP_I2C
+	select REGMAP_IRQ
 	select IRQ_DOMAIN
 	help
 	  if you say yes here you get support for the TPS65910 series of
-- 
1.7.10.4

