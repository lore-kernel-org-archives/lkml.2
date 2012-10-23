Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964833Ab2JWUFz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 16:05:55 -0400
Received: from smtp.outflux.net ([198.145.64.163]:35395 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964821Ab2JWUFv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:05:51 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Shawn Guo <shawn.guo@linaro.org>, Timur Tabi <timur@freescale.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        =?UTF-8?q?Philippe=20R=C3=A9tornaz?= <philippe.retornaz@epfl.ch>
Subject: [PATCH 190/193] sound/soc/fsl: remove CONFIG_EXPERIMENTAL
Date: Tue, 23 Oct 2012 13:04:23 -0700
Message-Id: <1351022666-6960-191-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1351022666-6960-1-git-send-email-keescook@chromium.org>
References: <1351022666-6960-1-git-send-email-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This config item has not carried much meaning for a while now and is
almost always enabled by default. As agreed during the Linux kernel
summit, remove it.

CC: Liam Girdwood <lrg@ti.com>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Jaroslav Kysela <perex@perex.cz>
CC: Takashi Iwai <tiwai@suse.de>
CC: Shawn Guo <shawn.guo@linaro.org>
CC: Timur Tabi <timur@freescale.com>
CC: Sascha Hauer <s.hauer@pengutronix.de>
CC: "Philippe Rétornaz" <philippe.retornaz@epfl.ch>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 sound/soc/fsl/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/fsl/Kconfig b/sound/soc/fsl/Kconfig
index 4563b28..9f472aa 100644
--- a/sound/soc/fsl/Kconfig
+++ b/sound/soc/fsl/Kconfig
@@ -112,7 +112,7 @@ config SND_SOC_IMX_AUDMUX
 
 config SND_MXC_SOC_WM1133_EV1
 	tristate "Audio on the i.MX31ADS with WM1133-EV1 fitted"
-	depends on MACH_MX31ADS_WM1133_EV1 && EXPERIMENTAL
+	depends on MACH_MX31ADS_WM1133_EV1
 	select SND_SOC_WM8350
 	select SND_SOC_IMX_PCM_FIQ
 	select SND_SOC_IMX_AUDMUX
-- 
1.7.9.5

