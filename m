Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756897Ab0F3QDP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 12:03:15 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:40134 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754538Ab0F3QDM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 12:03:12 -0400
Date: Wed, 30 Jun 2010 18:03:10 +0200
From: Christoph Egger <siccegge@cs.fau.de>
To: Ben Dooks <ben-linux@fluff.org>, Russell King <linux@arm.linux.org.uk>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Jassi Brar <jassi.brar@samsung.com>,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: vamos@i4.informatik.uni-erlangen.de
Subject: [PATCH 29/33] Removing dead SND_SOC_SMDK2443_WM9710
Message-ID: <e5391de6858597bbfd43874aed124a73f74850b5.1277911346.git.siccegge@cs.fau.de>
References: <cover.1277911345.git.siccegge@cs.fau.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1277911345.git.siccegge@cs.fau.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SND_SOC_SMDK2443_WM9710 doesn't exist in Kconfig, therefore removing
all references for it from the source code.

Signed-off-by: Christoph Egger <siccegge@cs.fau.de>
---
 arch/arm/mach-s3c2443/mach-smdk2443.c |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/arch/arm/mach-s3c2443/mach-smdk2443.c b/arch/arm/mach-s3c2443/mach-smdk2443.c
index 4c863d3..47414c9 100644
--- a/arch/arm/mach-s3c2443/mach-smdk2443.c
+++ b/arch/arm/mach-s3c2443/mach-smdk2443.c
@@ -106,9 +106,6 @@ static struct platform_device *smdk2443_devices[] __initdata = {
 	&s3c_device_wdt,
 	&s3c_device_i2c0,
 	&s3c_device_hsmmc0,
-#ifdef CONFIG_SND_SOC_SMDK2443_WM9710
-	&s3c_device_ac97,
-#endif
 };
 
 static void __init smdk2443_map_io(void)
@@ -122,10 +119,6 @@ static void __init smdk2443_machine_init(void)
 {
 	s3c_i2c0_set_platdata(NULL);
 
-#ifdef CONFIG_SND_SOC_SMDK2443_WM9710
-	s3c24xx_ac97_setup_gpio(S3C24XX_AC97_GPE0);
-#endif
-
 	platform_add_devices(smdk2443_devices, ARRAY_SIZE(smdk2443_devices));
 	smdk_machine_init();
 }
-- 
1.7.0.4

