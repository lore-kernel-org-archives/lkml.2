Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752066Ab1IVMw3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 08:52:29 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:56921 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751838Ab1IVMwZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 08:52:25 -0400
Subject: [PATCH] ASoC: Add Kconfig and Makefile entries for rt5631 codec
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: flove <flove@realtek.com>, Johnny Hsu <johnnyhsu@realtek.com>,
        Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 22 Sep 2011 20:52:12 +0800
Message-ID: <1316695932.6704.1.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/codecs/Kconfig  |    4 ++++
 sound/soc/codecs/Makefile |    2 ++
 2 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/sound/soc/codecs/Kconfig b/sound/soc/codecs/Kconfig
index 45c966c..3449431 100644
--- a/sound/soc/codecs/Kconfig
+++ b/sound/soc/codecs/Kconfig
@@ -40,6 +40,7 @@ config SND_SOC_ALL_CODECS
 	select SND_SOC_MAX9850 if I2C
 	select SND_SOC_MAX9877 if I2C
 	select SND_SOC_PCM3008
+	select SND_SOC_RT5631 if I2C
 	select SND_SOC_SGTL5000 if I2C
 	select SND_SOC_SN95031 if INTEL_SCU_IPC
 	select SND_SOC_SPDIF
@@ -219,6 +220,9 @@ config SND_SOC_MAX9850
 config SND_SOC_PCM3008
        tristate
 
+config SND_SOC_RT5631
+	tristate
+
 #Freescale sgtl5000 codec
 config SND_SOC_SGTL5000
 	tristate
diff --git a/sound/soc/codecs/Makefile b/sound/soc/codecs/Makefile
index 4f3ff24..787881b 100644
--- a/sound/soc/codecs/Makefile
+++ b/sound/soc/codecs/Makefile
@@ -26,6 +26,7 @@ snd-soc-max98088-objs := max98088.o
 snd-soc-max98095-objs := max98095.o
 snd-soc-max9850-objs := max9850.o
 snd-soc-pcm3008-objs := pcm3008.o
+snd-soc-rt5631-objs := rt5631.o
 snd-soc-sgtl5000-objs := sgtl5000.o
 snd-soc-alc5623-objs := alc5623.o
 snd-soc-sn95031-objs := sn95031.o
@@ -126,6 +127,7 @@ obj-$(CONFIG_SND_SOC_MAX98088)	+= snd-soc-max98088.o
 obj-$(CONFIG_SND_SOC_MAX98095)	+= snd-soc-max98095.o
 obj-$(CONFIG_SND_SOC_MAX9850)	+= snd-soc-max9850.o
 obj-$(CONFIG_SND_SOC_PCM3008)	+= snd-soc-pcm3008.o
+obj-$(CONFIG_SND_SOC_RT5631)	+= snd-soc-rt5631.o
 obj-$(CONFIG_SND_SOC_SGTL5000)  += snd-soc-sgtl5000.o
 obj-$(CONFIG_SND_SOC_SN95031)	+=snd-soc-sn95031.o
 obj-$(CONFIG_SND_SOC_SPDIF)	+= snd-soc-spdif.o
-- 
1.7.4.1



