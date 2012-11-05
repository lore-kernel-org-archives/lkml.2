Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933361Ab2KEXMl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 18:12:41 -0500
Received: from smtp.outflux.net ([198.145.64.163]:42071 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933139Ab2KEXFf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 18:05:35 -0500
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>,
        Christian Lamparter <chunkeey@googlemail.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 014/104] drivers/net/wireless/ath/carl9170: remove depends on CONFIG_EXPERIMENTAL
Date: Mon,  5 Nov 2012 15:03:31 -0800
Message-Id: <1352156701-4038-15-git-send-email-keescook@chromium.org>
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

CC: Christian Lamparter <chunkeey@googlemail.com>
CC: "John W. Linville" <linville@tuxdriver.com>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/net/wireless/ath/carl9170/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/carl9170/Kconfig b/drivers/net/wireless/ath/carl9170/Kconfig
index 267d5dc..50c55c7 100644
--- a/drivers/net/wireless/ath/carl9170/Kconfig
+++ b/drivers/net/wireless/ath/carl9170/Kconfig
@@ -1,6 +1,6 @@
 config CARL9170
 	tristate "Linux Community AR9170 802.11n USB support"
-	depends on USB && MAC80211 && EXPERIMENTAL
+	depends on USB && MAC80211
 	select FW_LOADER
 	select CRC32
 	help
-- 
1.7.9.5

