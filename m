Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752529Ab0H1PYe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Aug 2010 11:24:34 -0400
Received: from casper.infradead.org ([85.118.1.10]:35103 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752302Ab0H1PYd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Aug 2010 11:24:33 -0400
Subject: Re: [PATCH 00/20] mm: Preemptibility -v4
From: Peter Zijlstra <peterz@infradead.org>
To: piotr@hosowicz.com
Cc: Andrea Arcangeli <aarcange@redhat.com>, Avi Kivity <avi@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Rik van Riel <riel@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        David Miller <davem@davemloft.net>,
        Hugh Dickins <hugh.dickins@tiscali.co.uk>, Mel Gorman <mel@csn.ul.ie>,
        Nick Piggin <npiggin@suse.de>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Yanmin Zhang <yanmin_zhang@linux.intel.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
In-Reply-To: <4C79287B.9060609@example.com>
References: <20100828141637.421594670@chello.nl>
	 <4C7923B4.6030208@example.com> <1283008225.1975.3598.camel@laptop>
	 <4C79287B.9060609@example.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sat, 28 Aug 2010 17:23:51 +0200
Message-ID: <1283009031.1975.3615.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-08-28 at 17:17 +0200, Piotr Hosowicz wrote:
> >    git remote add mmu_preempt git://git.kernel.org/pub/scm/linux/kernel/git/peterz/linux-2.6-mmu_preempt.git
> >    git remote update
> >    git checkout mmu_preempt/mmu_preempt
> >
> > or
> >
> >    git checkout -b mmu_preempt origin/master
> >    git pull git://git.kernel.org/pub/scm/linux/kernel/git/peterz/linux-2.6-mmu_preempt.git mmu_preempt
> 
> Which is better? Thanks, I'll try.

Fully depends on how you manage your git tree, the first will keep
giving you the same tree while the second will try and merge my changes
into whatever you got from Linus' tree, which keeps moving fwd and might
thus start failing (at which point I'll have to either rebase or
backmerge Linus' changes).


