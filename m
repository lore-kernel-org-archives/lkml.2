Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965053Ab2JWUyA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 16:54:00 -0400
Received: from smtp.outflux.net ([198.145.64.163]:57751 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933757Ab2JWUFV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:05:21 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>
Subject: [PATCH 133/193] drivers/vlynq: remove CONFIG_EXPERIMENTAL
Date: Tue, 23 Oct 2012 13:03:26 -0700
Message-Id: <1351022666-6960-134-git-send-email-keescook@chromium.org>
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

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/vlynq/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vlynq/Kconfig b/drivers/vlynq/Kconfig
index d874b4f..e011620 100644
--- a/drivers/vlynq/Kconfig
+++ b/drivers/vlynq/Kconfig
@@ -1,5 +1,5 @@
 menu "TI VLYNQ"
-	depends on AR7 && EXPERIMENTAL
+	depends on AR7
 
 config VLYNQ
 	bool "TI VLYNQ bus support"
-- 
1.7.9.5

