Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965564Ab2JWVFg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 17:05:36 -0400
Received: from smtp.outflux.net ([198.145.64.163]:57498 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933685Ab2JWUFL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:05:11 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Chris Ball <cjb@laptop.org>
Subject: [PATCH 070/193] drivers/mmc/core: remove CONFIG_EXPERIMENTAL
Date: Tue, 23 Oct 2012 13:02:23 -0700
Message-Id: <1351022666-6960-71-git-send-email-keescook@chromium.org>
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

CC: Chris Ball <cjb@laptop.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/mmc/core/Kconfig |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/mmc/core/Kconfig b/drivers/mmc/core/Kconfig
index ef10387..269d072 100644
--- a/drivers/mmc/core/Kconfig
+++ b/drivers/mmc/core/Kconfig
@@ -18,8 +18,7 @@ config MMC_UNSAFE_RESUME
 	  module parameter "removable=0" or "removable=1".
 
 config MMC_CLKGATE
-	bool "MMC host clock gating (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
+	bool "MMC host clock gating"
 	help
 	  This will attempt to aggressively gate the clock to the MMC card.
 	  This is done to save power due to gating off the logic and bus
-- 
1.7.9.5

