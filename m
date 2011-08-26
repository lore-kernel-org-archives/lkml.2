Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753645Ab1HZGao (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 02:30:44 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:56251 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753092Ab1HZGan (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 02:30:43 -0400
MIME-Version: 1.0
In-Reply-To: <CADqbE94+eZPeMggwkeZsXYxmkCRddRT7OXeiEyj_b3m=g5GxUQ@mail.gmail.com>
References: <CADqbE94+eZPeMggwkeZsXYxmkCRddRT7OXeiEyj_b3m=g5GxUQ@mail.gmail.com>
Date: Fri, 26 Aug 2011 14:30:42 +0800
Message-ID: <CADqbE97+FKz-7op-nmdOVmq3mrXadaxQrtk9Zud90E7iMMEUVQ@mail.gmail.com>
Subject: Re: [PATCH] slab: trivial: cleanup: remove unneeded return
From: Zhao Jin <cronozhj@gmail.com>
To: cl@linux-foundation.org, penberg@kernel.org, mpm@selenic.com,
        trivial@kernel.org
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The line starting with ``@@'' in the patch was wrapped by my text
editor when I copied it.
Please see the following corrected one. Sorry for the trouble.

---
 mm/slab.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/mm/slab.c b/mm/slab.c
index 6d90a09..82e0a0e 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -3678,13 +3678,12 @@ static inline void __cache_free(struct
kmem_cache *cachep, void *objp,

 	if (likely(ac->avail < ac->limit)) {
 		STATS_INC_FREEHIT(cachep);
-		ac->entry[ac->avail++] = objp;
-		return;
 	} else {
 		STATS_INC_FREEMISS(cachep);
 		cache_flusharray(cachep, ac);
-		ac->entry[ac->avail++] = objp;
 	}
+
+	ac->entry[ac->avail++] = objp;
 }

 /**
-- 
1.7.4.1
