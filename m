Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964963Ab2JWUIi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 16:08:38 -0400
Received: from smtp.outflux.net ([198.145.64.163]:36752 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964942Ab2JWUIe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:08:34 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Tomasz Stanislawski <t.stanislaws@samsung.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 067/193] drivers/media/video/s5p-tv: remove CONFIG_EXPERIMENTAL
Date: Tue, 23 Oct 2012 13:02:20 -0700
Message-Id: <1351022666-6960-68-git-send-email-keescook@chromium.org>
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
CC: Tomasz Stanislawski <t.stanislaws@samsung.com>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/media/platform/s5p-tv/Kconfig |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/media/platform/s5p-tv/Kconfig b/drivers/media/platform/s5p-tv/Kconfig
index ea11a51..7b659bd 100644
--- a/drivers/media/platform/s5p-tv/Kconfig
+++ b/drivers/media/platform/s5p-tv/Kconfig
@@ -7,9 +7,8 @@
 # Licensed under GPL
 
 config VIDEO_SAMSUNG_S5P_TV
-	bool "Samsung TV driver for S5P platform (experimental)"
+	bool "Samsung TV driver for S5P platform"
 	depends on PLAT_S5P && PM_RUNTIME
-	depends on EXPERIMENTAL
 	default n
 	---help---
 	  Say Y here to enable selecting the TV output devices for
-- 
1.7.9.5

