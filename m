Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756110Ab2JEX5N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 19:57:13 -0400
Received: from mga09.intel.com ([134.134.136.24]:47450 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752254Ab2JEX5K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 19:57:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,541,1344236400"; 
   d="scan'208";a="221355047"
Subject: Re: [PATCH 00/33] AutoNUMA27
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <pzijlstr@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Mel Gorman <mel@csn.ul.ie>, Hugh Dickins <hughd@google.com>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Hillf Danton <dhillf@gmail.com>, Andrew Jones <drjones@redhat.com>,
        Dan Smith <danms@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>,
        Paul Turner <pjt@google.com>, Christoph Lameter <cl@linux.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Mike Galbraith <efault@gmx.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Bharata B Rao <bharata.rao@gmail.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Alex Shi <alex.shi@intel.com>,
        Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>,
        Konrad@linux.intel.com
In-Reply-To: <m24nm8wly3.fsf@firstfloor.org>
References: <1349308275-2174-1-git-send-email-aarcange@redhat.com>
	 <20121004113943.be7f92a0.akpm@linux-foundation.org>
	 <m24nm8wly3.fsf@firstfloor.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 05 Oct 2012 16:57:13 -0700
Message-ID: <1349481433.17632.62.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-10-05 at 16:14 -0700, Andi Kleen wrote:
> Andrew Morton <akpm@linux-foundation.org> writes:
> 
> > On Thu,  4 Oct 2012 01:50:42 +0200
> > Andrea Arcangeli <aarcange@redhat.com> wrote:
> >
> >> This is a new AutoNUMA27 release for Linux v3.6.
> >
> > Peter's numa/sched patches have been in -next for a week. 
> 
> Did they pass review? I have some doubts.
> 
> The last time I looked it also broke numactl.
> 
> > Guys, what's the plan here?
> 
> Since they are both performance features their ultimate benefit
> is how much faster they make things (and how seldom they make things
> slower)
> 
> IMHO needs a performance shot-out. Run both on the same 10 workloads
> and see who wins. Just a lot of of work. Any volunteers?
> 
> For a change like this I think less regression is actually more
> important than the highest peak numbers.
> 
> -Andi
> 

I remembered that 3 months ago when Alex tested the numa/sched patches
there were 20% regression on SpecJbb2005 due to the numa balancer.
Those issues may have been fixed but we probably need to run this
benchmark against the latest.  For most of the other kernel performance
workloads we ran we didn't see much changes.

Maurico has a different config for this benchmark and it will be nice
if he can also check to see if there are any performance changes on his
side.

Tim


