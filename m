Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756244Ab2B2I6l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 03:58:41 -0500
Received: from casper.infradead.org ([85.118.1.10]:34940 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752757Ab2B2I6k convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 03:58:40 -0500
Message-ID: <1330505894.11248.108.camel@twins>
Subject: Re: [PATCH] cpumask: fix lg_lock/br_lock.
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>, Nick Piggin <npiggin@kernel.dk>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andi Kleen <ak@linux.intel.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        linux-fsdevel@vger.kernel.org
Date: Wed, 29 Feb 2012 09:58:14 +0100
In-Reply-To: <20120229082944.GA10425@elte.hu>
References: <87ehtf3lqh.fsf@rustcorp.com.au>
	 <20120227155338.7b5110cd.akpm@linux-foundation.org>
	 <20120228084359.GJ21106@elte.hu>
	 <20120228132719.f375071a.akpm@linux-foundation.org>
	 <20120229082944.GA10425@elte.hu>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-02-29 at 09:29 +0100, Ingo Molnar wrote:
> As part of any cleanup they should first be converted from 
> arch_spinlock_t to regular spinlock_t - I bet if that is done 
> then that not only simplifies the wrappers massively, it also 
> turns the above soft lockup report into a nice, actionable 
> lockdep splat. 

It might help if you'd actually read the code.. that will simply not
work.
