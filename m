Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753791Ab0KSNUl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 08:20:41 -0500
Received: from mail.openrapids.net ([64.15.138.104]:44094 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752393Ab0KSNUk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 08:20:40 -0500
Date: Fri, 19 Nov 2010 08:20:37 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Samuel Thibault <samuel.thibault@ens-lyon.org>,
        Mike Galbraith <efault@gmx.de>, Hans-Peter Jansen <hpj@urpla.net>,
        linux-kernel@vger.kernel.org,
        Lennart Poettering <mzxreary@0pointer.de>,
        Linus Torvalds <torvalds@linux-foundation.org>, david@lang.hm,
        Dhaval Giani <dhaval.giani@gmail.com>, Vivek Goyal <vgoyal@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Ingo Molnar <mingo@elte.hu>, Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: [RFC/RFT PATCH v3] sched: automated per tty task groups
Message-ID: <20101119132037.GA18589@Krystal>
References: <AANLkTimC_TWzKET-aabYK0TPG6fUUW06HDej6iOzYtKo@mail.gmail.com> <20101116211431.GA15211@tango.0pointer.de> <201011182333.48281.hpj@urpla.net> <20101118231218.GX6024@const.famille.thibault.fr> <1290123351.18039.49.camel@maggy.simson.net> <20101118234339.GA6024@const.famille.thibault.fr> <1290167376.2109.1553.camel@laptop> <1290169178.2109.1573.camel@laptop> <20101119125548.GC24411@Krystal> <1290171648.2109.1580.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290171648.2109.1580.camel@laptop>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 08:13:48 up 57 days, 17:15,  3 users,  load average: 1.09, 1.22,
	1.19
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra (peterz@infradead.org) wrote:
> On Fri, 2010-11-19 at 07:55 -0500, Mathieu Desnoyers wrote:
[...]
> > Yep, this looks like one of these perpetual throughput vs latency trade-offs.
> > 
> Trade-off sure, throughput vs latency only in a specific use-case, its
> more a feature vs cost thing, just like all them trace people want lower
> cost tracing but want more features at the same time..

Yep, agreed for "feature vs cost", given that the kind of latency that is fixed
in this case really boils down to a sluggish system under a relatively common
workload -- so making this work might be called a "feature". ;)

FWIW, about tracing, well, we should distinguish between features that add cost
to the fast-path and slow-path only.

But I really don't care anymore, since Ingo, Linus, Thomas and yourself made it
very clear that you don't care. So let's not even start this discussion --
it's going nowhere.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
