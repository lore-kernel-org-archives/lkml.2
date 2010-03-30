Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755281Ab0C3DEl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 23:04:41 -0400
Received: from mail.openrapids.net ([64.15.138.104]:33936 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750899Ab0C3DEk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 23:04:40 -0400
Date: Mon, 29 Mar 2010 23:04:38 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Tejun Heo <tj@kernel.org>
Cc: Greg KH <greg@kroah.com>, Steven Rostedt <rostedt@goodmis.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, stable <stable@kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
       Eric Dumazet <dada1@cosmosbay.com>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [stable] [PATCH 2.6.29.x - 2.6.31.1] module: fix
	__module_ref_addr()
Message-ID: <20100330030438.GA7683@Krystal>
References: <20100327143126.GA25615@Krystal> <1269890492.19685.4767.camel@gandalf.stny.rr.com> <20100329200946.GA1618@Krystal> <20100329210722.GA14993@kroah.com> <4BB15E1E.70504@kernel.org> <4BB16339.8090602@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BB16339.8090602@kernel.org>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 23:02:59 up 66 days,  5:40,  4 users,  load average: 0.01, 0.04,
	0.01
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Tejun Heo (tj@kernel.org) wrote:
> On 03/30/2010 11:12 AM, Tejun Heo wrote:
> > Hello, Greg.
> > 
> > On 03/30/2010 06:07 AM, Greg KH wrote:
> >>> Yes. 2.6.34-rc does not have this issue anymore, but the patch is needed in
> >>> -stable.
> >>
> >> Why is this not in .34-rc2?  Can you find the specific patch in Linus's
> >> tree that solves this and let stable@kernel.org know about it?
> > 
> > For 2.6.34, the following two patches should remove the problem.
> > They're not in mainline yet but should appear in linux-next soon and
> > after a few days, I'll push them to Linus.
> > 
> >  http://thread.gmane.org/gmane.linux.kernel/958794/focus=959493
> 
> Oh, Steven is right.  The ones which are removed by the above patch
> are different ones.  That said, it might be a good idea to apply fixes
> for them to -stable too.  Mathieu, are you interested in submitting
> similar -stable fixes for kernel/module.c::percpu_modcopy() and
> lockdep.c::static_obj()?

Sure, will do. I'm doing a bit of testing and I'll post these patches shortly.

Thanks,

Mathieu

> 
> Thanks.
> 
> -- 
> tejun

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
