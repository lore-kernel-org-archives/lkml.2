Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755241Ab2DFJL5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 05:11:57 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:52819 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752377Ab2DFJL4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 05:11:56 -0400
Message-ID: <1333703506.3957.1.camel@phoenix>
Subject: [PATCH] gpio: Update GPIO_PCA953X Kconfig entry to include more
 supported devices
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Eric Miao <eric.y.miao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>
Date: Fri, 06 Apr 2012 17:11:46 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update the supported devices for gpio-pca953x driver.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/gpio/Kconfig |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index e03653d..b35ac52 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -243,7 +243,7 @@ config GPIO_MC9S08DZ60
 	  Select this to enable the MC9S08DZ60 GPIO driver
 
 config GPIO_PCA953X
-	tristate "PCA953x, PCA955x, TCA64xx, and MAX7310 I/O ports"
+	tristate "PCA953x, PCA955x, PCA957x, TCA64xx, and MAX7310 I/O ports"
 	depends on I2C
 	help
 	  Say yes here to provide access to several register-oriented
@@ -252,10 +252,11 @@ config GPIO_PCA953X
 
 	  4 bits:	pca9536, pca9537
 
-	  8 bits:	max7310, pca9534, pca9538, pca9554, pca9557,
-	  		tca6408
+	  8 bits:	max7310, max7315, pca6107, pca9534, pca9538, pca9554,
+			pca9556, pca9557, pca9574, tca6408
 
-	  16 bits:	pca9535, pca9539, pca9555, tca6416
+	  16 bits:	max7312, max7313, pca9535, pca9539, pca9555, pca9575,
+			tca6416
 
 config GPIO_PCA953X_IRQ
 	bool "Interrupt controller support for PCA953x"
-- 
1.7.5.4



