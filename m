Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754670Ab2GYHKw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 03:10:52 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:53420 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751418Ab2GYHKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 03:10:50 -0400
Date: Wed, 25 Jul 2012 09:10:44 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Lee Schermerhorn <lee.schermerhorn@hp.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: linux-next: manual merge of the akpm tree with the tip tree
Message-ID: <20120725071044.GA27535@gmail.com>
References: <20120725140827.4332a5448e4d8d200164ea2e@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120725140827.4332a5448e4d8d200164ea2e@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi Andrew,
> 
> Today's linux-next merge of the akpm tree got a conflict in 
> mm/migrate.c between the tip tree and commit "mm: memcg: fix 
> compaction/migration failing due to memcg limits" from the 
> akpm tree.
> 
> The commit 4783af477d3d ("mm: Migrate misplaced page") was 
> removed (among several others) from the tip tree since 
> yesterday (and thus linux-next) so the above akpm tree patch 
> no longer applies.
> 
> I have dropped this patch form the akpm tree (and the following patches
> as well:
> mm-memcg-fix-compaction-migration-failing-due-to-memcg-limits-checkpatch-fixes
> mm: memcg: push down PageSwapCache check into uncharge entry functions
> mm: memcg: only check for PageSwapCache when uncharging anon
> mm: memcg: remove unneeded shmem charge type
> mm: memcg: remove needless !mm fixup to init_mm when charging
> )
> 
> Hopefully this doesn't cause other problems.  I guess that 
> they will need rebasing depending on what gets merged via the 
> tip tree.

Andrew, sorry about this last minute fallout: I felt that 
sched/numa was still not fully cooked and did not want to hold 
up the rest of the scheduler tree on that - nor did I want to 
send an uncooked tree to Linus.

PeterZ posted another series of sched/numa patches two days ago 
- once that is ready (probably after the merge window) it will 
all reappear again, in a slightly different form. I could stick 
the mm/ bits into a separate tree to make it easier for you.

Cross-discipline patches are hard - the other option would be to 
let Linux NUMA scheduling continue to suck.

Thanks,

	Ingo
