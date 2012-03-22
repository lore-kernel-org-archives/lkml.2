Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030487Ab2CVN6d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 09:58:33 -0400
Received: from gw.danplanet.com ([50.43.125.66]:51623 "EHLO mail.danplanet.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S964942Ab2CVN6c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 09:58:32 -0400
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
	<20120322001722.GQ24602@redhat.com>
Date: Thu, 22 Mar 2012 06:58:29 -0700
In-Reply-To: <20120322001722.GQ24602@redhat.com> (Andrea Arcangeli's message
	of "Thu, 22 Mar 2012 01:17:22 +0100")
Message-ID: <873990buuy.fsf@danplanet.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

AA> The only reasonable explanation I can imagine for the weird stuff
AA> going on with "numa01_inverse" is that maybe it was compiled without
AA> -DHARD_BIND? I forgot to specify -DINVERSE_BIND is a noop unless
AA> -DHARD_BIND is specified too at the same time. -DINVERSE_BIND alone
AA> results in the default build without -D parameters.

Ah, yeah, that's probably it. Later I'll try re-running some of the
cases to verify.

-- 
Dan Smith
IBM Linux Technology Center
