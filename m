Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759222Ab2CVS4p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 14:56:45 -0400
Received: from gw.danplanet.com ([50.43.125.66]:53343 "EHLO mail.danplanet.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759125Ab2CVS4l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 14:56:41 -0400
From: Dan Smith <danms@us.ibm.com>
To: Andrea Arcangeli <aarcange@redhat.com>
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
References: <20120316182511.GJ24602@redhat.com> <87k42edenh.fsf@danplanet.com>
	<20120321021239.GQ24602@redhat.com> <87fwd2d2kp.fsf@danplanet.com>
	<20120321124937.GX24602@redhat.com> <87limtboet.fsf@danplanet.com>
	<20120321225242.GL24602@redhat.com>
	<20120322001722.GQ24602@redhat.com> <873990buuy.fsf@danplanet.com>
	<20120322142735.GE24602@redhat.com>
	<20120322184925.GT24602@redhat.com>
Date: Thu, 22 Mar 2012 11:56:37 -0700
In-Reply-To: <20120322184925.GT24602@redhat.com> (Andrea Arcangeli's message
	of "Thu, 22 Mar 2012 19:49:25 +0100")
Message-ID: <87limsa2hm.fsf@danplanet.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

AA> but now it's time to go back coding and add THP native
AA> migration. That will benefit everyone, from cpuset in userland to
AA> numa/sched.

I dunno about everyone else, but I think the thing I'd like to see most
(other than more interesting benchmarks) is a broken out and documented
set of patches instead of the monolithic commit you have now. I know you
weren't probably planning to do that until numasched came along, but it
sure would help me digest the differences in the two approaches.

-- 
Dan Smith
IBM Linux Technology Center
