Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967841Ab2EQWPG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 18:15:06 -0400
Received: from mga02.intel.com ([134.134.136.20]:46382 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967776Ab2EQWOF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 18:14:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="145320412"
From: "H.J. Lu" <hjl.tools@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: torvalds@linux-foundation.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, "H.J. Lu" <hjl.tools@gmail.com>
Subject: [PATCH 09/10] Use __kernel_ulong_t in struct ipc64_perm
Date: Thu, 17 May 2012 15:13:35 -0700
Message-Id: <1337292816-10839-10-git-send-email-hjl.tools@gmail.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1337292816-10839-1-git-send-email-hjl.tools@gmail.com>
References: <1337292816-10839-1-git-send-email-hjl.tools@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H.J. Lu" <hjl.tools@gmail.com>

Replace unsigned long with __kernel_ulong_t in struct ipc64_perm for
user space.

Signed-off-by: H.J. Lu <hjl.tools@gmail.com>
---
 include/asm-generic/ipcbuf.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/asm-generic/ipcbuf.h b/include/asm-generic/ipcbuf.h
index 76982b2..3dbcc1e 100644
--- a/include/asm-generic/ipcbuf.h
+++ b/include/asm-generic/ipcbuf.h
@@ -27,8 +27,8 @@ struct ipc64_perm {
 	unsigned char		__pad1[4 - sizeof(__kernel_mode_t)];
 	unsigned short		seq;
 	unsigned short		__pad2;
-	unsigned long		__unused1;
-	unsigned long		__unused2;
+	__kernel_ulong_t	__unused1;
+	__kernel_ulong_t	__unused2;
 };
 
 #endif /* __ASM_GENERIC_IPCBUF_H */
-- 
1.7.6.5

