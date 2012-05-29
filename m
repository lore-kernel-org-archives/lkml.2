Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753977Ab2E2PSa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 11:18:30 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:35963 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751030Ab2E2PS3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 11:18:29 -0400
Date: Tue, 29 May 2012 10:10:49 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
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
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Christoph Lameter <cl@linux.com>
Subject: Re: [PATCH 03/35] xen: document Xen is using an unused bit for the
 pagetables
Message-ID: <20120529141049.GB3558@phenom.dumpdata.com>
References: <1337965359-29725-1-git-send-email-aarcange@redhat.com>
 <1337965359-29725-4-git-send-email-aarcange@redhat.com>
 <20120525202656.GA23655@phenom.dumpdata.com>
 <20120526155912.GA4054@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120526155912.GA4054@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 26, 2012 at 05:59:12PM +0200, Andrea Arcangeli wrote:
> Hi Konrad,
> 
> On Fri, May 25, 2012 at 04:26:56PM -0400, Konrad Rzeszutek Wilk wrote:
> > On Fri, May 25, 2012 at 07:02:07PM +0200, Andrea Arcangeli wrote:
> > > Xen has taken over the last reserved bit available for the pagetables
> > > which is set through ioremap, this documents it and makes the code
> > > more readable.
> > 
> > Andrea, my previous respone had a question about this - was wondering
> > if you had a chance to look at that in your busy schedule and provide
> > some advice on how to remove the _PAGE_IOMAP altogether?
> 
> I read you response but I didn't look into the P2M tree and
> xen_val_pte code yet sorry. Thanks for looking into this, if it's
> possible to remove it without downsides, it would be a nice

Yeah, I am not really thrilled about it.

> cleanup. It's not urgent though, we're not running out of reserved
> pte bits yet :).

Oh, your git comment says "the last reserved bit". Let me
look through all your patches to see how the AutoNUMA code works -
I am probably just missing something simple.
