Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755337Ab1DDSbL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 14:31:11 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:46988 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754763Ab1DDSbK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 14:31:10 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6306"; a="83904854"
From: Stephen Boyd <sboyd@codeaurora.org>
To: Russell King <linux@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCHv2] ARM: Use asm-generic/sizes.h
Date: Mon,  4 Apr 2011 11:31:01 -0700
Message-Id: <1301941861-465-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.5.rc0.116.g44bc5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit d232b12 (asm-generic headers: add sizes.h, 2011-01-15)
introcuded a generic sizes.h. Use that instead of the ARM specific
version.

Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---

Ok I gave in and just added SZ_48M to this header. I also
left the copyright stuff alone. When/if generic asm stuff
happens we can deal with the fallout.

 arch/arm/include/asm/sizes.h |   42 ++----------------------------------------
 1 files changed, 2 insertions(+), 40 deletions(-)

diff --git a/arch/arm/include/asm/sizes.h b/arch/arm/include/asm/sizes.h
index 316bb2b..154b89b 100644
--- a/arch/arm/include/asm/sizes.h
+++ b/arch/arm/include/asm/sizes.h
@@ -16,44 +16,6 @@
 /*  Size definitions
  *  Copyright (C) ARM Limited 1998. All rights reserved.
  */
+#include <asm-generic/sizes.h>
 
-#ifndef __sizes_h
-#define __sizes_h                       1
-
-/* handy sizes */
-#define SZ_16				0x00000010
-#define SZ_32				0x00000020
-#define SZ_64				0x00000040
-#define SZ_128				0x00000080
-#define SZ_256				0x00000100
-#define SZ_512				0x00000200
-
-#define SZ_1K                           0x00000400
-#define SZ_2K                           0x00000800
-#define SZ_4K                           0x00001000
-#define SZ_8K                           0x00002000
-#define SZ_16K                          0x00004000
-#define SZ_32K                          0x00008000
-#define SZ_64K                          0x00010000
-#define SZ_128K                         0x00020000
-#define SZ_256K                         0x00040000
-#define SZ_512K                         0x00080000
-
-#define SZ_1M                           0x00100000
-#define SZ_2M                           0x00200000
-#define SZ_4M                           0x00400000
-#define SZ_8M                           0x00800000
-#define SZ_16M                          0x01000000
-#define SZ_32M                          0x02000000
-#define SZ_48M                          0x03000000
-#define SZ_64M                          0x04000000
-#define SZ_128M                         0x08000000
-#define SZ_256M                         0x10000000
-#define SZ_512M                         0x20000000
-
-#define SZ_1G                           0x40000000
-#define SZ_2G                           0x80000000
-
-#endif
-
-/*         END */
+#define SZ_48M	(SZ_32M + SZ_16M)
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

