Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752859Ab2KJBbh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 20:31:37 -0500
Received: from mga02.intel.com ([134.134.136.20]:14512 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752122Ab2KJB2G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 20:28:06 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,749,1344236400"; 
   d="scan'208";a="217548798"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: acme@redhat.com, peterz@infradead.org, jolsa@redhat.com,
        eranian@google.com, mingo@kernel.org, namhyung@kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 17/32] perf, tools: Handle XBEGIN like a jump
Date: Fri,  9 Nov 2012 17:27:33 -0800
Message-Id: <1352510868-7911-18-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1352510868-7911-1-git-send-email-andi@firstfloor.org>
References: <1352510868-7911-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

So that the browser still shows the abort label

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 tools/perf/util/annotate.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index 7a34dd1..b14d4df 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -401,6 +401,8 @@ static struct ins instructions[] = {
 	{ .name = "testb", .ops  = &mov_ops, },
 	{ .name = "testl", .ops  = &mov_ops, },
 	{ .name = "xadd",  .ops  = &mov_ops, },
+	{ .name = "xbeginl", .ops  = &jump_ops, },
+	{ .name = "xbeginq", .ops  = &jump_ops, },
 };
 
 static int ins__cmp(const void *name, const void *insp)
-- 
1.7.7.6

