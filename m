Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933940Ab2JWUbF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 16:31:05 -0400
Received: from smtp.outflux.net ([198.145.64.163]:35411 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964812Ab2JWUFo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:05:44 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Pablo Neira Ayuso <pablo@netfilter.org>,
        Patrick McHardy <kaber@trash.net>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 165/193] net/decnet/netfilter: remove CONFIG_EXPERIMENTAL
Date: Tue, 23 Oct 2012 13:03:58 -0700
Message-Id: <1351022666-6960-166-git-send-email-keescook@chromium.org>
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

CC: Pablo Neira Ayuso <pablo@netfilter.org>
CC: Patrick McHardy <kaber@trash.net>
CC: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 net/decnet/netfilter/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/decnet/netfilter/Kconfig b/net/decnet/netfilter/Kconfig
index 2f81de5..8d7c109 100644
--- a/net/decnet/netfilter/Kconfig
+++ b/net/decnet/netfilter/Kconfig
@@ -3,7 +3,7 @@
 #
 
 menu "DECnet: Netfilter Configuration"
-	depends on DECNET && NETFILTER && EXPERIMENTAL
+	depends on DECNET && NETFILTER
 	depends on NETFILTER_ADVANCED
 
 config DECNET_NF_GRABULATOR
-- 
1.7.9.5

