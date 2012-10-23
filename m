Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964858Ab2JWUkI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 16:40:08 -0400
Received: from smtp.outflux.net ([198.145.64.163]:54966 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933823Ab2JWUFc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:05:32 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>,
        Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
        Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 176/193] net/nfc: remove CONFIG_EXPERIMENTAL
Date: Tue, 23 Oct 2012 13:04:09 -0700
Message-Id: <1351022666-6960-177-git-send-email-keescook@chromium.org>
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

CC: Lauro Ramos Venancio <lauro.venancio@openbossa.org>
CC: Aloisio Almeida Jr <aloisio.almeida@openbossa.org>
CC: Samuel Ortiz <sameo@linux.intel.com>
CC: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 net/nfc/Kconfig |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/nfc/Kconfig b/net/nfc/Kconfig
index 8d8d9bc..60c3bbb 100644
--- a/net/nfc/Kconfig
+++ b/net/nfc/Kconfig
@@ -3,8 +3,8 @@
 #
 
 menuconfig NFC
-	depends on NET && EXPERIMENTAL
-	tristate "NFC subsystem support (EXPERIMENTAL)"
+	depends on NET
+	tristate "NFC subsystem support"
 	default n
 	help
 	  Say Y here if you want to build support for NFC (Near field
-- 
1.7.9.5

