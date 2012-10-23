Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933717Ab2JWVDN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 17:03:13 -0400
Received: from smtp.outflux.net ([198.145.64.163]:46539 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933696Ab2JWUFN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:05:13 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>,
        Grant Grundler <grundler@parisc-linux.org>
Subject: [PATCH 079/193] drivers/net/ethernet/dec/tulip: remove CONFIG_EXPERIMENTAL
Date: Tue, 23 Oct 2012 13:02:32 -0700
Message-Id: <1351022666-6960-80-git-send-email-keescook@chromium.org>
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

CC: Grant Grundler <grundler@parisc-linux.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/net/ethernet/dec/tulip/Kconfig |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/dec/tulip/Kconfig b/drivers/net/ethernet/dec/tulip/Kconfig
index 1203be0..0c37fb2 100644
--- a/drivers/net/ethernet/dec/tulip/Kconfig
+++ b/drivers/net/ethernet/dec/tulip/Kconfig
@@ -57,8 +57,8 @@ config TULIP
 	  be called tulip.
 
 config TULIP_MWI
-	bool "New bus configuration (EXPERIMENTAL)"
-	depends on TULIP && EXPERIMENTAL
+	bool "New bus configuration"
+	depends on TULIP
 	---help---
 	  This configures your Tulip card specifically for the card and
 	  system cache line size type you are using.
-- 
1.7.9.5

