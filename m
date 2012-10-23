Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965091Ab2JWUm1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 16:42:27 -0400
Received: from smtp.outflux.net ([198.145.64.163]:39875 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933813Ab2JWUF3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:05:29 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>,
        Alexander Smirnov <alex.bluesman.smirnov@gmail.com>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 174/193] net/mac802154: remove CONFIG_EXPERIMENTAL
Date: Tue, 23 Oct 2012 13:04:07 -0700
Message-Id: <1351022666-6960-175-git-send-email-keescook@chromium.org>
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

CC: Alexander Smirnov <alex.bluesman.smirnov@gmail.com>
CC: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
CC: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 net/mac802154/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac802154/Kconfig b/net/mac802154/Kconfig
index a967dda..b33dd76 100644
--- a/net/mac802154/Kconfig
+++ b/net/mac802154/Kconfig
@@ -1,6 +1,6 @@
 config MAC802154
 	tristate "Generic IEEE 802.15.4 Soft Networking Stack (mac802154)"
-	depends on IEEE802154 && EXPERIMENTAL
+	depends on IEEE802154
 	select CRC_CCITT
 	---help---
 	  This option enables the hardware independent IEEE 802.15.4
-- 
1.7.9.5

