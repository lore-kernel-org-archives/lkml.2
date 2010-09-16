Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754163Ab0IPKau (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 06:30:50 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:57067 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753733Ab0IPKat (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 06:30:49 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19LfXI1LUxLDS/7X1DJvnT2Ufyy/r7sUhfyfROMC6
	uuWWmY5Rk4b7bz
Subject: Re: [RFC PATCH] sched: START_NICE feature (temporarily niced
 forks) (v3)
From: Mike Galbraith <efault@gmx.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, Tony Lindgren <tony@atomide.com>
In-Reply-To: <20100915140246.GA25983@elte.hu>
References: <20100914202503.GA1496@Krystal>
	 <1284539831.21727.6.camel@marge.simson.net>
	 <1284541405.22863.8.camel@marge.simson.net>
	 <20100915092205.GG16593@elte.hu>
	 <1284556366.22863.80.camel@marge.simson.net>
	 <20100915140246.GA25983@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 16 Sep 2010 12:30:47 +0200
Message-Id: <1284633047.9142.55.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-09-15 at 16:02 +0200, Ingo Molnar wrote:
> * Mike Galbraith <efault@gmx.de> wrote:
> 
> > On Wed, 2010-09-15 at 11:22 +0200, Ingo Molnar wrote:
> > > * Mike Galbraith <efault@gmx.de> wrote:
> > > 
> > > > Tangent: cgroups with classification user/pgid
> > > >
> > > > taskset -c 3 ./wakeup-latency& sleep 30 && killall wakeup-latency
> > > > (taskset -c 3 make -j10 running)
> > > > 
> > > > maximum latency: 256.5 µs
> > > > average latency: 25.7 µs
> > > > missed timer events: 0
> > > > 
> > > > Rather spiffy for this case.
> > > 
> > > Ouch, nothing beats proper segregation of workloads.
> > > 
> > > It would be _really_ nice to get that automatically somehow, for make -j 
> > > jobs. Perhaps a per tty auto-cgroup-classification kernel feature?
> > > 
> > > We cannot really rely on distros to pull this off.
> > 
> > Dunno, wasn't hard.
> 
> Renicing a make -j 10 isnt hard either - still people/apps dont do it
> :-/

True.  I'll put resurrect/tinker usersched back on good intentions list.

	-Mike

