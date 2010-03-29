Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751751Ab0C2NQj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 09:16:39 -0400
Received: from mail.openrapids.net ([64.15.138.104]:33891 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751477Ab0C2NQg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 09:16:36 -0400
Date: Mon, 29 Mar 2010 09:16:34 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Peter Zijlstra <peterz@infradead.org>, Tejun Heo <tj@kernel.org>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, dipankar@in.ibm.com,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
       dhowells@redhat.com, eric.dumazet@gmail.com, adobriyan@gmail.com
Subject: Re: [RFC patch] extable and module add object is static
Message-ID: <20100329131633.GA22730@Krystal>
References: <20100327153233.993367557@efficios.com> <20100327224606.GK2343@linux.vnet.ibm.com> <20100327231421.GA4685@Krystal> <20100327232024.GB4685@Krystal> <20100327234314.GL2343@linux.vnet.ibm.com> <20100328000234.GA4924@Krystal> <4BB004ED.5060106@cn.fujitsu.com> <1269852814.12097.167.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1269852814.12097.167.camel@laptop>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 09:14:52 up 65 days, 15:52,  7 users,  load average: 0.04, 0.05,
	0.07
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra (peterz@infradead.org) wrote:
> On Mon, 2010-03-29 at 09:39 +0800, Lai Jiangshan wrote:
> > Mathieu Desnoyers wrote:
> > > +static int core_object_is_static(void *obj)
> > > +{
> > [...]
> > > +	if (addr >= (unsigned long)__per_cpu_start &&
> > > +	    addr <= (unsigned long)__per_cpu_end)
> > > +		return 1;
> > 
> > This may only correct for UP.
> > You may need arch-special codes for SMP.
> > 
> 
> Tejun has patches for this.
> 

That's great! Tejun, can you point me out to an update version of these
patches ? I am particularly interested in being able to know the range of
statically defined per-cpu data.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
