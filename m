Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755912Ab1HKNLY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 09:11:24 -0400
Received: from bitmer.com ([213.157.87.50]:41512 "EHLO bitmer.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755688Ab1HKNLW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 09:11:22 -0400
X-Greylist: delayed 1552 seconds by postgrey-1.27 at vger.kernel.org; Thu, 11 Aug 2011 09:11:22 EDT
From: Jarkko Nikula <jarkko.nikula@bitmer.com>
To: alsa-devel@alsa-project.org
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Jarkko Nikula <jarkko.nikula@bitmer.com>
Subject: [PATCH] ASoC: omap: Update e-mail address of Jarkko Nikula
Date: Thu, 11 Aug 2011 15:44:57 +0300
Message-Id: <1313066697-18635-1-git-send-email-jarkko.nikula@bitmer.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My gmail account got disabled and I'm not going to reopen it.

Signed-off-by: Jarkko Nikula <jarkko.nikula@bitmer.com>
---
Be careful about your age in google+ registration...
---
 MAINTAINERS                 |    2 +-
 include/sound/tlv320aic3x.h |    2 +-
 sound/soc/omap/n810.c       |    4 ++--
 sound/soc/omap/omap-mcbsp.c |    4 ++--
 sound/soc/omap/omap-mcbsp.h |    2 +-
 sound/soc/omap/omap-pcm.c   |    4 ++--
 sound/soc/omap/omap-pcm.h   |    2 +-
 sound/soc/omap/rx51.c       |    2 +-
 8 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 1f8267f..3e6b34c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4604,7 +4604,7 @@ F:	arch/arm/mach-omap2/clockdomain2xxx_3xxx.c
 F:	arch/arm/mach-omap2/clockdomain44xx.c
 
 OMAP AUDIO SUPPORT
-M:	Jarkko Nikula <jhnikula@gmail.com>
+M:	Jarkko Nikula <jarkko.nikula@bitmer.com>
 L:	alsa-devel@alsa-project.org (subscribers-only)
 L:	linux-omap@vger.kernel.org
 S:	Maintained
diff --git a/include/sound/tlv320aic3x.h b/include/sound/tlv320aic3x.h
index 99e0308..ffd9bc7 100644
--- a/include/sound/tlv320aic3x.h
+++ b/include/sound/tlv320aic3x.h
@@ -1,7 +1,7 @@
 /*
  * Platform data for Texas Instruments TLV320AIC3x codec
  *
- * Author: Jarkko Nikula <jhnikula@gmail.com>
+ * Author: Jarkko Nikula <jarkko.nikula@bitmer.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
diff --git a/sound/soc/omap/n810.c b/sound/soc/omap/n810.c
index 83d213b..62e292f 100644
--- a/sound/soc/omap/n810.c
+++ b/sound/soc/omap/n810.c
@@ -3,7 +3,7 @@
  *
  * Copyright (C) 2008 Nokia Corporation
  *
- * Contact: Jarkko Nikula <jhnikula@gmail.com>
+ * Contact: Jarkko Nikula <jarkko.nikula@bitmer.com>
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License
@@ -402,6 +402,6 @@ static void __exit n810_soc_exit(void)
 module_init(n810_soc_init);
 module_exit(n810_soc_exit);
 
-MODULE_AUTHOR("Jarkko Nikula <jhnikula@gmail.com>");
+MODULE_AUTHOR("Jarkko Nikula <jarkko.nikula@bitmer.com>");
 MODULE_DESCRIPTION("ALSA SoC Nokia N810");
 MODULE_LICENSE("GPL");
diff --git a/sound/soc/omap/omap-mcbsp.c b/sound/soc/omap/omap-mcbsp.c
index 07b7723..ebcc2d4 100644
--- a/sound/soc/omap/omap-mcbsp.c
+++ b/sound/soc/omap/omap-mcbsp.c
@@ -3,7 +3,7 @@
  *
  * Copyright (C) 2008 Nokia Corporation
  *
- * Contact: Jarkko Nikula <jhnikula@gmail.com>
+ * Contact: Jarkko Nikula <jarkko.nikula@bitmer.com>
  *          Peter Ujfalusi <peter.ujfalusi@ti.com>
  *
  * This program is free software; you can redistribute it and/or
@@ -780,6 +780,6 @@ static void __exit snd_omap_mcbsp_exit(void)
 }
 module_exit(snd_omap_mcbsp_exit);
 
-MODULE_AUTHOR("Jarkko Nikula <jhnikula@gmail.com>");
+MODULE_AUTHOR("Jarkko Nikula <jarkko.nikula@bitmer.com>");
 MODULE_DESCRIPTION("OMAP I2S SoC Interface");
 MODULE_LICENSE("GPL");
diff --git a/sound/soc/omap/omap-mcbsp.h b/sound/soc/omap/omap-mcbsp.h
index 9a7dedd..65cde9d 100644
--- a/sound/soc/omap/omap-mcbsp.h
+++ b/sound/soc/omap/omap-mcbsp.h
@@ -3,7 +3,7 @@
  *
  * Copyright (C) 2008 Nokia Corporation
  *
- * Contact: Jarkko Nikula <jhnikula@gmail.com>
+ * Contact: Jarkko Nikula <jarkko.nikula@bitmer.com>
  *          Peter Ujfalusi <peter.ujfalusi@ti.com>
  *
  * This program is free software; you can redistribute it and/or
diff --git a/sound/soc/omap/omap-pcm.c b/sound/soc/omap/omap-pcm.c
index b2f5751..9b5c88a 100644
--- a/sound/soc/omap/omap-pcm.c
+++ b/sound/soc/omap/omap-pcm.c
@@ -3,7 +3,7 @@
  *
  * Copyright (C) 2008 Nokia Corporation
  *
- * Contact: Jarkko Nikula <jhnikula@gmail.com>
+ * Contact: Jarkko Nikula <jarkko.nikula@bitmer.com>
  *          Peter Ujfalusi <peter.ujfalusi@ti.com>
  *
  * This program is free software; you can redistribute it and/or
@@ -436,6 +436,6 @@ static void __exit snd_omap_pcm_exit(void)
 }
 module_exit(snd_omap_pcm_exit);
 
-MODULE_AUTHOR("Jarkko Nikula <jhnikula@gmail.com>");
+MODULE_AUTHOR("Jarkko Nikula <jarkko.nikula@bitmer.com>");
 MODULE_DESCRIPTION("OMAP PCM DMA module");
 MODULE_LICENSE("GPL");
diff --git a/sound/soc/omap/omap-pcm.h b/sound/soc/omap/omap-pcm.h
index a0ed1db..f95fe30 100644
--- a/sound/soc/omap/omap-pcm.h
+++ b/sound/soc/omap/omap-pcm.h
@@ -3,7 +3,7 @@
  *
  * Copyright (C) 2008 Nokia Corporation
  *
- * Contact: Jarkko Nikula <jhnikula@gmail.com>
+ * Contact: Jarkko Nikula <jarkko.nikula@bitmer.com>
  *          Peter Ujfalusi <peter.ujfalusi@ti.com>
  *
  * This program is free software; you can redistribute it and/or
diff --git a/sound/soc/omap/rx51.c b/sound/soc/omap/rx51.c
index 0aae998..893300a 100644
--- a/sound/soc/omap/rx51.c
+++ b/sound/soc/omap/rx51.c
@@ -5,7 +5,7 @@
  *
  * Contact: Peter Ujfalusi <peter.ujfalusi@ti.com>
  *          Eduardo Valentin <eduardo.valentin@nokia.com>
- *          Jarkko Nikula <jhnikula@gmail.com>
+ *          Jarkko Nikula <jarkko.nikula@bitmer.com>
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License
-- 
1.7.2.5

