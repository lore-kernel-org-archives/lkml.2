Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752018Ab0K2JCJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 04:02:09 -0500
Received: from gate.crashing.org ([63.228.1.57]:40458 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751872Ab0K2JCG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 04:02:06 -0500
Subject: Re: [PATCH 00/21] mm: Preemptibility -v6
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andrea Arcangeli <aarcange@redhat.com>, Avi Kivity <avi@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Rik van Riel <riel@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-mm@kvack.org, David Miller <davem@davemloft.net>,
        Hugh Dickins <hugh.dickins@tiscali.co.uk>, Mel Gorman <mel@csn.ul.ie>,
        Nick Piggin <npiggin@kernel.dk>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Yanmin Zhang <yanmin_zhang@linux.intel.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
In-Reply-To: <20101126143843.801484792@chello.nl>
References: <20101126143843.801484792@chello.nl>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 29 Nov 2010 20:00:20 +1100
Message-ID: <1291021220.32570.295.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Linus seems to want this to get some serious review and be pushed through
> Andrew (well, anybody but me actually, but since Andrew is mm master...)
> 
> Ben, Thomas, Andrew, can I trick you guys into looking at this stuff?

It's on my hot todo list this week :-)

I'd like to take out the rcu fix for ppc page table freeing tho and send
it to Linus now if you're ok with that.

Cheers,
Ben.


