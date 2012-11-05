Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933273Ab2KEXTv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 18:19:51 -0500
Received: from smtp.outflux.net ([198.145.64.163]:47794 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755126Ab2KEXF1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 18:05:27 -0500
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>,
        Christine Caulfield <ccaulfie@redhat.com>,
        David Teigland <teigland@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 094/104] fs/dlm: remove depends on CONFIG_EXPERIMENTAL
Date: Mon,  5 Nov 2012 15:04:51 -0800
Message-Id: <1352156701-4038-95-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1352156701-4038-1-git-send-email-keescook@chromium.org>
References: <1352156701-4038-1-git-send-email-keescook@chromium.org>
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The CONFIG_EXPERIMENTAL config item has not carried much meaning for a
while now and is almost always enabled by default. As agreed during the
Linux kernel summit, remove it from any "depends on" lines in Kconfigs.

CC: Christine Caulfield <ccaulfie@redhat.com>
CC: David Teigland <teigland@redhat.com>
CC: Al Viro <viro@zeniv.linux.org.uk>
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

