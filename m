Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967816Ab2EQWOJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 18:14:09 -0400
Received: from mga02.intel.com ([134.134.136.20]:53202 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967769Ab2EQWOD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 18:14:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="145320404"
From: "H.J. Lu" <hjl.tools@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: torvalds@linux-foundation.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, "H.J. Lu" <hjl.tools@gmail.com>
Subject: [PATCH 05/10] Use __kernel_long_t in struct mq_attr
Date: Thu, 17 May 2012 15:13:31 -0700
Message-Id: <1337292816-10839-6-git-send-email-hjl.tools@gmail.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1337292816-10839-1-git-send-email-hjl.tools@gmail.com>
References: <1337292816-10839-1-git-send-email-hjl.tools@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H.J. Lu" <hjl.tools@gmail.com>

Replace long with __kernel_long_t in struct mq_attr for user space.

Signed-off-by: H.J. Lu <hjl.tools@gmail.com>
---
 include/linux/mqueue.h |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/linux/mqueue.h b/include/linux/mqueue.h
index 8b5a796..d89a735 100644
--- a/include/linux/mqueue.h
+++ b/include/linux/mqueue.h
@@ -23,11 +23,11 @@
 #define MQ_BYTES_MAX	819200
 
 struct mq_attr {
-	long	mq_flags;	/* message queue flags			*/
-	long	mq_maxmsg;	/* maximum number of messages		*/
-	long	mq_msgsize;	/* maximum message size			*/
-	long	mq_curmsgs;	/* number of messages currently queued	*/
-	long	__reserved[4];	/* ignored for input, zeroed for output */
+	__kernel_long_t mq_flags;	/* message queue flags			*/
+	__kernel_long_t mq_maxmsg;	/* maximum number of messages		*/
+	__kernel_long_t mq_msgsize;	/* maximum message size			*/
+	__kernel_long_t mq_curmsgs;	/* number of messages currently queued	*/
+	__kernel_long_t __reserved[4];	/* ignored for input, zeroed for output */
 };
 
 /*
-- 
1.7.6.5

