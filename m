Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758933Ab2CSN1L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 09:27:11 -0400
Received: from casper.infradead.org ([85.118.1.10]:42521 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755121Ab2CSN1J convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 09:27:09 -0400
Message-ID: <1332163591.18960.334.camel@twins>
Subject: Re: [RFC][PATCH 00/26] sched/numa
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Avi Kivity <avi@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Paul Turner <pjt@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Mike Galbraith <efault@gmx.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Dan Smith <danms@us.ibm.com>,
        Bharata B Rao <bharata.rao@gmail.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Date: Mon, 19 Mar 2012 14:26:31 +0100
In-Reply-To: <20120319130401.GI24602@redhat.com>
References: <20120316144028.036474157@chello.nl>
	 <4F670325.7080700@redhat.com> <1332155527.18960.292.camel@twins>
	 <20120319130401.GI24602@redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-03-19 at 14:04 +0100, Andrea Arcangeli wrote:
> If you boot with memcg compiled in, that's taking an equivalent amount
> of memory per-page.
> 
> If you can bear the memory loss when memcg is compiled in even when
> not enabled, you sure can bear it on NUMA systems that have lots of
> memory, so it's perfectly ok to sacrifice a bit of it so that it
> performs like not-NUMA but you still have more memory than not-NUMA.
> 
I think the overhead of memcg is quite insane as well. And no I cannot
bear that and have it disabled in all my kernels.

NUMA systems having lots of memory is a false argument, that doesn't
mean we can just waste tons of it, people pay good money for that
memory, they want to use it.

I fact, I know that HPC people want things like swap-over-nfs so they
can push infrequently running system crap out into swap so they can get
these few extra megabytes of memory. And you're proposing they give up
~100M just like that?

