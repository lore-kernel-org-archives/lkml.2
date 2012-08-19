Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755993Ab2HSDBT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 23:01:19 -0400
Received: from mga02.intel.com ([134.134.136.20]:64945 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753831Ab2HSC5n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 22:57:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,792,1336374000"; 
   d="scan'208";a="182422053"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, mmarek@suse.cz, linux-kbuild@vger.kernel.org,
        JBeulich@suse.com, akpm@linux-foundation.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 16/74] sections: Add __visible to lib/* sections
Date: Sat, 18 Aug 2012 19:56:12 -0700
Message-Id: <1345345030-22211-17-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1345345030-22211-1-git-send-email-andi@firstfloor.org>
References: <1345345030-22211-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 lib/bug.c           |    2 +-
 lib/dynamic_debug.c |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/lib/bug.c b/lib/bug.c
index a28c141..f81e1a6 100644
--- a/lib/bug.c
+++ b/lib/bug.c
@@ -43,7 +43,7 @@
 #include <linux/bug.h>
 #include <linux/sched.h>
 
-extern const struct bug_entry __start___bug_table[], __stop___bug_table[];
+extern __visible const struct bug_entry __start___bug_table[], __stop___bug_table[];
 
 static inline unsigned long bug_addr(const struct bug_entry *bug)
 {
diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index 7ca29a0..1760a71 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -34,8 +34,8 @@
 #include <linux/device.h>
 #include <linux/netdevice.h>
 
-extern struct _ddebug __start___verbose[];
-extern struct _ddebug __stop___verbose[];
+extern __visible struct _ddebug __start___verbose[];
+extern __visible struct _ddebug __stop___verbose[];
 
 struct ddebug_table {
 	struct list_head link;
-- 
1.7.7.6

