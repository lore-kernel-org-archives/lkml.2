Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932404Ab2J2LP7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 07:15:59 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:46200 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758622Ab2J2LP5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 07:15:57 -0400
Date: Mon, 29 Oct 2012 12:15:52 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Zhouping Liu <zliu@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Rik van Riel <riel@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
        Mel Gorman <mgorman@suse.de>, Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] sched, numa, mm: Add memcg support to
 do_huge_pmd_numa_page()
Message-ID: <20121029111552.GC22569@gmail.com>
References: <20121025121617.617683848@chello.nl>
 <508A52E1.8020203@redhat.com>
 <1351242480.12171.48.camel@twins>
 <20121028175615.GC29827@cmpxchg.org>
 <508DEDA2.9030503@redhat.com>
 <20121029065044.GB14107@gmail.com>
 <20121029082403.GA1419@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121029082403.GA1419@cmpxchg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Johannes Weiner <hannes@cmpxchg.org> wrote:

> Hello Ingo!
> 
> On Mon, Oct 29, 2012 at 07:50:44AM +0100, Ingo Molnar wrote:
> > 
> > * Zhouping Liu <zliu@redhat.com> wrote:
> > 
> > > Hi Johannes,
> > > 
> > > Tested the below patch, and I'm sure it has fixed the above 
> > > issue, thank you.
> > 
> > Thanks. Below is the folded up patch.
> > 
> > 	Ingo
> > 
> > ---------------------------->
> > Subject: sched, numa, mm: Add memcg support to do_huge_pmd_numa_page()
> > From: Johannes Weiner <hannes@cmpxchg.org>
> > Date: Thu Oct 25 12:49:51 CEST 2012
> > 
> > Add memory control group support to hugepage migration.
> > 
> > Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> > Tested-by: Zhouping Liu <zliu@redhat.com>
> > Link: http://lkml.kernel.org/n/tip-rDk9mgpoyhZlwh2xhlykvgnp@git.kernel.org
> > Signed-off-by: Ingo Molnar <mingo@kernel.org>
> > ---
> >  mm/huge_memory.c |   15 +++++++++++++++
> >  1 file changed, 15 insertions(+)
> 
> Did the mm/memcontrol.c part go missing?

Yes :-/

Fixing it up now.

Thanks,

	Ingo
