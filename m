Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754208Ab0KSND6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 08:03:58 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:57894 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1754101Ab0KSND5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 08:03:57 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+5KB56Frm5QDcbw0vs/HddwI/ZbyMHN2OK9iE0xR
	YzdUo15Vao7wx3
Subject: Re: [RFC/RFT PATCH v3] sched: automated per tty task groups
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Menage <menage@google.com>,
        Samuel Thibault <samuel.thibault@ens-lyon.org>,
        Hans-Peter Jansen <hpj@urpla.net>, linux-kernel@vger.kernel.org,
        Lennart Poettering <mzxreary@0pointer.de>,
        Linus Torvalds <torvalds@linux-foundation.org>, david@lang.hm,
        Dhaval Giani <dhaval.giani@gmail.com>, Vivek Goyal <vgoyal@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ingo Molnar <mingo@elte.hu>, Balbir Singh <balbir@linux.vnet.ibm.com>
In-Reply-To: <1290171113.2109.1574.camel@laptop>
References: <1289916171.5169.117.camel@maggy.simson.net>
	 <AANLkTimC_TWzKET-aabYK0TPG6fUUW06HDej6iOzYtKo@mail.gmail.com>
	 <20101116211431.GA15211@tango.0pointer.de>
	 <201011182333.48281.hpj@urpla.net>
	 <20101118231218.GX6024@const.famille.thibault.fr>
	 <1290123351.18039.49.camel@maggy.simson.net>
	 <20101118234339.GA6024@const.famille.thibault.fr>
	 <1290167376.2109.1553.camel@laptop>
	 <AANLkTikB6QXxTav=b7qNzHUv4HXnjjT9TdcEdTYHbEkw@mail.gmail.com>
	 <1290171113.2109.1574.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 19 Nov 2010 06:03:34 -0700
Message-ID: <1290171814.3840.52.camel@maggy.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-11-19 at 13:51 +0100, Peter Zijlstra wrote:
> On Fri, 2010-11-19 at 04:31 -0800, Paul Menage wrote:
> > On Fri, Nov 19, 2010 at 3:49 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> > > It must be nice to be that ignorant ;-) Speaking for the scheduler
> > > cgroup controller (that being the only one I actually know), most all
> > > the load-balance operations are O(n) in the number of active cgroups,
> > > and a lot of the cpu local schedule operations are O(d) where d is the
> > > depth of the cgroup tree.
> > 
> > The same would apply to CPU autogroups, presumably?
> 
> Yep, they're not special at all... uses the same mechanism.

The only difference is cost of creation and destruction, so cgroups and
autogroups suck boulders of slightly different diameter when creating
and/or destroying at high frequency.

	-Mike


