Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965641Ab2JWVMa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 17:12:30 -0400
Received: from smtp.outflux.net ([198.145.64.163]:49681 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933656Ab2JWUFD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:05:03 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Guan Xuetao <gxt@mprc.pku.edu.cn>
Subject: [PATCH 030/193] arch/unicore32: remove CONFIG_EXPERIMENTAL
Date: Tue, 23 Oct 2012 13:01:43 -0700
Message-Id: <1351022666-6960-31-git-send-email-keescook@chromium.org>
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

CC: Guan Xuetao <gxt@mprc.pku.edu.cn>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/unicore32/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/unicore32/Kconfig b/arch/unicore32/Kconfig
index e5c5473..4def59a 100644
--- a/arch/unicore32/Kconfig
+++ b/arch/unicore32/Kconfig
@@ -216,7 +216,7 @@ config PUV3_GPIO
 	bool
 	depends on !ARCH_FPGA
 	select GENERIC_GPIO
-	select GPIO_SYSFS if EXPERIMENTAL
+	select GPIO_SYSFS
 	default y
 
 if PUV3_NB0916
-- 
1.7.9.5

