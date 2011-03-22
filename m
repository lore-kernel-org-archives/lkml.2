Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753654Ab1CVLXY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 07:23:24 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:64873 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820Ab1CVLXW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 07:23:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=op5QIerzKf3468oYey7lBLmndToXRkDRCCHZJdjW+U1rUWsvOrKhc+cYFdsN0Fcgot
         ans+Xa/OITMV8vLjgxWafS15wQuqR6A2pdzcQLHj/z003smvBTNEP/Ll/ZDRT7jntv2q
         yiciZXkGYxIr1IvJwaUIwXjNxkQIzIAe5GOCM=
Date: Tue, 22 Mar 2011 13:26:47 +0200
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Christoph Lameter <cl@linux.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] mm: remove unused zone_idx variable from
 set_migratetype_isolate
Message-ID: <20110322112647.GA5086@swordfish.minsk.epam.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mm: remove unused variable zone_idx and zone_idx call from set_migratetype_isolate

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>

---

 mm/page_alloc.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 7945247..b732240 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5414,10 +5414,8 @@ int set_migratetype_isolate(struct page *page)
 	struct memory_isolate_notify arg;
 	int notifier_ret;
 	int ret = -EBUSY;
-	int zone_idx;
 
 	zone = page_zone(page);
-	zone_idx = zone_idx(zone);
 
 	spin_lock_irqsave(&zone->lock, flags);
 
