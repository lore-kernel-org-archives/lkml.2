Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753513Ab0K2Lmo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 06:42:44 -0500
Received: from casper.infradead.org ([85.118.1.10]:37860 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752942Ab0K2Lmn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 06:42:43 -0500
Subject: Re: [PATCH 00/21] mm: Preemptibility -v6
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
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
In-Reply-To: <1291021220.32570.295.camel@pasglop>
References: <20101126143843.801484792@chello.nl>
	 <1291021220.32570.295.camel@pasglop>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 29 Nov 2010 12:41:56 +0100
Message-ID: <1291030916.32004.7.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-11-29 at 20:00 +1100, Benjamin Herrenschmidt wrote:
> > Linus seems to want this to get some serious review and be pushed through
> > Andrew (well, anybody but me actually, but since Andrew is mm master...)
> > 
> > Ben, Thomas, Andrew, can I trick you guys into looking at this stuff?
> 
> It's on my hot todo list this week :-)
> 
> I'd like to take out the rcu fix for ppc page table freeing tho and send
> it to Linus now if you're ok with that.

Sure, and thanks!
