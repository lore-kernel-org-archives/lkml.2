Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751569Ab2DBIY1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 04:24:27 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:49281 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082Ab2DBIY0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 04:24:26 -0400
From: Martin Jansa <martin.jansa@gmail.com>
To: Rob Herring <rob.herring@calxeda.com>
Cc: Martin Jansa <Martin.Jansa@gmail.com>,
        Eric Miao <eric.y.miao@gmail.com> (maintainer:PXA2xx/PXA3xx SUP...),
        Russell King <linux@arm.linux.org.uk> (maintainer:PXA2xx/PXA3xx
	SUP...),
        Haojian Zhuang <haojian.zhuang@gmail.com> (maintainer:PXA2xx/PXA3xx
	SUP...),
        Liam Girdwood <lrg@ti.com> (supporter:SOUND - SOC LAYER...),
        Mark Brown <broonie@opensource.wolfsonmicro.com> (supporter:SOUND -
	SOC LAYER...),
        Jaroslav Kysela <perex@perex.cz> (maintainer:SOUND),
        Takashi Iwai <tiwai@suse.de> (maintainer:SOUND),
        linux-arm-kernel@lists.infradead.org (moderated list:PXA2xx/PXA3xx
	SUP...),
        alsa-devel@alsa-project.org (moderated list:SOUND - SOC LAYER...),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] ARM: pxa: pxa2xx-i2s: add io.h for IOMEM macro
Date: Mon,  2 Apr 2012 10:24:08 +0200
Message-Id: <1333355048-732-1-git-send-email-Martin.Jansa@gmail.com>
X-Mailer: git-send-email 1.7.8.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* fixes
  sound/soc/pxa/pxa2xx-i2s.c:86:2: error: implicit declaration of function 'IOMEM' [-Werror=implicit-function-declaration]
  sound/soc/pxa/pxa2xx-i2s.c:86:2: error: initializer element is not constant
  after 23019a733bb83c8499f192fb428b7e6e81c95a34 removed IOMEM
  definition from arch/arm/mach-pxa/include/mach/hardware.h

Signed-off-by: Martin Jansa <Martin.Jansa@gmail.com>
---
 sound/soc/pxa/pxa2xx-i2s.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/sound/soc/pxa/pxa2xx-i2s.c b/sound/soc/pxa/pxa2xx-i2s.c
index 609abd5..d085837 100644
--- a/sound/soc/pxa/pxa2xx-i2s.c
+++ b/sound/soc/pxa/pxa2xx-i2s.c
@@ -17,6 +17,7 @@
 #include <linux/delay.h>
 #include <linux/clk.h>
 #include <linux/platform_device.h>
+#include <linux/io.h>
 #include <sound/core.h>
 #include <sound/pcm.h>
 #include <sound/initval.h>
-- 
1.7.8.5

