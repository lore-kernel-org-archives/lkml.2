Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755531Ab1H2XXl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 19:23:41 -0400
Received: from mga02.intel.com ([134.134.136.20]:24129 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755402Ab1H2XX2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 19:23:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="43424138"
From: Andi Kleen <andi@firstfloor.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        viro@zeniv.linux.org.uk, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 02/11] DIO: Fix a wrong comment
Date: Mon, 29 Aug 2011 16:23:13 -0700
Message-Id: <1314660202-661-3-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1314660202-661-1-git-send-email-andi@firstfloor.org>
References: <1314660202-661-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

There's nothing on the stack, even before my changes.

Acked-by: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 fs/direct-io.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/direct-io.c b/fs/direct-io.c
index 02943e3..18e1a14 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -39,7 +39,7 @@
 
 /*
  * How many user pages to map in one call to get_user_pages().  This determines
- * the size of a structure on the stack.
+ * the size of a structure in the slab cache
  */
 #define DIO_PAGES	64
 
-- 
1.7.4.4

