Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752467Ab1HZGin (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 02:38:43 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:32908 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910Ab1HZGim (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 02:38:42 -0400
Message-ID: <4E573F68.1020603@gmail.com>
Date: Fri, 26 Aug 2011 14:38:32 +0800
From: Zhao Jin <cronozhj@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: cl@linux-foundation.org, penberg@kernel.org, mpm@selenic.com,
        trivial@kernel.org
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] slab: trivial: cleanup: remove unneeded return
References: <CADqbE94+eZPeMggwkeZsXYxmkCRddRT7OXeiEyj_b3m=g5GxUQ@mail.gmail.com> <CADqbE97+FKz-7op-nmdOVmq3mrXadaxQrtk9Zud90E7iMMEUVQ@mail.gmail.com>
In-Reply-To: <CADqbE97+FKz-7op-nmdOVmq3mrXadaxQrtk9Zud90E7iMMEUVQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Terribly sorry. It was gmail who wrapped the line.
Please see this following version. Thanks!

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
-        ac->entry[ac->avail++] = objp;
-        return;
      } else {
          STATS_INC_FREEMISS(cachep);
          cache_flusharray(cachep, ac);
-        ac->entry[ac->avail++] = objp;
      }
+
+    ac->entry[ac->avail++] = objp;
  }

  /**
-- 
1.7.4.1

