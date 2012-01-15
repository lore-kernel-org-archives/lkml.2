Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752721Ab2AOWta (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jan 2012 17:49:30 -0500
Received: from mga01.intel.com ([192.55.52.88]:31078 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750811Ab2AOWt3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jan 2012 17:49:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="107383746"
From: Andi Kleen <andi@firstfloor.org>
To: chris.mason@oracle.com
Cc: linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH] SNAPPY: Add dual GPL/BSD license to snappy module
Date: Sun, 15 Jan 2012 14:49:14 -0800
Message-Id: <1326667754-13255-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

To avoid complaints from the module loader.

I made it dual because the original compression code was BSD.

Reported-by: Chris Mason
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 lib/snappy.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/lib/snappy.c b/lib/snappy.c
index 0b39e07..3848c6c 100644
--- a/lib/snappy.c
+++ b/lib/snappy.c
@@ -1298,3 +1298,5 @@ void snappy_free_env(struct snappy_env *env)
 	memset(env, 0, sizeof(struct snappy_env));
 }
 EXPORT_SYMBOL(snappy_free_env);
+
+MODULE_LICENSE("Dual BSD/GPL");
-- 
1.7.7.4

