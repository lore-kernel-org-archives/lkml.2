Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755479Ab1CUXvR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 19:51:17 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:64295 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755296Ab1CUXvO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 19:51:14 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6292"; a="81265534"
From: Stephen Boyd <sboyd@codeaurora.org>
To: Russell King <linux@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] ARM: Use asm-generic/sizes.h
Date: Mon, 21 Mar 2011 16:51:02 -0700
Message-Id: <1300751462-1494-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.4.1.343.ga91df
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit d232b12 (asm-generic headers: add sizes.h, 2011-01-15)
introduced a generic sizes.h. Use that instead of the ARM specific
version.

Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/include/asm/sizes.h |   60 +-----------------------------------------
 1 files changed, 1 insertions(+), 59 deletions(-)

diff --git a/arch/arm/include/asm/sizes.h b/arch/arm/include/asm/sizes.h
index 316bb2b..dd248c2 100644
--- a/arch/arm/include/asm/sizes.h
+++ b/arch/arm/include/asm/sizes.h
@@ -1,59 +1 @@
-/*
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
- */
-/*  Size definitions
- *  Copyright (C) ARM Limited 1998. All rights reserved.
- */
-
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
+#include <asm-generic/sizes.h>
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

