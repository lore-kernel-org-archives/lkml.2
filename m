Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932524Ab1FVTUX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 15:20:23 -0400
Received: from mga11.intel.com ([192.55.52.93]:14809 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932248Ab1FVTUV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 15:20:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,407,1304319600"; 
   d="scan'208";a="19403657"
From: Andi Kleen <andi@firstfloor.org>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, dehrenberg@google.com,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 2/6] DIO: Fix a wrong comment
Date: Wed, 22 Jun 2011 12:18:38 -0700
Message-Id: <1308770322-22565-3-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1308770322-22565-1-git-send-email-andi@firstfloor.org>
References: <1308770322-22565-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

There's nothing on the stack, even before my changes.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 fs/direct-io.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/direct-io.c b/fs/direct-io.c
index e1360c6..823d2fe 100644
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

