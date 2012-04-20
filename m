Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757235Ab2DTP4d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 11:56:33 -0400
Received: from www.linutronix.de ([62.245.132.108]:45755 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754959Ab2DTP4c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 11:56:32 -0400
Date: Fri, 20 Apr 2012 17:56:25 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Peter Zijlstra <peterz@infradead.org>
cc: Tejun Heo <tj@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        linux-arch@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        David Rientjes <rientjes@google.com>
Subject: Re: [patch 00/18] SMP: Boot and CPU hotplug refactoring - Part 1
In-Reply-To: <1334936964.2463.66.camel@laptop>
Message-ID: <alpine.LFD.2.02.1204201755580.2542@ionos>
References: <20120420122120.097464672@linutronix.de>  <1334928098.2463.56.camel@laptop>  <20120420154202.GB32324@google.com> <1334936964.2463.66.camel@laptop>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Apr 2012, Peter Zijlstra wrote:

> On Fri, 2012-04-20 at 08:42 -0700, Tejun Heo wrote:
> > I'm still leaning towards restricting kthreadd and any PF_THREAD_BOUND
> > threads in the root cgroup.  
> 
> I'd definitely agree with restricting those. 
> 
> > I'm not sure about !BOUND kthreads tho.
> > It doesn't make sense for the most part but there are cases
> > (e.g. crypto kthreads) which might make some sense.
> > 
> Agreed as well. There are a few nasty corner cases with unbound
> workqueues vs allowing cgroups (as how to place new worker threads
> correctly etc..). Sorting that is a 'fun' next problem.
> 
> Could we merge the kthreadd/PF_THREAD_BOUND restriction? You've got my
> ACK and I'm fairly sure tglx will ACK it as well.

Acked-and-appreciated-by-me
