Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030415Ab2EQWP6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 18:15:58 -0400
Received: from mga02.intel.com ([134.134.136.20]:65435 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967771Ab2EQWOE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 18:14:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="145320407"
From: "H.J. Lu" <hjl.tools@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: torvalds@linux-foundation.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, "H.J. Lu" <hjl.tools@gmail.com>
Subject: [PATCH 07/10] Use __kernel_ulong_t in struct shmid64_ds/shminfo64
Date: Thu, 17 May 2012 15:13:33 -0700
Message-Id: <1337292816-10839-8-git-send-email-hjl.tools@gmail.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1337292816-10839-1-git-send-email-hjl.tools@gmail.com>
References: <1337292816-10839-1-git-send-email-hjl.tools@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H.J. Lu" <hjl.tools@gmail.com>

Replace unsigned long with __kernel_ulong_t in struct shmid64_ds and
struct shminfo64 for user space.

Signed-off-by: H.J. Lu <hjl.tools@gmail.com>
---
 include/asm-generic/shmbuf.h |   24 ++++++++++++------------
 1 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/include/asm-generic/shmbuf.h b/include/asm-generic/shmbuf.h
index 5768fa6..7e9fb2f 100644
--- a/include/asm-generic/shmbuf.h
+++ b/include/asm-generic/shmbuf.h
@@ -39,21 +39,21 @@ struct shmid64_ds {
 #endif
 	__kernel_pid_t		shm_cpid;	/* pid of creator */
 	__kernel_pid_t		shm_lpid;	/* pid of last operator */
-	unsigned long		shm_nattch;	/* no. of current attaches */
-	unsigned long		__unused4;
-	unsigned long		__unused5;
+	__kernel_ulong_t	shm_nattch;	/* no. of current attaches */
+	__kernel_ulong_t	__unused4;
+	__kernel_ulong_t	__unused5;
 };
 
 struct shminfo64 {
-	unsigned long	shmmax;
-	unsigned long	shmmin;
-	unsigned long	shmmni;
-	unsigned long	shmseg;
-	unsigned long	shmall;
-	unsigned long	__unused1;
-	unsigned long	__unused2;
-	unsigned long	__unused3;
-	unsigned long	__unused4;
+	__kernel_ulong_t	shmmax;
+	__kernel_ulong_t	shmmin;
+	__kernel_ulong_t	shmmni;
+	__kernel_ulong_t	shmseg;
+	__kernel_ulong_t	shmall;
+	__kernel_ulong_t	__unused1;
+	__kernel_ulong_t	__unused2;
+	__kernel_ulong_t	__unused3;
+	__kernel_ulong_t	__unused4;
 };
 
 #endif /* __ASM_GENERIC_SHMBUF_H */
-- 
1.7.6.5

