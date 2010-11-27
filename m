Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753626Ab0K0V5P (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Nov 2010 16:57:15 -0500
Received: from gate.crashing.org ([63.228.1.57]:59598 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752749Ab0K0V5N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Nov 2010 16:57:13 -0500
Subject: Re: [PATCH 02/21] powerpc: Use call_rcu_sched() for pagetables
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Nick Piggin <npiggin@kernel.dk>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrea Arcangeli <aarcange@redhat.com>, Avi Kivity <avi@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Rik van Riel <riel@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-mm@kvack.org, David Miller <davem@davemloft.net>,
        Hugh Dickins <hugh.dickins@tiscali.co.uk>, Mel Gorman <mel@csn.ul.ie>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Yanmin Zhang <yanmin_zhang@linux.intel.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, Nick Piggin <npiggin@suse.de>
In-Reply-To: <20101127103319.GA6830@amd>
References: <20101126143843.801484792@chello.nl>
	 <20101126145410.373743450@chello.nl>  <20101127103319.GA6830@amd>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 28 Nov 2010 08:55:00 +1100
Message-ID: <1290894900.32570.160.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-11-27 at 21:33 +1100, Nick Piggin wrote:
> Can this go through powerpc tree as a bugfix?
> 
> On Fri, Nov 26, 2010 at 03:38:45PM +0100, Peter Zijlstra wrote:
> > PowerPC relies on IRQ-disable to guard against RCU quiecent states,
> > use the appropriate RCU call version.
> > 

I'm happy to pick that up tomorrow.

Cheers,
Ben.


