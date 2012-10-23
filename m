Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933747Ab2JWUFg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 16:05:36 -0400
Received: from smtp.outflux.net ([198.145.64.163]:42001 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933799Ab2JWUF0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:05:26 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Tyler Hicks <tyhicks@canonical.com>,
        Dustin Kirkland <dustin.kirkland@gazzang.com>
Subject: [PATCH 146/193] fs/ecryptfs: remove CONFIG_EXPERIMENTAL
Date: Tue, 23 Oct 2012 13:03:39 -0700
Message-Id: <1351022666-6960-147-git-send-email-keescook@chromium.org>
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

CC: Tyler Hicks <tyhicks@canonical.com>
CC: Dustin Kirkland <dustin.kirkland@gazzang.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 fs/ecryptfs/Kconfig |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ecryptfs/Kconfig b/fs/ecryptfs/Kconfig
index cc16562..e15ef38 100644
--- a/fs/ecryptfs/Kconfig
+++ b/fs/ecryptfs/Kconfig
@@ -1,6 +1,6 @@
 config ECRYPT_FS
-	tristate "eCrypt filesystem layer support (EXPERIMENTAL)"
-	depends on EXPERIMENTAL && KEYS && CRYPTO && (ENCRYPTED_KEYS || ENCRYPTED_KEYS=n)
+	tristate "eCrypt filesystem layer support"
+	depends on KEYS && CRYPTO && (ENCRYPTED_KEYS || ENCRYPTED_KEYS=n)
 	select CRYPTO_ECB
 	select CRYPTO_CBC
 	select CRYPTO_MD5
-- 
1.7.9.5

