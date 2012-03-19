Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758223Ab2CSLkG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 07:40:06 -0400
Received: from casper.infradead.org ([85.118.1.10]:40931 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754752Ab2CSLkE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 07:40:04 -0400
Message-ID: <1332157166.18960.299.camel@twins>
Subject: Re: [RFC][PATCH 00/26] sched/numa
From: Peter Zijlstra <peterz@infradead.org>
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
Date: Mon, 19 Mar 2012 12:39:26 +0100
In-Reply-To: <1332155527.18960.292.camel@twins>
References: <20120316144028.036474157@chello.nl>
	 <4F670325.7080700@redhat.com> <1332155527.18960.292.camel@twins>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-03-19 at 12:12 +0100, Peter Zijlstra wrote:
> > - doesn't work well with large pages
> 
> That's for someone who cares about large pages to sort, isn't it? Also,
> I thought you virt people only used THP anyway, and those work just fine
> (they get broken down, and presumably something will build them back up
> on the other side). 

Note that all it would take is to make THP swap work. That on its own
might make sense too since writing a 2M stip of data is probably as fast
as a single 4K page on many of the rotating rust things. No idea on SSD,
but those things are typically fast either way.
