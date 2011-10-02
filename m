Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753544Ab1JBOuO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Oct 2011 10:50:14 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:59075 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752774Ab1JBOrE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Oct 2011 10:47:04 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Tony Lindgren <tony@atomide.com>
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Jarkko Nikula <jarkko.nikula@bitmer.com>, Liam Girdwood <lrg@ti.com>
Subject: [PATCH 21/30] sound/soc/omap: limit to omap2plus
Date: Sun,  2 Oct 2011 16:45:51 +0200
Message-Id: <1317566760-25681-22-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1317566760-25681-1-git-send-email-arnd@arndb.de>
References: <1317566760-25681-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:+VMKr4wygBonJo2L99WVoM9nWWWtBMajdVcDBGuv34e
 o9GRrwhNwA1d8gYyEWevBF9wH5HaOwc2NPfN4G81/RtoZVxTNN
 OwIsR2bV692cQIoanJr1FJ/D4xrg4f1Mxh2Hy1zdoFNeWzFYrJ
 cvUG9L70IxzpIPsNy7PVKj9+YEKXNBP4gNznh8fkOZRJgu3Ydh
 bk4FtZAXy0ClL/jepfWP6pPvnh5OQ7PgG6WJ9lWPAJSbgoFBSh
 9eSYduuw2tRUE2p9weWlLPuPPS1nPbtbc4MiPi7WefUEJyXvke
 PncdnX4QrohZlQvi7FlCJAyf+FqAR4jJjmM/+l7837lossC315
 cOYYHdT9g1Fq+nfwmdNkMgfLy9zKS5kSlsx7gpdwrc+BgJ6X7f
 Cgu48VWo4SNow==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These drivers do not build correctly on omap1, so only allow
selecting them on omap2 or higher.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Jarkko Nikula <jarkko.nikula@bitmer.com>
Cc: Liam Girdwood <lrg@ti.com>
---
 sound/soc/omap/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/sound/soc/omap/Kconfig b/sound/soc/omap/Kconfig
index fe83d0d..493733e 100644
--- a/sound/soc/omap/Kconfig
+++ b/sound/soc/omap/Kconfig
@@ -1,6 +1,6 @@
 config SND_OMAP_SOC
 	tristate "SoC Audio for the Texas Instruments OMAP chips"
-	depends on ARCH_OMAP
+	depends on ARCH_OMAP2PLUS
 
 config SND_OMAP_SOC_MCBSP
 	tristate
-- 
1.7.5.4

