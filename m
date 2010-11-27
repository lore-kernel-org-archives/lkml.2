Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754032Ab0K0Kd2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Nov 2010 05:33:28 -0500
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:57832 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752769Ab0K0KdY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Nov 2010 05:33:24 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAGdt8Ex5Lcx2/2dsb2JhbACjC3K+AYVHBI91
Date: Sat, 27 Nov 2010 21:33:19 +1100
From: Nick Piggin <npiggin@kernel.dk>
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
        Yanmin Zhang <yanmin_zhang@linux.intel.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, Nick Piggin <npiggin@suse.de>
Subject: Re: [PATCH 02/21] powerpc: Use call_rcu_sched() for pagetables
Message-ID: <20101127103319.GA6830@amd>
References: <20101126143843.801484792@chello.nl>
 <20101126145410.373743450@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101126145410.373743450@chello.nl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Can this go through powerpc tree as a bugfix?

On Fri, Nov 26, 2010 at 03:38:45PM +0100, Peter Zijlstra wrote:
> PowerPC relies on IRQ-disable to guard against RCU quiecent states,
> use the appropriate RCU call version.
> 
