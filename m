Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751962Ab2BIFU5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 00:20:57 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:47682 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750790Ab2BIFUz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 00:20:55 -0500
From: "Manjunathappa, Prakash" <prakash.pm@ti.com>
To: <linux-fbdev@vger.kernel.org>
CC: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-kernel@vger.kernel.org>,
        "Manjunathappa, Prakash" <prakash.pm@ti.com>
Subject: [PATCH] video: da8xx-fb: Fix build warning on unused label
Date: Thu, 9 Feb 2012 10:34:38 +0530
Message-ID: <1328763879-16345-1-git-send-email-prakash.pm@ti.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch fixes build warning on label "err_cpu_freq" when CONFIG_CPU_FREQ
is not defined.

Signed-off-by: Manjunathappa, Prakash <prakash.pm@ti.com>
---
 drivers/video/da8xx-fb.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/video/da8xx-fb.c b/drivers/video/da8xx-fb.c
index 29577bf..f360d62 100644
--- a/drivers/video/da8xx-fb.c
+++ b/drivers/video/da8xx-fb.c
@@ -1264,8 +1264,8 @@ static int __devinit fb_probe(struct platform_device *device)
 irq_freq:
 #ifdef CONFIG_CPU_FREQ
 	lcd_da8xx_cpufreq_deregister(par);
-#endif
 err_cpu_freq:
+#endif
 	unregister_framebuffer(da8xx_fb_info);
 
 err_dealloc_cmap:
-- 
1.7.1

