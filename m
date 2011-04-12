Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756770Ab1DLHTV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 03:19:21 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:56310 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754712Ab1DLHTU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 03:19:20 -0400
Message-ID: <4DA3FDB2.9090100@cn.fujitsu.com>
Date: Tue, 12 Apr 2011 15:22:26 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: cl@linux.com, penberg@kernel.org, LKML <linux-kernel@vger.kernel.org>,
        linux-mm@kvack.org
Subject: [PATCH] slub: Fix a typo in config name
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-04-12 15:19:53,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-04-12 15:19:57,
	Serialize complete at 2011-04-12 15:19:57
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's no config named SLAB_DEBUG, and it should be a typo
of SLUB_DEBUG.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---

not slub expert, don't know how this bug affects slub debugging.

---
 mm/slub.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 94d2a33..df77f78 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -3203,7 +3203,7 @@ static void __init kmem_cache_bootstrap_fixup(struct kmem_cache *s)
 			list_for_each_entry(p, &n->partial, lru)
 				p->slab = s;
 
-#ifdef CONFIG_SLAB_DEBUG
+#ifdef CONFIG_SLUB_DEBUG
 			list_for_each_entry(p, &n->full, lru)
 				p->slab = s;
 #endif
-- 
1.7.3.1
