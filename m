Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751807Ab1LULJr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 06:09:47 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:55958 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751542Ab1LULJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 06:09:46 -0500
Message-ID: <4EF1BE69.5090300@gmail.com>
Date: Wed, 21 Dec 2011 19:09:29 +0800
From: Wang Sheng-Hui <shhuiw@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        Minchan Kim <minchan.kim@gmail.com>, Hugh Dickins <hughd@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] cleanup: mm/migrate.c: cleanup comment for function migration_entry_wait
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

migration_entry_wait can also be called from hugetlb_fault now.
Cleanup the comment.

Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
---
 mm/migrate.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index 177aca4..640002a 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -181,8 +181,6 @@ static void remove_migration_ptes(struct page *old, struct page *new)
  * Something used the pte of a page under migration. We need to
  * get to the page and wait until migration is finished.
  * When we return from this function the fault will be retried.
- *
- * This function is called from do_swap_page().
  */
 void migration_entry_wait(struct mm_struct *mm, pmd_t *pmd,
 				unsigned long address)
-- 
1.7.1

