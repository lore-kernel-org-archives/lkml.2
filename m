Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757196Ab2CVKea (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 06:34:30 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:62826 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750880Ab2CVKe0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 06:34:26 -0400
Date: Thu, 22 Mar 2012 11:34:20 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Nish Aravamudan <nish.aravamudan@gmail.com>,
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
        Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [RFC][PATCH 00/26] sched/numa
Message-ID: <20120322103420.GA32716@gmail.com>
References: <20120316144028.036474157@chello.nl>
 <CAOhV88NafiU7hseTzQfApthMk3X=_GT09gEM2Zzx5OJ=8z6vvw@mail.gmail.com>
 <1332409539.18960.508.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1332409539.18960.508.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> 
> > I was going to try and test this on power, but it fails to build:
> > 
> >   mm/filemap_xip.c: In function ‘__xip_unmap’:
> >   mm/filemap_xip.c:199: error: implicit declaration of function
> > ‘numa_add_vma_counter’
> 
> Add: 
> 
> #include <linux/mempolicy.h>
> 
> to that file and it should build.

I could stick your patches into tip:sched/numa (rebasing branch 
for now) to make it pullable and testable?

Thanks,

	Ingo
