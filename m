Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965617Ab2JWVPz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 17:15:55 -0400
Received: from smtp.outflux.net ([198.145.64.163]:55092 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933635Ab2JWUFA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:05:00 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>
Subject: [PATCH 013/193] arch/ia64/xen: remove CONFIG_EXPERIMENTAL
Date: Tue, 23 Oct 2012 13:01:26 -0700
Message-Id: <1351022666-6960-14-git-send-email-keescook@chromium.org>
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

CC: Tony Luck <tony.luck@intel.com>
CC: Fenghua Yu <fenghua.yu@intel.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/ia64/xen/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/ia64/xen/Kconfig b/arch/ia64/xen/Kconfig
index 515e082..5d8a06b 100644
--- a/arch/ia64/xen/Kconfig
+++ b/arch/ia64/xen/Kconfig
@@ -5,7 +5,7 @@
 config XEN
 	bool "Xen hypervisor support"
 	default y
-	depends on PARAVIRT && MCKINLEY && IA64_PAGE_SIZE_16KB && EXPERIMENTAL
+	depends on PARAVIRT && MCKINLEY && IA64_PAGE_SIZE_16KB
 	select XEN_XENCOMM
 	select NO_IDLE_HZ
 	# followings are required to save/restore.
-- 
1.7.9.5

