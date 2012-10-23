Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933363Ab2JWULO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 16:11:14 -0400
Received: from smtp.outflux.net ([198.145.64.163]:40840 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933993Ab2JWULH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:11:07 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Vlad Yasevich <vyasevich@gmail.com>,
        Sridhar Samudrala <sri@us.ibm.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 181/193] net/sctp: remove CONFIG_EXPERIMENTAL
Date: Tue, 23 Oct 2012 13:04:14 -0700
Message-Id: <1351022666-6960-182-git-send-email-keescook@chromium.org>
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

CC: Vlad Yasevich <vyasevich@gmail.com>
CC: Sridhar Samudrala <sri@us.ibm.com>
CC: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 net/sctp/Kconfig |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/sctp/Kconfig b/net/sctp/Kconfig
index 126b014..0e13f54 100644
--- a/net/sctp/Kconfig
+++ b/net/sctp/Kconfig
@@ -3,8 +3,8 @@
 #
 
 menuconfig IP_SCTP
-	tristate "The SCTP Protocol (EXPERIMENTAL)"
-	depends on INET && EXPERIMENTAL
+	tristate "The SCTP Protocol"
+	depends on INET
 	depends on IPV6 || IPV6=n
 	select CRYPTO
 	select CRYPTO_HMAC
-- 
1.7.9.5

