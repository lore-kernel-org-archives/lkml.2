Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753031Ab2H2G56 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2012 02:57:58 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59743 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185Ab2H2G5z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2012 02:57:55 -0400
Message-ID: <1346223466.17293.0.camel@phoenix>
Subject: [PATCH] gpio: Remove broken mark for da9052 gpio driver
From: Axel Lin <axel.lin@gmail.com>
To: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>
Cc: David Dajun Chen <dchen@diasemi.com>,
        Ashish Jangam <ashish.jangam@kpitcummins.com>,
        linux-kernel@vger.kernel.org
Date: Wed, 29 Aug 2012 14:57:46 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The fix for MFD part is merged so remove the broken mark for da9052 gpio driver.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/gpio/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index ba7926f5..95778f1 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -82,7 +82,7 @@ config GPIO_GENERIC
 
 config GPIO_DA9052
 	tristate "Dialog DA9052 GPIO"
-	depends on PMIC_DA9052 && BROKEN
+	depends on PMIC_DA9052
 	help
 	  Say yes here to enable the GPIO driver for the DA9052 chip.
 
-- 
1.7.9.5



