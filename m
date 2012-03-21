Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753009Ab2CUXmm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 19:42:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49107 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751806Ab2CUXmk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 19:42:40 -0400
Date: Thu, 22 Mar 2012 00:41:56 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: Dan Smith <danms@us.ibm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Paul Turner <pjt@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Mike Galbraith <efault@gmx.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Bharata B Rao <bharata.rao@gmail.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC] AutoNUMA alpha6
Message-ID: <20120321234156.GP24602@redhat.com>
References: <20120316144028.036474157@chello.nl>
 <20120316182511.GJ24602@redhat.com>
 <87k42edenh.fsf@danplanet.com>
 <20120321021239.GQ24602@redhat.com>
 <87fwd2d2kp.fsf@danplanet.com>
 <20120321124937.GX24602@redhat.com>
 <87limtboet.fsf@danplanet.com>
 <20120321225242.GL24602@redhat.com>
 <87aa39bl92.fsf@danplanet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87aa39bl92.fsf@danplanet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dan,

On Wed, Mar 21, 2012 at 04:13:45PM -0700, Dan Smith wrote:
> AA> available: 2 nodes (0-1)
> AA> node 0 cpus: 0 1 2 3 4 5 12 13 14 15 16 17
> AA> node 1 cpus: 6 7 8 9 10 11 18 19 20 21 22 23
> 
> available: 2 nodes (0-1)
> node 0 cpus: 0 1 2 3 4 5 12 13 14 15 16 17
> node 0 size: 12276 MB
> node 0 free: 11769 MB
> node 1 cpus: 6 7 8 9 10 11 18 19 20 21 22 23
> node 1 size: 12288 MB
> node 1 free: 11727 MB
> node distances:
> node   0   1 
>   0:  10  21 
>   1:  21  10 
> 
> Same enough?

Yes. Just more RAM than me.
