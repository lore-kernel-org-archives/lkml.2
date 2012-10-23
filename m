Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964906Ab2JWUIO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 16:08:14 -0400
Received: from smtp.outflux.net ([198.145.64.163]:36419 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933606Ab2JWUIL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:08:11 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 066/193] drivers/media/video/s5p-fimc: remove CONFIG_EXPERIMENTAL
Date: Tue, 23 Oct 2012 13:02:19 -0700
Message-Id: <1351022666-6960-67-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1351022666-6960-1-git-send-email-keescook@chromium.org>
References: <1351022666-6960-1-git-send-email-keescook@chromium.org>
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This config item has not carried much meaning for a while now and is
almost always enabled by default. As agreed during the Linux kernel
summit, remove it.

CC: Kyungmin Park <kyungmin.park@samsung.com>
CC: Sylwester Nawrocki <s.nawrocki@samsung.com>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/media/platform/s5p-fimc/Kconfig |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/media/platform/s5p-fimc/Kconfig b/drivers/media/platform/s5p-fimc/Kconfig
index 8f090a8..9b80ca8 100644
--- a/drivers/media/platform/s5p-fimc/Kconfig
+++ b/drivers/media/platform/s5p-fimc/Kconfig
@@ -2,7 +2,6 @@
 config VIDEO_SAMSUNG_S5P_FIMC
 	bool "Samsung S5P/EXYNOS SoC camera interface driver (experimental)"
 	depends on VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API && PLAT_S5P && PM_RUNTIME
-	depends on EXPERIMENTAL
 	help
 	  Say Y here to enable camera host interface devices for
 	  Samsung S5P and EXYNOS SoC series.
-- 
1.7.9.5

