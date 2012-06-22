Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762796Ab2FVXWQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 19:22:16 -0400
Received: from smtp.outflux.net ([198.145.64.163]:36278 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762774Ab2FVXWO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 19:22:14 -0400
Date: Fri, 22 Jun 2012 16:21:49 -0700
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Kees Cook <keescook@chromium.org>,
        Ola Lilja <ola.o.lilja@stericsson.com>, alsa-devel@alsa-project.org,
        Joshua Kroll <joshkroll@google.com>
Subject: [PATCH] sound: fix MODULE_LICENSE typos
Message-ID: <20120622232149.GA29819@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

include/linux/license.h does not recognize "GPLv2", so adjust these
declarations to add the needed space before the version.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 sound/soc/ux500/ux500_msp_dai.c |    2 +-
 sound/soc/ux500/ux500_msp_i2s.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/ux500/ux500_msp_dai.c b/sound/soc/ux500/ux500_msp_dai.c
index 93c6c40..62ac028 100644
--- a/sound/soc/ux500/ux500_msp_dai.c
+++ b/sound/soc/ux500/ux500_msp_dai.c
@@ -840,4 +840,4 @@ static struct platform_driver msp_i2s_driver = {
 };
 module_platform_driver(msp_i2s_driver);
 
-MODULE_LICENSE("GPLv2");
+MODULE_LICENSE("GPL v2");
diff --git a/sound/soc/ux500/ux500_msp_i2s.c b/sound/soc/ux500/ux500_msp_i2s.c
index 496dec1..ee14d2d 100644
--- a/sound/soc/ux500/ux500_msp_i2s.c
+++ b/sound/soc/ux500/ux500_msp_i2s.c
@@ -739,4 +739,4 @@ void ux500_msp_i2s_cleanup_msp(struct platform_device *pdev,
 	devm_kfree(&pdev->dev, msp);
 }
 
-MODULE_LICENSE("GPLv2");
+MODULE_LICENSE("GPL v2");
-- 
1.7.0.4

