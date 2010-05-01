Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757510Ab0EATpt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 May 2010 15:45:49 -0400
Received: from mail.openrapids.net ([64.15.138.104]:48625 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754033Ab0EATps (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 May 2010 15:45:48 -0400
Date: Sat, 1 May 2010 15:45:45 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Imre Deak <imre.deak@nokia.com>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
       Jamie Lokier <jamie@shareable.org>,
       "rostedt@goodmis.org" <rostedt@goodmis.org>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] create generic alignment api (v5)
Message-ID: <20100501194545.GA17271@Krystal>
References: <20100328012247.GA17763@Krystal> <20100328154029.GA21061@localhost> <20100329000900.GB27379@Krystal> <20100501183544.GC27062@shisha.kicks-ass.net> <20100501191045.GA16710@Krystal> <20100501192915.GD27062@shisha.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100501192915.GD27062@shisha.kicks-ass.net>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 15:45:29 up 98 days, 22:22,  6 users,  load average: 0.00, 0.00,
	0.00
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Alexander Shishkin (virtuoso@slind.org) wrote:
> On Sat, May 01, 2010 at 03:10:45 -0400, Mathieu Desnoyers wrote:
> > * Alexander Shishkin (virtuoso@slind.org) wrote:
> > > On Sun, Mar 28, 2010 at 08:09:00 -0400, Mathieu Desnoyers wrote:
> > > > Rather than re-doing the "alignment on a type size" trick all over again at
> > > > different levels, import the "ltt_align" from LTTng into kernel.h and make this
> > > > available to everyone. Renaming to:
> > > > 
> > > > - object_align()
> > > > - object_align_floor()
> > > > - offset_align()
> > > > - offset_align_floor()
> > > 
> > > Do you plan to have this integrated to the mainline? I'd like to use one of
> > > these in my next version of the __xchg patch. So, do you need any help or
> > > feedback or whatnot with this one?
> > 
> > Given that no one seems to oppose to this patch, I think I'll just re-submit it
> > as-is for real this time.
> 
> Sorry, a short explanation: it has to be a separate header file in order to be of
> use to me, since I need those in system.h, which gets included implicitly through
> bitops.h earlier in kernel.h.
> 
> So I took the liberty to hack up a v6 of this patch.

Yep, I'm ok with this change.

Thanks,

Mathieu

> 
> Regards,
> --
> Alex

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
