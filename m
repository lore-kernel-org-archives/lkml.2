Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754588Ab2FMTSU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 15:18:20 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:48974 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752321Ab2FMTSR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 15:18:17 -0400
Date: Wed, 13 Jun 2012 12:17:45 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Rusty Russell <rusty@rustcorp.com.au>, Tejun Heo <tj@kernel.org>
Subject: Re: [RFC patch 2/5] smpboot: Provide infrastructure for percpu
 hotplug threads
Message-ID: <20120613191745.GG2427@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120613102823.373180763@linutronix.de>
 <20120613105815.206105518@linutronix.de>
 <20120613185748.GF2427@linux.vnet.ibm.com>
 <alpine.LFD.2.02.1206132101440.3086@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1206132101440.3086@ionos>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12061319-5930-0000-0000-000008D2D589
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 13, 2012 at 09:02:55PM +0200, Thomas Gleixner wrote:
> On Wed, 13 Jun 2012, Paul E. McKenney wrote:
> > On Wed, Jun 13, 2012 at 11:00:54AM -0000, Thomas Gleixner wrote:
> > >  	/* Now call notifier in preparation. */
> > >  	cpu_notify(CPU_ONLINE | mod, hcpu);
> > > +	smpboot_unpark_threads(cpu);
> > 
> > OK, RCU must use the lower-level interfaces, given that one of
> > then CPU_ONLINE notifiers might invoke synchronize_rcu().
> 
> We can start the threads before the notifiers. There is no
> restriction.

Sounds very good in both cases!

							Thanx, Paul

