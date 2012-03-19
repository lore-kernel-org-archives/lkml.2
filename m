Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757942Ab2CSOUT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 10:20:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44734 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755813Ab2CSOUR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 10:20:17 -0400
Date: Mon, 19 Mar 2012 15:19:00 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
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
Subject: Re: [RFC][PATCH 00/26] sched/numa
Message-ID: <20120319141900.GO24602@redhat.com>
References: <20120316144028.036474157@chello.nl>
 <4F670325.7080700@redhat.com>
 <1332155527.18960.292.camel@twins>
 <20120319130401.GI24602@redhat.com>
 <1332163776.18960.337.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1332163776.18960.337.camel@twins>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 19, 2012 at 02:29:36PM +0100, Peter Zijlstra wrote:
> On Mon, 2012-03-19 at 14:04 +0100, Andrea Arcangeli wrote:
> > For the niche there's the
> > numactl, cpusets, and all sort of bindings already. No need of more
> > niche, that is pure kernel API pollution in my view, the niche has all
> > its hard tools it needs already. 
> 
> Not quite, I've heard that some HPC people would very much like to relax
> some of that hard binding because its just as big a pain for them as it
> is for kvm.

Then I guess if they call hard bindings a big pain, they won't be
excited by the pain you offer them through your new soft binding
syscalls.

It's totally ok for qemu, which will just run 2 syscalls per
vnode.

But with your solution some apps will suffer from the same massive
pain that they're currently suffering. This is why is still niche to me.
