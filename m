Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933253Ab2KEXGA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 18:06:00 -0500
Received: from smtp.outflux.net ([198.145.64.163]:45520 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754679Ab2KEXF5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 18:05:57 -0500
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, WANG Cong <xiyou.wangcong@gmail.com>,
        Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
Subject: [PATCH 101/104] kernel/gcov: remove depends on CONFIG_EXPERIMENTAL
Date: Mon,  5 Nov 2012 15:04:58 -0800
Message-Id: <1352156701-4038-102-git-send-email-keescook@chromium.org>
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

Cc: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 kernel/gcov/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/gcov/Kconfig b/kernel/gcov/Kconfig
index a920281..d4da55d 100644
--- a/kernel/gcov/Kconfig
+++ b/kernel/gcov/Kconfig
@@ -35,7 +35,7 @@ config GCOV_KERNEL
 config GCOV_PROFILE_ALL
 	bool "Profile entire Kernel"
 	depends on GCOV_KERNEL
-	depends on SUPERH || S390 || X86 || (PPC && EXPERIMENTAL) || MICROBLAZE
+	depends on SUPERH || S390 || X86 || PPC || MICROBLAZE
 	default n
 	---help---
 	This options activates profiling for the entire kernel.
-- 
1.7.9.5

