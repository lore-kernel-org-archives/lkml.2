Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965211Ab2JWUrh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 16:47:37 -0400
Received: from smtp.outflux.net ([198.145.64.163]:37045 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933669Ab2JWUFY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:05:24 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>,
        Christine Caulfield <ccaulfie@redhat.com>,
        David Teigland <teigland@redhat.com>
Subject: [PATCH 145/193] fs/dlm: remove CONFIG_EXPERIMENTAL
Date: Tue, 23 Oct 2012 13:03:38 -0700
Message-Id: <1351022666-6960-146-git-send-email-keescook@chromium.org>
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

CC: Christine Caulfield <ccaulfie@redhat.com>
CC: David Teigland <teigland@redhat.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 fs/dlm/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/dlm/Kconfig b/fs/dlm/Kconfig
index 1897eb1..e4242c3 100644
--- a/fs/dlm/Kconfig
+++ b/fs/dlm/Kconfig
@@ -1,6 +1,6 @@
 menuconfig DLM
 	tristate "Distributed Lock Manager (DLM)"
-	depends on EXPERIMENTAL && INET
+	depends on INET
 	depends on SYSFS && CONFIGFS_FS && (IPV6 || IPV6=n)
 	select IP_SCTP
 	help
-- 
1.7.9.5

