Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751773Ab2GZHwC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 03:52:02 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:46967 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751251Ab2GZHwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 03:52:00 -0400
Date: Thu, 26 Jul 2012 09:51:54 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Lee Schermerhorn <lee.schermerhorn@hp.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: linux-next: manual merge of the akpm tree with the tip tree
Message-ID: <20120726075154.GA8729@gmail.com>
References: <20120725140827.4332a5448e4d8d200164ea2e@canb.auug.org.au>
 <20120725071044.GA27535@gmail.com>
 <20120725073503.GB1112@cmpxchg.org>
 <20120725115713.e56239b5.akpm@linux-foundation.org>
 <20120725190351.GA4143@gmail.com>
 <20120725122613.b971360b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120725122613.b971360b.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Wed, 25 Jul 2012 21:03:51 +0200
> Ingo Molnar <mingo@kernel.org> wrote:
> 
> > > This means that if the above code reappears in linux-next or 
> > > mainline, the current copy of 
> > > mm-memcg-fix-compaction-migration-failing-due-to-memcg-limits.patch 
> > > will no longer update it, and I probably won't notice that 
> > > omission.
> > 
> > Did you plan to send Johannes's memcg bits to Linus in this 
> > merge window?
> 
> Yes.  I was kinda thinking of starting the bombing run on 
> Monday but I guess I could do the MM queue on Thursday.

Ok, great, that simplifies things: we'll base any additional 
sched/numa work on an upstream sha1 that has those bits 
upstream. (-rc1, if upstream quality allows.)

Thanks,

	Ingo
