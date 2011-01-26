Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754052Ab1AZUDo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 15:03:44 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:49549 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752647Ab1AZUDm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 15:03:42 -0500
Date: Wed, 26 Jan 2011 21:03:41 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andrea Arcangeli <aarcange@redhat.com>, Avi Kivity <avi@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Rik van Riel <riel@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [RFC][PATCH 26/25] mm, arch: Convert ia64, arm, sh to generic
	tlb
Message-ID: <20110126200341.GA3507@merkur.ravnborg.org>
References: <20110125173111.720927511@chello.nl> <1296047601.28776.1162.camel@laptop> <20110126191901.GA3434@merkur.ravnborg.org> <1296070218.15234.9.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1296070218.15234.9.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 26, 2011 at 08:30:18PM +0100, Peter Zijlstra wrote:
> On Wed, 2011-01-26 at 20:19 +0100, Sam Ravnborg wrote:
> > 
> > /* Users of the generic TLB shootdown code must declare this storage space. */
> > DECLARE_PER_CPU(struct mmu_gather, mmu_gathers);
> > 
> > If I understand this correct then this should read:
> > 
> > /*
> >  * Users of the generic TLB shootdown
> >  * must define mmu_gathers like this:
> >  * DEFINE_PER_CPU(struct mmu_gather, mmu_gathers);
> >  */
> > 
> > The main difference is "declare" => "define".
> > 
> > If you already updated this in you serie then please ignore this mail. 
> 
> This series rewrites mmu_gather to remove this per-cpu data :-), see
> patch #10 which removes the DEFINE_PER_CPU()s after all users are dead.

Thanks again.
I better read the patch descriptions before asking next time.

	Sam
