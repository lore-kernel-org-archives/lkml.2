Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162350Ab2CSUDn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 16:03:43 -0400
Received: from merlin.infradead.org ([205.233.59.134]:53199 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162338Ab2CSUDh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 16:03:37 -0400
Message-ID: <1332187387.18960.389.camel@twins>
Subject: Re: [RFC][PATCH 00/26] sched/numa
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Avi Kivity <avi@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
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
        Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Date: Mon, 19 Mar 2012 21:03:07 +0100
In-Reply-To: <4F672384.1030601@redhat.com>
References: <20120316144028.036474157@chello.nl>
	   <4F670325.7080700@redhat.com> <1332155527.18960.292.camel@twins>
	  <4F671B90.3010209@redhat.com> <1332158992.18960.316.camel@twins>
	 <4F672384.1030601@redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-03-19 at 14:16 +0200, Avi Kivity wrote:
> > Afaik we do not use dma engines for memory migration. 
> 
> We don't, but I think we should. 

ISTR we (the community) had this discussion once. I also seem to
remember the general consensus being that DMA engines would mostly
likely not be worth the effort, although I can't really recall the
specifics.

Esp. for 4k pages the setup of the offload will likely be more expensive
than actually doing the memcpy.
