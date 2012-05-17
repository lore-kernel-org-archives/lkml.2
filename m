Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967791Ab2EQWOG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 18:14:06 -0400
Received: from mga02.intel.com ([134.134.136.20]:53202 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967766Ab2EQWOC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 18:14:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="145320394"
From: "H.J. Lu" <hjl.tools@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: torvalds@linux-foundation.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, "H.J. Lu" <hjl.tools@gmail.com>
Subject: [PATCH 02/10] Use __kernel_ulong_t in struct shm_info
Date: Thu, 17 May 2012 15:13:28 -0700
Message-Id: <1337292816-10839-3-git-send-email-hjl.tools@gmail.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1337292816-10839-1-git-send-email-hjl.tools@gmail.com>
References: <1337292816-10839-1-git-send-email-hjl.tools@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H.J. Lu" <hjl.tools@gmail.com>

Replace unsigned long with __kernel_ulong_t in struct shm_info for
user space.

Signed-off-by: H.J. Lu <hjl.tools@gmail.com>
---
 include/linux/shm.h |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/linux/shm.h b/include/linux/shm.h
index 92808b8..6cd9510 100644
--- a/include/linux/shm.h
+++ b/include/linux/shm.h
@@ -75,11 +75,11 @@ struct	shminfo {
 
 struct shm_info {
 	int used_ids;
-	unsigned long shm_tot;	/* total allocated shm */
-	unsigned long shm_rss;	/* total resident shm */
-	unsigned long shm_swp;	/* total swapped shm */
-	unsigned long swap_attempts;
-	unsigned long swap_successes;
+	__kernel_ulong_t shm_tot;	/* total allocated shm */
+	__kernel_ulong_t shm_rss;	/* total resident shm */
+	__kernel_ulong_t shm_swp;	/* total swapped shm */
+	__kernel_ulong_t swap_attempts;
+	__kernel_ulong_t swap_successes;
 };
 
 #ifdef __KERNEL__
-- 
1.7.6.5

