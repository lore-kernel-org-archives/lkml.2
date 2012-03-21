Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754022Ab2CUHNF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 03:13:05 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:59824 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751921Ab2CUHND (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 03:13:03 -0400
Date: Wed, 21 Mar 2012 08:12:58 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Dan Smith <danms@us.ibm.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
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
Message-ID: <20120321071258.GA24997@gmail.com>
References: <20120316144028.036474157@chello.nl>
 <20120316182511.GJ24602@redhat.com>
 <87k42edenh.fsf@danplanet.com>
 <20120321021239.GQ24602@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120321021239.GQ24602@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrea Arcangeli <aarcange@redhat.com> wrote:

> [...]
> 
> So give me a break... you must have made a real mess in your 
> benchmarking. numasched is always doing worse than upstream 
> here, in fact two times massively worse. Almost as bad as the 
> inverse binds.

Andrea, please stop attacking the messenger.

We wanted and needed more testing, and I'm glad that we got it.

Can we please figure out all the details *without* accusing 
anyone of having made a mess? It is quite possible as well that 
*you* made a mess of it somewhere, either at the conceptual 
stage or at the implementational stage, right?

numasched getting close to the hard binding numbers is pretty 
much what I'd expect to see from it: it is an 
automatic/intelligent CPU and memory affinity (and migration) 
method to approximate the results of manual hard binding of 
threads.

Thanks,

	Ingo
