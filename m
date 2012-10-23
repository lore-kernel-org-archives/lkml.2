Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933967Ab2JWUeA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 16:34:00 -0400
Received: from smtp.outflux.net ([198.145.64.163]:51741 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964778Ab2JWUFh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:05:37 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Luciano Coelho <coelho@ti.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 108/193] drivers/net/wireless/ti/wl1251: remove CONFIG_EXPERIMENTAL
Date: Tue, 23 Oct 2012 13:03:01 -0700
Message-Id: <1351022666-6960-109-git-send-email-keescook@chromium.org>
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

CC: Luciano Coelho <coelho@ti.com>
CC: "John W. Linville" <linville@tuxdriver.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/net/wireless/ti/wl1251/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ti/wl1251/Kconfig b/drivers/net/wireless/ti/wl1251/Kconfig
index 1fb6584..8fec4ed 100644
--- a/drivers/net/wireless/ti/wl1251/Kconfig
+++ b/drivers/net/wireless/ti/wl1251/Kconfig
@@ -1,6 +1,6 @@
 menuconfig WL1251
 	tristate "TI wl1251 driver support"
-	depends on MAC80211 && EXPERIMENTAL && GENERIC_HARDIRQS
+	depends on MAC80211 && GENERIC_HARDIRQS
 	select FW_LOADER
 	select CRC7
 	---help---
-- 
1.7.9.5

