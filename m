Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752861Ab1HOSRx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 14:17:53 -0400
Received: from smtp-out-020.synserver.de ([212.40.185.20]:1078 "HELO
	smtp-out-020.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750790Ab1HOSRm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 14:17:42 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@laprican.de
X-SynServer-PPID: 10030
From: Lars-Peter Clausen <lars@metafoo.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Cc: alsa-devel@alsa-project.org, device-drivers-devel@blackfin.uclinux.org,
        linux-kernel@vger.kernel.org, Mike Frysinger <vapier.adi@gmail.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Mike Frysinger <vapier@gentoo.org>
Subject: [PATCH 4/4] Blackfin: bf537: Stamp: Register ASoC EVAL-ADAU1373 board driver
Date: Mon, 15 Aug 2011 20:15:24 +0200
Message-Id: <1313432124-22591-4-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1313432124-22591-1-git-send-email-lars@metafoo.de>
References: <1313432124-22591-1-git-send-email-lars@metafoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Cc: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/mach-bf537/boards/stamp.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/arch/blackfin/mach-bf537/boards/stamp.c b/arch/blackfin/mach-bf537/boards/stamp.c
index 4037043..6662c37 100644
--- a/arch/blackfin/mach-bf537/boards/stamp.c
+++ b/arch/blackfin/mach-bf537/boards/stamp.c
@@ -2674,6 +2674,13 @@ static struct platform_device iio_gpio_trigger = {
 };
 #endif
 
+#if defined(CONFIG_SND_SOC_BFIN_EVAL_ADAU1373) || \
+	defined(CONFIG_SND_SOC_BFIN_EVAL_ADAU1373_MODULE)
+static struct platform_device bf5xx_adau1373_device = {
+	.name = "bfin-eval-adau1373",
+};
+#endif
+
 #if defined(CONFIG_SND_SOC_BFIN_EVAL_ADAU1701) || \
 	defined(CONFIG_SND_SOC_BFIN_EVAL_ADAU1701_MODULE)
 static struct platform_device bf5xx_adau1701_device = {
@@ -2842,6 +2849,11 @@ static struct platform_device *stamp_devices[] __initdata = {
 	&iio_gpio_trigger,
 #endif
 
+#if defined(CONFIG_SND_SOC_BFIN_EVAL_ADAU1373) || \
+	defined(CONFIG_SND_SOC_BFIN_EVAL_ADAU1373_MODULE)
+	&bf5xx_adau1373_device,
+#endif
+
 #if defined(CONFIG_SND_SOC_BFIN_EVAL_ADAU1701) || \
 	defined(CONFIG_SND_SOC_BFIN_EVAL_ADAU1701_MODULE)
 	&bf5xx_adau1701_device,
-- 
1.7.2.5

