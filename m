Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965130Ab2JWUma (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 16:42:30 -0400
Received: from smtp.outflux.net ([198.145.64.163]:38738 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933589Ab2JWUF3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:05:29 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 107/193] drivers/net/wireless/rtl818x: remove CONFIG_EXPERIMENTAL
Date: Tue, 23 Oct 2012 13:03:00 -0700
Message-Id: <1351022666-6960-108-git-send-email-keescook@chromium.org>
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

CC: "John W. Linville" <linville@tuxdriver.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/net/wireless/rtl818x/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rtl818x/Kconfig b/drivers/net/wireless/rtl818x/Kconfig
index 17d80fe..3033217 100644
--- a/drivers/net/wireless/rtl818x/Kconfig
+++ b/drivers/net/wireless/rtl818x/Kconfig
@@ -3,7 +3,7 @@
 #
 config RTL8180
 	tristate "Realtek 8180/8185 PCI support"
-	depends on MAC80211 && PCI && EXPERIMENTAL
+	depends on MAC80211 && PCI
 	select EEPROM_93CX6
 	---help---
 	  This is a driver for RTL8180 and RTL8185 based cards.
-- 
1.7.9.5

