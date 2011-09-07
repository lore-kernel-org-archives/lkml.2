Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756250Ab1IGSRV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 14:17:21 -0400
Received: from unicorn.mansr.com ([78.86.181.103]:42988 "EHLO
	unicorn.mansr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755850Ab1IGSRU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 14:17:20 -0400
X-Greylist: delayed 4206 seconds by postgrey-1.27 at vger.kernel.org; Wed, 07 Sep 2011 14:17:20 EDT
From: Mans Rullgard <mans.rullgard@linaro.org>
To: linux-omap@vger.kernel.org
Cc: linaro-dev@lists.linaro.org, Jarkko Nikula <jhnikula@gmail.com>,
        Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] ASoC: omap: add MODULE_ALIAS to mcbsp and pcm drivers
Date: Wed,  7 Sep 2011 12:07:21 +0100
Message-Id: <1315393641-21261-1-git-send-email-mans.rullgard@linaro.org>
X-Mailer: git-send-email 1.7.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds MODULE_ALIAS directives to the omap-mcbsp-dai and
omap-pcm-audio drivers so they can be auto-loaded when platform
devices are scanned.

Signed-off-by: Mans Rullgard <mans.rullgard@linaro.org>
---
 sound/soc/omap/omap-mcbsp.c |    1 +
 sound/soc/omap/omap-pcm.c   |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/sound/soc/omap/omap-mcbsp.c b/sound/soc/omap/omap-mcbsp.c
index 07b7723..5ddfadd 100644
--- a/sound/soc/omap/omap-mcbsp.c
+++ b/sound/soc/omap/omap-mcbsp.c
@@ -783,3 +783,4 @@ module_exit(snd_omap_mcbsp_exit);
 MODULE_AUTHOR("Jarkko Nikula <jhnikula@gmail.com>");
 MODULE_DESCRIPTION("OMAP I2S SoC Interface");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:omap-mcbsp-dai");
diff --git a/sound/soc/omap/omap-pcm.c b/sound/soc/omap/omap-pcm.c
index e6a6b99..f19ccc1 100644
--- a/sound/soc/omap/omap-pcm.c
+++ b/sound/soc/omap/omap-pcm.c
@@ -437,3 +437,4 @@ module_exit(snd_omap_pcm_exit);
 MODULE_AUTHOR("Jarkko Nikula <jhnikula@gmail.com>");
 MODULE_DESCRIPTION("OMAP PCM DMA module");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:omap-pcm-audio");
-- 
1.7.6.1

