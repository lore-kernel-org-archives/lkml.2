Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754329Ab2GNRD2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2012 13:03:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15899 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752313Ab2GNRDV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2012 13:03:21 -0400
Date: Sat, 14 Jul 2012 19:01:42 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Christoph Lameter <cl@linux.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Hillf Danton <dhillf@gmail.com>, Dan Smith <danms@us.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
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
        Rik van Riel <riel@redhat.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Alex Shi <alex.shi@intel.com>,
        Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Don Morris <don.morris@hp.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH 20/40] autonuma: alloc/free/init mm_autonuma
Message-ID: <20120714170142.GW10186@redhat.com>
References: <1340888180-15355-1-git-send-email-aarcange@redhat.com>
 <1340888180-15355-21-git-send-email-aarcange@redhat.com>
 <20120630051217.GG3975@localhost.localdomain>
 <20120712180828.GL20382@redhat.com>
 <20120712181738.GA1349@cmpxchg.org>
 <alpine.DEB.2.00.1207130918320.24910@router.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1207130918320.24910@router.home>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 13, 2012 at 09:19:06AM -0500, Christoph Lameter wrote:
> On Thu, 12 Jul 2012, Johannes Weiner wrote:
> 
> > On Thu, Jul 12, 2012 at 08:08:28PM +0200, Andrea Arcangeli wrote:
> > > On Sat, Jun 30, 2012 at 01:12:18AM -0400, Konrad Rzeszutek Wilk wrote:
> > > > On Thu, Jun 28, 2012 at 02:56:00PM +0200, Andrea Arcangeli wrote:
> > > > > This is where the mm_autonuma structure is being handled. Just like
> > > > > sched_autonuma, this is only allocated at runtime if the hardware the
> > > > > kernel is running on has been detected as NUMA. On not NUMA hardware
> > > >
> > > > I think the correct wording is "non-NUMA", not "not NUMA".
> > >
> > > That sounds far too easy to me, but I've no idea what's the right is here.
> >
> > UMA?
> >
> > Single-node hardware?
> 
> Lets be simple and stay with non-NUMA.

Ok, I already corrected all occurrences.

Thanks.
