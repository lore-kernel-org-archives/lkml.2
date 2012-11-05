Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933548Ab2KEXNU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 18:13:20 -0500
Received: from smtp.outflux.net ([198.145.64.163]:45288 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755160Ab2KEXFe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 18:05:34 -0500
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Ulrich Kunitz <kune@deine-taler.de>,
        "John W. Linville" <linville@tuxdriver.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 021/104] drivers/net/wireless/zd1211rw: remove depends on CONFIG_EXPERIMENTAL
Date: Mon,  5 Nov 2012 15:03:38 -0800
Message-Id: <1352156701-4038-22-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1352156701-4038-1-git-send-email-keescook@chromium.org>
References: <1352156701-4038-1-git-send-email-keescook@chromium.org>
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The CONFIG_EXPERIMENTAL config item has not carried much meaning for a
while now and is almost always enabled by default. As agreed during the
Linux kernel summit, remove it from any "depends on" lines in Kconfigs.

CC: Ulrich Kunitz <kune@deine-taler.de>
CC: "John W. Linville" <linville@tuxdriver.com>
Cc: "David S. Miller" <davem@davemloft.net>
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

