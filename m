Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751595Ab2KLIpP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 03:45:15 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:52796 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751427Ab2KLIpN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 03:45:13 -0500
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mel Gorman <mgorman@suse.de>, Minchan Kim <minchan@kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] mm: Remove unused variable in alloc_contig_range()
Date: Mon, 12 Nov 2012 09:45:06 +0100
Message-Id: <1352709906-10749-1-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: git-send-email 1.8.0
X-Provags-ID: V02:K0:orgR9LFihJDY7oPG0BR3ROb63g/kGPf3H3xzleHl3cG
 iFYICKtEWikgurIWb+cuR/dmZhHZltBCK2I7dIWJORN5jcPWsB
 LZw0kuUK3ZhUwK/zzDZ07bOpnZksm6bmYkbqv9t3sGvuFXbrVN
 KmNuujVMquCHTk5oWr1Wi33MC4qvnjZG8R4YEolNrQ/YItjv8e
 zlXIRY/IoWKES4gxRRsxi8tm7CBFOdgx5a/vzE8Vq7cKpovx8d
 1wunFDNFYmCG3CytcLF23akfO6lOg2iLyWH8Af9BDbbVmXAZ4I
 Ns4B7Ff+mc2O+WuWBcJO3s0dvYvoF3T4RiobrLrntxykfda7QO
 ryRCcZU14RxY2y1kcn5zy1IJl1dNKN1gGeJMWi50c5NSw6sZlT
 6aHnXiRj+xOgRfeB2TthkA8dr8EY+yglNLe31VGxwknCQl0DI2
 8wdUv
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 872ca38f7afd9566bf2f88b95616f7ab71b50064 removed the last
reference to this variable but not the variable itself.

Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
---
 mm/page_alloc.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 6b990cb..71933dd 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5822,7 +5822,6 @@ static int __alloc_contig_migrate_range(struct compact_control *cc,
 int alloc_contig_range(unsigned long start, unsigned long end,
 		       unsigned migratetype)
 {
-	struct zone *zone = page_zone(pfn_to_page(start));
 	unsigned long outer_start, outer_end;
 	int ret = 0, order;
 
-- 
1.8.0

