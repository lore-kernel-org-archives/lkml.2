Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753442Ab1IDTyQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Sep 2011 15:54:16 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:40384 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753245Ab1IDTx5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Sep 2011 15:53:57 -0400
From: Arvydas Sidorenko <asido4@gmail.com>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org, asido4@gmail.com
Subject: [PATCH 3/3] typedef cleanup
Date: Sun,  4 Sep 2011 21:54:45 +0200
Message-Id: <1315166085-27984-3-git-send-email-asido4@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1315166085-27984-1-git-send-email-asido4@gmail.com>
References: <1315166085-27984-1-git-send-email-asido4@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most of those typedefs weren't used, so simply removing them worked without any
compilation issues.

Signed-off-by: Arvydas Sidorenko <asido4@gmail.com>
---
 drivers/staging/crystalhd/bc_dts_types.h |   41 +-----------------------------
 1 files changed, 1 insertions(+), 40 deletions(-)

diff --git a/drivers/staging/crystalhd/bc_dts_types.h b/drivers/staging/crystalhd/bc_dts_types.h
index d2131e7..42d7cfd 100644
--- a/drivers/staging/crystalhd/bc_dts_types.h
+++ b/drivers/staging/crystalhd/bc_dts_types.h
@@ -29,29 +29,8 @@
 #include <stdint.h>
 #endif
 
-#ifndef PVOID
-typedef void	*PVOID;
-#endif
-
-#ifndef BOOL
-typedef int	BOOL;
-#endif
-
 #if defined(__KERNEL__) || defined(__LINUX_USER__)
 
-#ifdef __LINUX_USER__	/* Don't include these for KERNEL */
-typedef uint32_t	ULONG;
-typedef int32_t		LONG;
-typedef void		*HANDLE;
-#ifndef VOID
-typedef void		VOID;
-#endif
-typedef void		*LPVOID;
-typedef uint32_t	DWORD;
-typedef uint32_t	UINT32;
-typedef uint32_t	*LPDWORD;
-typedef unsigned char	*PUCHAR;
-
 #ifndef TRUE
 	#define TRUE		1
 #endif
@@ -70,28 +49,10 @@ typedef unsigned char	*PUCHAR;
 #else
 
 #ifndef uint64_t
-typedef struct _uint64_t {
+struct _uint64_t {
 	uint32_t low_dw;
 	uint32_t hi_dw;
 } uint64_t;
 #endif
 
-#ifndef int32_t
-typedef signed long		int32_t;
-#endif
-
-#ifndef uint32_t
-typedef unsigned long	uint32_t;
 #endif
-
-#ifndef uint16_t
-typedef unsigned short	uint16_t;
-#endif
-
-#ifndef uint8_t
-typedef unsigned char	uint8_t;
-#endif
-#endif
-
-#endif
-
-- 
1.7.1

