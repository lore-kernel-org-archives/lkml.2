Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759598Ab0JFSGz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 14:06:55 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:59890 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759561Ab0JFSGi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 14:06:38 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 3/8] arm: remove unused asm/segment.h contents
Date: Wed,  6 Oct 2010 20:06:15 +0200
Message-Id: <1286388380-20646-4-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1286388380-20646-1-git-send-email-arnd@arndb.de>
References: <1286388380-20646-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:ks6Jns3cEuz67inGFf2unxvRwd2tS1EGyhbepqpajBK
 SaZjAWYlMRIArXgTpJTkJb8M4OIxegDYeNkDUAMQyQjOqF5mg1
 bUuAjmpyEvaaXfSXUw5nWBgPWg++Oghi5dPKlO0zOhhHkno/XV
 hqyvxNErEeYpWf/1ga/yVc4xkUoZrmOcgrynQGdtC6pQrukT54
 gyhVL1OGXSsFmyqgNp1uw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The constants defined in asm/segment.h are not used
anywhere in Linux, so we can make the file look like
the practically empty asm-generic/segment.h.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm/include/asm/segment.h |   12 +++++-------
 1 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/arch/arm/include/asm/segment.h b/arch/arm/include/asm/segment.h
index 9e24c21..b8b7291 100644
--- a/arch/arm/include/asm/segment.h
+++ b/arch/arm/include/asm/segment.h
@@ -1,11 +1,9 @@
 #ifndef __ASM_ARM_SEGMENT_H
 #define __ASM_ARM_SEGMENT_H
-
-#define __KERNEL_CS   0x0
-#define __KERNEL_DS   0x0
-
-#define __USER_CS     0x1
-#define __USER_DS     0x1
+/*
+ * Only here because we have some old header files that expect it...
+ *
+ * New architectures probably don't want to have their own version.
+ */
 
 #endif /* __ASM_ARM_SEGMENT_H */
-
-- 
1.7.1

