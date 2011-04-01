Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753661Ab1DAMIZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 08:08:25 -0400
Received: from casper.infradead.org ([85.118.1.10]:43685 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752229Ab1DAMIX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 08:08:23 -0400
Subject: Re: [PATCH 02/17] mm: mmu_gather rework
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Avi Kivity <avi@redhat.com>
Cc: Mel Gorman <mel@csn.ul.ie>, Andrea Arcangeli <aarcange@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Rik van Riel <riel@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
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
In-Reply-To: <4D87109A.1010005@redhat.com>
References: <20110217162327.434629380@chello.nl>
	 <20110217163234.823185666@chello.nl>  <20110310155032.GB32302@csn.ul.ie>
	 <1300301742.2203.1899.camel@twins>  <4D87109A.1010005@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 01 Apr 2011 14:07:11 +0200
Message-ID: <1301659631.4859.565.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-03-21 at 10:47 +0200, Avi Kivity wrote:
> On 03/16/2011 08:55 PM, Peter Zijlstra wrote:
> > On Thu, 2011-03-10 at 15:50 +0000, Mel Gorman wrote:
> >
> > >  >  +static inline void
> > >  >  +tlb_gather_mmu(struct mmu_gather *tlb, struct mm_struct *mm, unsigned int full_mm_flush)
> > >  >   {
> > >
> > >  checkpatch will bitch about line length.
> >
> > I did a s/full_mm_flush/fullmm/ which puts the line length at 81. At
> > which point I'll ignore it ;-)
> 
> How about s/unsigned int/bool/?  IIRC you aren't a "bool was invented 
> after 1971, therefore it is evil" type.

No, although I do try to avoid it in structures because I'm ever unsure
of the storage type used. But yes, good suggestion, thanks!
