Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965081Ab2JWUoe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 16:44:34 -0400
Received: from smtp.outflux.net ([198.145.64.163]:40453 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933446Ab2JWUF1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:05:27 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>,
        Alexander Smirnov <alex.bluesman.smirnov@gmail.com>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 167/193] net/ieee802154: remove CONFIG_EXPERIMENTAL
Date: Tue, 23 Oct 2012 13:04:00 -0700
Message-Id: <1351022666-6960-168-git-send-email-keescook@chromium.org>
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
 net/ieee802154/Kconfig |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/ieee802154/Kconfig b/net/ieee802154/Kconfig
index 7dee650..b2e06df 100644
--- a/net/ieee802154/Kconfig
+++ b/net/ieee802154/Kconfig
@@ -1,6 +1,5 @@
 config IEEE802154
-	tristate "IEEE Std 802.15.4 Low-Rate Wireless Personal Area Networks support (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
+	tristate "IEEE Std 802.15.4 Low-Rate Wireless Personal Area Networks support"
 	---help---
 	  IEEE Std 802.15.4 defines a low data rate, low power and low
 	  complexity short range wireless personal area networks. It was
-- 
1.7.9.5

