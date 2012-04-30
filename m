Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756003Ab2D3JtS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 05:49:18 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:54308 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752741Ab2D3JtR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 05:49:17 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <herbert@gondor.hengli.com.au>
CC: <broonie@opensource.wolfsonmicro.com>, <arnd@arndb.de>, <olof@lixom.net>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH] hwrng: Kconfig: modify default state for atmel-rng driver
Date: Mon, 30 Apr 2012 11:49:13 +0200
Message-ID: <1335779353-9515-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <20120427173504.GK18260@opensource.wolfsonmicro.com>
References: <20120427173504.GK18260@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.159.245.203]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to prevent building the Atmel hw_random driver for each and every
configuration, add a "default" Kconfig state in relation with
CONFIG_ARCH_AT91.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 drivers/char/hw_random/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/hw_random/Kconfig b/drivers/char/hw_random/Kconfig
index b2402eb..d98998f 100644
--- a/drivers/char/hw_random/Kconfig
+++ b/drivers/char/hw_random/Kconfig
@@ -63,7 +63,7 @@ config HW_RANDOM_AMD
 config HW_RANDOM_ATMEL
 	tristate "Atmel Random Number Generator support"
 	depends on HW_RANDOM && HAVE_CLK
-	default HW_RANDOM
+	default (HW_RANDOM && ARCH_AT91)
 	---help---
 	  This driver provides kernel-side support for the Random Number
 	  Generator hardware found on Atmel AT91 devices.
-- 
1.7.10

