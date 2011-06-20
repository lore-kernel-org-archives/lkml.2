Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752940Ab1FTKqr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 06:46:47 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:36122 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752779Ab1FTKqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 06:46:43 -0400
From: Tushar Behera <tushar.behera@linaro.org>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-fbdev@vger.kernel.org, linux-omap@vger.kernel.org
Cc: linux@arm.linux.org.uk, tony@atomide.com, lethal@linux-sh.org,
        linaro-dev@lists.linaro.org, patches@linaro.org,
        Tomi Valkeinen <tomi.valkeinen@nokia.com>
Subject: [PATCH 2/2] video: omap2: Compile omap2 support only when needed
Date: Mon, 20 Jun 2011 16:16:01 +0530
Message-Id: <1308566761-2850-3-git-send-email-tushar.behera@linaro.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1308566761-2850-1-git-send-email-tushar.behera@linaro.org>
References: <1308566761-2850-1-git-send-email-tushar.behera@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently display support for omap2 is selected by default and
it gets built for all the configurations.

Instead of it being a built-in feature, it's compilation should
depend on the config option CONFIG_FB_OMAP2.

Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Tomi Valkeinen <tomi.valkeinen@nokia.com>
Cc: Tony Lindgren <tony@atomide.com>
Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
---
 drivers/video/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/video/Makefile b/drivers/video/Makefile
index 8b83129..a19e44e 100644
--- a/drivers/video/Makefile
+++ b/drivers/video/Makefile
@@ -133,7 +133,7 @@ obj-$(CONFIG_FB_SH_MOBILE_HDMI)	  += sh_mobile_hdmi.o
 obj-$(CONFIG_FB_SH_MOBILE_MERAM)  += sh_mobile_meram.o
 obj-$(CONFIG_FB_SH_MOBILE_LCDC)	  += sh_mobile_lcdcfb.o
 obj-$(CONFIG_FB_OMAP)             += omap/
-obj-y                             += omap2/
+obj-$(CONFIG_FB_OMAP2)            += omap2/
 obj-$(CONFIG_XEN_FBDEV_FRONTEND)  += xen-fbfront.o
 obj-$(CONFIG_FB_CARMINE)          += carminefb.o
 obj-$(CONFIG_FB_MB862XX)	  += mb862xx/
-- 
1.7.4.1

