Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965045Ab2JWUkL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 16:40:11 -0400
Received: from smtp.outflux.net ([198.145.64.163]:60686 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933822Ab2JWUFc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:05:32 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>,
        Venkat Venkatsubra <venkat.x.venkatsubra@oracle.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 179/193] net/rds: remove CONFIG_EXPERIMENTAL
Date: Tue, 23 Oct 2012 13:04:12 -0700
Message-Id: <1351022666-6960-180-git-send-email-keescook@chromium.org>
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

CC: Venkat Venkatsubra <venkat.x.venkatsubra@oracle.com>
CC: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 net/rds/Kconfig |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/rds/Kconfig b/net/rds/Kconfig
index ec753b3..f2c670b 100644
--- a/net/rds/Kconfig
+++ b/net/rds/Kconfig
@@ -1,7 +1,7 @@
 
 config RDS
-	tristate "The RDS Protocol (EXPERIMENTAL)"
-	depends on INET && EXPERIMENTAL
+	tristate "The RDS Protocol"
+	depends on INET
 	---help---
 	  The RDS (Reliable Datagram Sockets) protocol provides reliable,
 	  sequenced delivery of datagrams over Infiniband, iWARP,
-- 
1.7.9.5

