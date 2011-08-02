Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751362Ab1HBEiV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 00:38:21 -0400
Received: from mga11.intel.com ([192.55.52.93]:31463 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750767Ab1HBEiQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 00:38:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,305,1309762800"; 
   d="scan'208";a="34794203"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, hch@infradead.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 02/11] DIO: Fix a wrong comment
Date: Mon,  1 Aug 2011 21:38:04 -0700
Message-Id: <1312259893-4548-3-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1312259893-4548-1-git-send-email-andi@firstfloor.org>
References: <1312259893-4548-1-git-send-email-andi@firstfloor.org>
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

