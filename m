Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753718Ab1KRRe0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 12:34:26 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:60001 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753415Ab1KRReZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 12:34:25 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18N0tw8FQgN+vCNLUQg1ye7TdQHK1vAQ0dt3Y/Q+b
	J9QtVVLzGGOcIK
Subject: Re: [patch 1/6] sched: use rt.nr_cpus_allowed to recover
 select_task_rq() cycles
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Paul Turner <pjt@google.com>
In-Reply-To: <1321630552.2197.15.camel@twins>
References: <1321350377.1421.55.camel@twins>
	 <1321406062.16760.60.camel@sbsiddha-desk.sc.intel.com>
	 <1321435455.5072.64.camel@marge.simson.net>
	 <1321468646.11680.2.camel@sbsiddha-desk.sc.intel.com>
	 <1321495153.5100.7.camel@marge.simson.net>
	 <1321544313.6308.25.camel@marge.simson.net>
	 <1321545376.2495.1.camel@laptop>
	 <1321547917.6308.48.camel@marge.simson.net>
	 <1321551381.15339.21.camel@sbsiddha-desk.sc.intel.com>
	 <1321629267.7080.13.camel@marge.simson.net>
	 <1321629441.7080.15.camel@marge.simson.net>
	 <1321630552.2197.15.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 18 Nov 2011 18:34:19 +0100
Message-ID: <1321637659.6238.15.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-11-18 at 16:35 +0100, Peter Zijlstra wrote:
> On Fri, 2011-11-18 at 16:17 +0100, Mike Galbraith wrote:
> >  kernel/sched_fair.c |    3 +++
> >  kernel/sched_rt.c   |    3 +++
> 
> I hate to be the bringer of bad news, but you're going to have to respin
> all this, these files no longer exist ;-)

No biggie, will do.

I'm just showing what was in the kernel to go with the numbers.

The nohz thing I dislike, but the problem isn't going away.  Don't like
the select_idle_sibling() ratelimit as is either, but I don't have a
better solution to this two faced little bugger.

> Please update your tip/master.

Yeah, these were master branch.  Was twiddling stable as usual first, as
you then don't have to worry about stuff changing (especially unrelated
stuff that still affects you) day to day, and munging results.

> Also, < 2 ? nr_cpus_allowed being 0 is somewhat of a problem, so the
> only remaining option is == 1.

True, but see select_task_rq_rt() :)

	-Mike

