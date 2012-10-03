Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753504Ab2JCOcZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 10:32:25 -0400
Received: from mail.tpi.com ([70.99.223.143]:2082 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752322Ab2JCOcY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 10:32:24 -0400
From: Tim Gardner <tim.gardner@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: Tim Gardner <tim.gardner@canonical.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Jarkko Nikula <jarkko.nikula@bitmer.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        linux-omap@vger.kernel.org, alsa-devel@alsa-project.org
Subject: [PATCH 3.7-rc1] omap zoom2.c: Fix compile error by including correct header files
Date: Wed,  3 Oct 2012 08:31:26 -0600
Message-Id: <1349274686-45668-1-git-send-email-tim.gardner@canonical.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Jarkko Nikula <jarkko.nikula@bitmer.com>
Cc: Liam Girdwood <lrg@ti.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Takashi Iwai <tiwai@suse.de>
Cc: linux-omap@vger.kernel.org
Cc: alsa-devel@alsa-project.org
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
---
 sound/soc/omap/zoom2.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/sound/soc/omap/zoom2.c b/sound/soc/omap/zoom2.c
index 23de2b2..d0a8c92 100644
--- a/sound/soc/omap/zoom2.c
+++ b/sound/soc/omap/zoom2.c
@@ -27,9 +27,10 @@
 
 #include <asm/mach-types.h>
 #include <mach/hardware.h>
-#include <mach/gpio.h>
+#include <linux/gpio.h>
 #include <mach/board-zoom.h>
 #include <linux/platform_data/asoc-ti-mcbsp.h>
+#include <linux/platform_data/gpio-omap.h>
 
 /* Register descriptions for twl4030 codec part */
 #include <linux/mfd/twl4030-audio.h>
-- 
1.7.9.5

