Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753236Ab1L1DIG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Dec 2011 22:08:06 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:58786 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753101Ab1L1DID (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Dec 2011 22:08:03 -0500
Message-ID: <4EFA87E4.8040609@gmail.com>
Date: Wed, 28 Dec 2011 11:07:16 +0800
From: Wang Sheng-Hui <shhuiw@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        Minchan Kim <minchan.kim@gmail.com>, Hugh Dickins <hughd@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] mm/migrate.c: remove the unused macro lru_to_page
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

lru_to_page is not used in mm/migrate.c. Drop it.

Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
---
 mm/migrate.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index 640002a..99da494 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -39,8 +39,6 @@
 
 #include "internal.h"
 
-#define lru_to_page(_head) (list_entry((_head)->prev, struct page, lru))
-
 /*
  * migrate_prep() needs to be called before we start compiling a list of pages
  * to be migrated using isolate_lru_page(). If scheduling work on other CPUs is
-- 
1.7.1
