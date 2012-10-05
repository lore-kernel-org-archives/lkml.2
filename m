Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754371Ab2JEXOw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 19:14:52 -0400
Received: from mga14.intel.com ([143.182.124.37]:22834 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753033Ab2JEXOr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 19:14:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,541,1344236400"; 
   d="scan'208";a="201161934"
From: Andi Kleen <andi@firstfloor.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>, linux-kernel@vger.kernel.org,
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
Subject: Re: [PATCH 00/33] AutoNUMA27
References: <1349308275-2174-1-git-send-email-aarcange@redhat.com>
	<20121004113943.be7f92a0.akpm@linux-foundation.org>
Date: Fri, 05 Oct 2012 16:14:44 -0700
In-Reply-To: <20121004113943.be7f92a0.akpm@linux-foundation.org> (Andrew
	Morton's message of "Thu, 4 Oct 2012 11:39:43 -0700")
Message-ID: <m24nm8wly3.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

> On Thu,  4 Oct 2012 01:50:42 +0200
> Andrea Arcangeli <aarcange@redhat.com> wrote:
>
>> This is a new AutoNUMA27 release for Linux v3.6.
>
> Peter's numa/sched patches have been in -next for a week. 

Did they pass review? I have some doubts.

The last time I looked it also broke numactl.

> Guys, what's the plan here?

Since they are both performance features their ultimate benefit
is how much faster they make things (and how seldom they make things
slower)

IMHO needs a performance shot-out. Run both on the same 10 workloads
and see who wins. Just a lot of of work. Any volunteers?

For a change like this I think less regression is actually more
important than the highest peak numbers.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
