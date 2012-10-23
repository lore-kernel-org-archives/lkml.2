Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965235Ab2JWUrj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 16:47:39 -0400
Received: from smtp.outflux.net ([198.145.64.163]:34253 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933787Ab2JWUFY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:05:24 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Arnd Bergmann <arnd@arndb.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>
Subject: [PATCH 023/193] arch/powerpc/platforms/cell: remove CONFIG_EXPERIMENTAL
Date: Tue, 23 Oct 2012 13:01:36 -0700
Message-Id: <1351022666-6960-24-git-send-email-keescook@chromium.org>
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

CC: Arnd Bergmann <arnd@arndb.de>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Paul Mackerras <paulus@samba.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/powerpc/platforms/cell/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/platforms/cell/Kconfig b/arch/powerpc/platforms/cell/Kconfig
index 2e7ff0c..53aaefe 100644
--- a/arch/powerpc/platforms/cell/Kconfig
+++ b/arch/powerpc/platforms/cell/Kconfig
@@ -124,7 +124,7 @@ config CBE_CPUFREQ
 
 config CBE_CPUFREQ_PMI_ENABLE
 	bool "CBE frequency scaling using PMI interface"
-	depends on CBE_CPUFREQ && EXPERIMENTAL
+	depends on CBE_CPUFREQ
 	default n
 	help
 	  Select this, if you want to use the PMI interface
-- 
1.7.9.5

