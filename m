Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756468Ab2HTWH6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 18:07:58 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53735 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755738Ab2HTWFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 18:05:46 -0400
From: Michel Lespinasse <walken@google.com>
To: riel@redhat.com, peterz@infradead.org, daniel.santos@pobox.com,
        aarcange@redhat.com, dwmw2@infradead.org, akpm@linux-foundation.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org
Subject: [PATCH v3 1/9] rbtree test: fix sparse warning about 64-bit constant
Date: Mon, 20 Aug 2012 15:05:23 -0700
Message-Id: <1345500331-10546-2-git-send-email-walken@google.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1345500331-10546-1-git-send-email-walken@google.com>
References: <1345500331-10546-1-git-send-email-walken@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just a small fix to make sparse happy.

Signed-off-by: Michel Lespinasse <walken@google.com>
Reported-by: Fengguang Wu <wfg@linux.intel.com>
Acked-by: Rik van Riel <riel@redhat.com>

---
 lib/rbtree_test.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/lib/rbtree_test.c b/lib/rbtree_test.c
index 19dfca9ff7d7..fd09465d82ca 100644
--- a/lib/rbtree_test.c
+++ b/lib/rbtree_test.c
@@ -88,7 +88,7 @@ static int rbtree_test_init(void)
 
 	printk(KERN_ALERT "rbtree testing");
 
-	prandom32_seed(&rnd, 3141592653589793238);
+	prandom32_seed(&rnd, 3141592653589793238ULL);
 	init();
 
 	time1 = get_cycles();
-- 
1.7.7.3
