Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964893Ab2JWUcZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 16:32:25 -0400
Received: from smtp.outflux.net ([198.145.64.163]:56114 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933855Ab2JWUFi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:05:38 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Daniel Drake <dsd@gentoo.org>,
        Ulrich Kunitz <kune@deine-taler.de>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 109/193] drivers/net/wireless/zd1211rw: remove CONFIG_EXPERIMENTAL
Date: Tue, 23 Oct 2012 13:03:02 -0700
Message-Id: <1351022666-6960-110-git-send-email-keescook@chromium.org>
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

CC: Daniel Drake <dsd@gentoo.org>
CC: Ulrich Kunitz <kune@deine-taler.de>
CC: "John W. Linville" <linville@tuxdriver.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/net/wireless/zd1211rw/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/zd1211rw/Kconfig b/drivers/net/wireless/zd1211rw/Kconfig
index 5f80969..96c8e1d 100644
--- a/drivers/net/wireless/zd1211rw/Kconfig
+++ b/drivers/net/wireless/zd1211rw/Kconfig
@@ -1,6 +1,6 @@
 config ZD1211RW
 	tristate "ZyDAS ZD1211/ZD1211B USB-wireless support"
-	depends on USB && MAC80211 && EXPERIMENTAL
+	depends on USB && MAC80211
 	select FW_LOADER
 	---help---
 	  This is an experimental driver for the ZyDAS ZD1211/ZD1211B wireless
-- 
1.7.9.5

