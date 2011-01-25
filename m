Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753017Ab1AYTlQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 14:41:16 -0500
Received: from pfepb.post.tele.dk ([195.41.46.236]:43347 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751827Ab1AYTlP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 14:41:15 -0500
Date: Tue, 25 Jan 2011 20:41:12 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andrea Arcangeli <aarcange@redhat.com>, Avi Kivity <avi@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Rik van Riel <riel@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-mm@kvack.org, Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        David Miller <davem@davemloft.net>,
        Hugh Dickins <hugh.dickins@tiscali.co.uk>, Mel Gorman <mel@csn.ul.ie>,
        Nick Piggin <npiggin@kernel.dk>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Yanmin Zhang <yanmin_zhang@linux.intel.com>
Subject: Re: [PATCH 00/25] mm: Preemptibility -v7
Message-ID: <20110125194112.GA31419@merkur.ravnborg.org>
References: <20110125173111.720927511@chello.nl> <20110125183240.GA31346@merkur.ravnborg.org> <1295983733.28776.1072.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1295983733.28776.1072.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 25, 2011 at 08:28:53PM +0100, Peter Zijlstra wrote:
> On Tue, 2011-01-25 at 19:32 +0100, Sam Ravnborg wrote:
> 
> > Foregive me my ignorance..
> > Why is this relevant for sparc64 but not for sparc32?
> > 
> > A quick grep showed up only this in sparc32 specific files:
> > 
> > mm/init_32.c:DEFINE_PER_CPU(struct mmu_gather, mmu_gathers);
> > 
> > Maybe this is just something sparc32 does not support?
> 
> sparc32 uses include/asm-generic/tlb.h, whereas sparc64 implements its
> own variant.

Ahh, thanks!

	Sam
