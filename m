Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759009Ab2ECWX6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 18:23:58 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:35213 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758912Ab2ECWWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 18:22:37 -0400
From: mathieu.poirier@linaro.org
To: mchehab@infradead.org
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org, arnd@arndb.de,
        mathieu.poirier@linaro.org
Subject: [PATCH 4/6] media/video: add I2C dependencies
Date: Thu,  3 May 2012 16:22:25 -0600
Message-Id: <1336083747-3142-5-git-send-email-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1336083747-3142-1-git-send-email-mathieu.poirier@linaro.org>
References: <1336083747-3142-1-git-send-email-mathieu.poirier@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

Davinci VIDEO_VPFE_CAPTURE depends on I2C, so reflect that
in Kconfig to avoid build failures in random configurations.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
---
 drivers/media/video/davinci/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/davinci/Kconfig b/drivers/media/video/davinci/Kconfig
index 60a456e..9337b56 100644
--- a/drivers/media/video/davinci/Kconfig
+++ b/drivers/media/video/davinci/Kconfig
@@ -40,6 +40,7 @@ config VIDEO_VPSS_SYSTEM
 config VIDEO_VPFE_CAPTURE
 	tristate "VPFE Video Capture Driver"
 	depends on VIDEO_V4L2 && (ARCH_DAVINCI || ARCH_OMAP3)
+	depends on I2C
 	select VIDEOBUF_DMA_CONTIG
 	help
 	  Support for DMx/AMx VPFE based frame grabber. This is the
-- 
1.7.5.4

