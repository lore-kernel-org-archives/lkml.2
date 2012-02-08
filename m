Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756345Ab2BHFKn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 00:10:43 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44028 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751144Ab2BHFJt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 00:09:49 -0500
From: "H. Peter Anvin" <hpa@zytor.com>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Paul Mundt <lethal@linux-sh.org>
Subject: [PATCH 17/21] sh: Remove unnecessary posix_types.h type overrides
Date: Tue,  7 Feb 2012 21:09:01 -0800
Message-Id: <1328677745-20121-18-git-send-email-hpa@zytor.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1328677745-20121-1-git-send-email-hpa@zytor.com>
References: <1328677745-20121-1-git-send-email-hpa@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. Peter Anvin" <hpa@zytor.com>

Remove type overrides in <asm/posix_types.h> for the sh architecture
that are no longer necessary.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Cc: Paul Mundt <lethal@linux-sh.org>
---
 arch/sh/include/asm/posix_types_32.h |    5 -----
 arch/sh/include/asm/posix_types_64.h |    4 ----
 2 files changed, 0 insertions(+), 9 deletions(-)

diff --git a/arch/sh/include/asm/posix_types_32.h b/arch/sh/include/asm/posix_types_32.h
index 6a9ceaa..abda584 100644
--- a/arch/sh/include/asm/posix_types_32.h
+++ b/arch/sh/include/asm/posix_types_32.h
@@ -12,11 +12,6 @@ typedef unsigned short	__kernel_uid_t;
 typedef unsigned short	__kernel_gid_t;
 #define __kernel_gid_t __kernel_gid_t
 
-typedef unsigned int	__kernel_uid32_t;
-#define __kernel_uid32_t __kernel_uid32_t
-typedef unsigned int	__kernel_gid32_t;
-#define __kernel_gid32_t __kernel_gid32_t
-
 typedef unsigned short	__kernel_old_uid_t;
 #define __kernel_old_uid_t __kernel_old_uid_t
 typedef unsigned short	__kernel_old_gid_t;
diff --git a/arch/sh/include/asm/posix_types_64.h b/arch/sh/include/asm/posix_types_64.h
index 8cd1148..fcda07b 100644
--- a/arch/sh/include/asm/posix_types_64.h
+++ b/arch/sh/include/asm/posix_types_64.h
@@ -17,10 +17,6 @@ typedef int		__kernel_ssize_t;
 #define __kernel_ssize_t __kernel_ssize_t
 typedef int		__kernel_ptrdiff_t;
 #define __kernel_ptrdiff_t __kernel_ptrdiff_t
-typedef unsigned int	__kernel_uid32_t;
-#define __kernel_uid32_t __kernel_uid32_t
-typedef unsigned int	__kernel_gid32_t;
-#define __kernel_gid32_t __kernel_gid32_t
 
 typedef unsigned short	__kernel_old_uid_t;
 #define __kernel_old_uid_t __kernel_old_uid_t
-- 
1.7.6.5

