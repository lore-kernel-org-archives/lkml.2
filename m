Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752725Ab2KTInl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 03:43:41 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38976 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953Ab2KTInk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 03:43:40 -0500
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org, sachin.kamat@linaro.org, patches@linaro.org
Subject: [PATCH 1/1] staging: drm/imx: Remove duplicate inclusion of linux/videodev2.h
Date: Tue, 20 Nov 2012 14:07:16 +0530
Message-Id: <1353400636-26193-1-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

linux/videodev2.h was included twice.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 arch/arm/mach-omap2/board-overo.c           |    1 -
 drivers/staging/imx-drm/ipu-v3/imx-ipu-v3.h |    1 -
 2 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-omap2/board-overo.c b/arch/arm/mach-omap2/board-overo.c
index 1cfb037..f5ba43f 100644
--- a/arch/arm/mach-omap2/board-overo.c
+++ b/arch/arm/mach-omap2/board-overo.c
@@ -45,7 +45,6 @@
 #include <asm/mach/flash.h>
 #include <asm/mach/map.h>
 
-#include "common.h"
 #include <video/omapdss.h>
 #include <video/omap-panel-generic-dpi.h>
 #include <video/omap-panel-tfp410.h>
diff --git a/drivers/staging/imx-drm/ipu-v3/imx-ipu-v3.h b/drivers/staging/imx-drm/ipu-v3/imx-ipu-v3.h
index 22c1196..99d1cce 100644
--- a/drivers/staging/imx-drm/ipu-v3/imx-ipu-v3.h
+++ b/drivers/staging/imx-drm/ipu-v3/imx-ipu-v3.h
@@ -16,7 +16,6 @@
 #include <linux/videodev2.h>
 #include <linux/bitmap.h>
 #include <linux/fb.h>
-#include <linux/videodev2.h>
 
 struct ipu_soc;
 
-- 
1.7.4.1

