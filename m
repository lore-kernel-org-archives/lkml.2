Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757516Ab2GFPDL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 11:03:11 -0400
Received: from casper.infradead.org ([85.118.1.10]:47303 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751194Ab2GFPDJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 11:03:09 -0400
Message-ID: <1341586950.7709.55.camel@twins>
Subject: Re: [RFC][PATCH 02/26] mm, mpol: Remove NUMA_INTERLEAVE_HIT
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Minchan Kim <minchan@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
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
        Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Date: Fri, 06 Jul 2012 17:02:30 +0200
In-Reply-To: <20120706144820.GC2328@barrios>
References: <20120316144028.036474157@chello.nl>
	 <20120316144240.234456258@chello.nl> <20120706103255.GA23680@cmpxchg.org>
	 <20120706144820.GC2328@barrios>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-07-06 at 23:48 +0900, Minchan Kim wrote:
> 
> I alreay sent a patch about that but didn't have a reply from
> Peter/Ingo.
> 
> https://lkml.org/lkml/2012/7/3/477 

Yeah sorry for that.. it looks like Ingo picked up the fix from hnaz
though.

Thanks both!
