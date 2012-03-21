Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964834Ab2CUXNt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 19:13:49 -0400
Received: from gw.danplanet.com ([50.43.125.66]:47832 "EHLO mail.danplanet.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753392Ab2CUXNr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 19:13:47 -0400
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
References: <20120316144028.036474157@chello.nl>
	<20120316182511.GJ24602@redhat.com> <87k42edenh.fsf@danplanet.com>
	<20120321021239.GQ24602@redhat.com> <87fwd2d2kp.fsf@danplanet.com>
	<20120321124937.GX24602@redhat.com> <87limtboet.fsf@danplanet.com>
	<20120321225242.GL24602@redhat.com>
Date: Wed, 21 Mar 2012 16:13:45 -0700
Message-ID: <87aa39bl92.fsf@danplanet.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

AA> available: 2 nodes (0-1)
AA> node 0 cpus: 0 1 2 3 4 5 12 13 14 15 16 17
AA> node 1 cpus: 6 7 8 9 10 11 18 19 20 21 22 23

available: 2 nodes (0-1)
node 0 cpus: 0 1 2 3 4 5 12 13 14 15 16 17
node 0 size: 12276 MB
node 0 free: 11769 MB
node 1 cpus: 6 7 8 9 10 11 18 19 20 21 22 23
node 1 size: 12288 MB
node 1 free: 11727 MB
node distances:
node   0   1 
  0:  10  21 
  1:  21  10 

Same enough?

-- 
Dan Smith
IBM Linux Technology Center
