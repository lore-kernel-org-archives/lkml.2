Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753020Ab0C0C2s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 22:28:48 -0400
Received: from mail.perches.com ([173.55.12.10]:1136 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752774Ab0C0C2E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 22:28:04 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Christoph Lameter <cl@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Matt Mackall <mpm@selenic.com>,
       linux-mm@kvack.org
Subject: [PATCH 9/9] mm: Fix continuation lines
Date: Fri, 26 Mar 2010 19:27:58 -0700
Message-Id: <c53e66323c5898fe17221c0813779862189abce3.1269655209.git.joe@perches.com>
X-Mailer: git-send-email 1.7.0.14.g7e948
In-Reply-To: <cover.1269655208.git.joe@perches.com>
References: <cover.1269655208.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 mm/slab.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/mm/slab.c b/mm/slab.c
index a9f325b..ceb4e3a 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -4227,10 +4227,11 @@ static int s_show(struct seq_file *m, void *p)
 		unsigned long node_frees = cachep->node_frees;
 		unsigned long overflows = cachep->node_overflow;
 
-		seq_printf(m, " : globalstat %7lu %6lu %5lu %4lu \
-				%4lu %4lu %4lu %4lu %4lu", allocs, high, grown,
-				reaped, errors, max_freeable, node_allocs,
-				node_frees, overflows);
+		seq_printf(m, " : globalstat %7lu %6lu %5lu %4lu "
+			   "%4lu %4lu %4lu %4lu %4lu",
+			   allocs, high, grown,
+			   reaped, errors, max_freeable, node_allocs,
+			   node_frees, overflows);
 	}
 	/* cpu stats */
 	{
-- 
1.7.0.14.g7e948

