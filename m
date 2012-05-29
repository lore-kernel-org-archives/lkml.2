Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754187Ab2E2QEH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 12:04:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7180 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752129Ab2E2QEF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 12:04:05 -0400
Date: Tue, 29 May 2012 18:01:29 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
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
Message-ID: <20120529160128.GC21339@redhat.com>
References: <1337965359-29725-1-git-send-email-aarcange@redhat.com>
 <1337965359-29725-4-git-send-email-aarcange@redhat.com>
 <20120525202656.GA23655@phenom.dumpdata.com>
 <20120526155912.GA4054@redhat.com>
 <20120529141049.GB3558@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120529141049.GB3558@phenom.dumpdata.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, May 29, 2012 at 10:10:49AM -0400, Konrad Rzeszutek Wilk wrote:
> Oh, your git comment says "the last reserved bit". Let me
> look through all your patches to see how the AutoNUMA code works -
> I am probably just missing something simple.

Ah, with "the last reserved bit" I didn't mean AutoNUMA is using
it. It just means there is nothing left if somebody in the future
needs it. AutoNUMA happened to need it initially, but I figured how I
was better off not using it. Initially I had to make AUTONUMA=y
mutually exclusive with XEN=y but it's not the case anymore. So at
this point the patch is only a cleanup, I could drop it too but I
thought it was cleaner to keep it.
