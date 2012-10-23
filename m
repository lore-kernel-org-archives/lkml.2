Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964895Ab2JWUGq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 16:06:46 -0400
Received: from smtp.outflux.net ([198.145.64.163]:46229 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964873Ab2JWUGn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:06:43 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 173/193] net/mac80211: remove CONFIG_EXPERIMENTAL
Date: Tue, 23 Oct 2012 13:04:06 -0700
Message-Id: <1351022666-6960-174-git-send-email-keescook@chromium.org>
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
CC: Johannes Berg <johannes@sipsolutions.net>
CC: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 net/mac80211/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/Kconfig b/net/mac80211/Kconfig
index 63af254..e15050e 100644
--- a/net/mac80211/Kconfig
+++ b/net/mac80211/Kconfig
@@ -81,7 +81,7 @@ comment "Some wireless drivers require a rate control algorithm"
 
 config MAC80211_MESH
 	bool "Enable mac80211 mesh networking (pre-802.11s) support"
-	depends on MAC80211 && EXPERIMENTAL
+	depends on MAC80211
 	---help---
 	 This options enables support of Draft 802.11s mesh networking.
 	 The implementation is based on Draft 2.08 of the Mesh Networking
-- 
1.7.9.5

