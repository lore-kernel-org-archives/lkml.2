Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031616Ab2COP6x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 11:58:53 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:62488 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031490Ab2COP6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 11:58:49 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: linux-arm-kernel@lists.infradead.org, plagnioj@jcrosoft.com
Cc: linux-kernel@vger.kernel.org, ludovic.desroches@atmel.com,
        dmitry.torokhov@gmail.com, mpm@selenic.com,
        herbert@gondor.hengli.com.au, vinod.koul@intel.com,
        a.zummo@towertech.it, Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH 6/6] hwrng: Kconfig: remove dependency for atmel-rng driver
Date: Thu, 15 Mar 2012 16:57:22 +0100
Message-Id: <c3455cec019bedacc6ff58cf8cd2ae25cdeb212f.1331826095.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <cover.1331826095.git.nicolas.ferre@atmel.com>
References: <cover.1331826095.git.nicolas.ferre@atmel.com>
In-Reply-To: <cover.1331826095.git.nicolas.ferre@atmel.com>
References: <cover.1331826095.git.nicolas.ferre@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This will allow to select this driver for newer SoCs. Make sure to
keep dependency on HAVE_CLK to avoid breaking other machines.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 drivers/char/hw_random/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/char/hw_random/Kconfig b/drivers/char/hw_random/Kconfig
index 0689bf6..b2402eb 100644
--- a/drivers/char/hw_random/Kconfig
+++ b/drivers/char/hw_random/Kconfig
@@ -62,7 +62,7 @@ config HW_RANDOM_AMD
 
 config HW_RANDOM_ATMEL
 	tristate "Atmel Random Number Generator support"
-	depends on HW_RANDOM && ARCH_AT91SAM9G45
+	depends on HW_RANDOM && HAVE_CLK
 	default HW_RANDOM
 	---help---
 	  This driver provides kernel-side support for the Random Number
-- 
1.7.9

