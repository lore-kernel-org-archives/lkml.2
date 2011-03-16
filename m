Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754203Ab1CPVGi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 17:06:38 -0400
Received: from casper.infradead.org ([85.118.1.10]:48870 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753204Ab1CPVGc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 17:06:32 -0400
Subject: Re: [PATCH 02/17] mm: mmu_gather rework
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Mel Gorman <mel@csn.ul.ie>, Andrea Arcangeli <aarcange@redhat.com>,
        Avi Kivity <avi@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Rik van Riel <riel@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        akpm@linux-foundation.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-mm@kvack.org, Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        David Miller <davem@davemloft.net>,
        Hugh Dickins <hugh.dickins@tiscali.co.uk>,
        Nick Piggin <npiggin@kernel.dk>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Yanmin Zhang <yanmin_zhang@linux.intel.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Russell King <rmk@arm.linux.org.uk>, Paul Mundt <lethal@linux-sh.org>,
        Jeff Dike <jdike@addtoit.com>, Tony Luck <tony.luck@intel.com>,
        Hugh Dickins <hughd@google.com>
In-Reply-To: <AANLkTimB4NFSPz5dSQCuEy3Rj5968n5k0=4c7tvhErE5@mail.gmail.com>
References: <20110217162327.434629380@chello.nl>
	 <20110217163234.823185666@chello.nl> <20110310155032.GB32302@csn.ul.ie>
	 <1300301742.2203.1899.camel@twins>
	 <AANLkTimB4NFSPz5dSQCuEy3Rj5968n5k0=4c7tvhErE5@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 16 Mar 2011 22:08:21 +0100
Message-ID: <1300309701.2250.89.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-03-16 at 21:15 +0100, Geert Uytterhoeven wrote:
> On Wed, Mar 16, 2011 at 19:55, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> > On Thu, 2011-03-10 at 15:50 +0000, Mel Gorman wrote:
> >
> >> > +static inline void
> >> > +tlb_gather_mmu(struct mmu_gather *tlb, struct mm_struct *mm, unsigned int full_mm_flush)
> >> >  {
> >>
> >> checkpatch will bitch about line length.
> >
> > I did a s/full_mm_flush/fullmm/ which puts the line length at 81. At
> > which point I'll ignore it ;-)
> 
> But what does "fullmm" mean here? Shouldn't that be documented.
> BTW, the function no longer returns a struct, but void, so the documentation
> should be updated for sure.

You're talking about the comment right? I'll update that. I was also
considering writing Documentation/mmugather.txt, but that's a slightly
bigger undertaking.

