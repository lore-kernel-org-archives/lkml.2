Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755190Ab0IMMb5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 08:31:57 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:54137 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1750871Ab0IMMb4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 08:31:56 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+1vdomrDO1MZkvSET6HD6kSbzKilwjMY+PfFofbY
	xLyeb4oGES/hI0
Subject: Re: [RFC patch 1/2] sched: dynamically adapt granularity with
 nr_running
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, Tony Lindgren <tony@atomide.com>
In-Reply-To: <1284378235.2275.227.camel@laptop>
References: <20100911173732.551632040@efficios.com>
	 <20100911174003.051303123@efficios.com> <20100912061452.GA3383@elte.hu>
	 <1284276098.9111.24.camel@marge.simson.net>
	 <20100912181626.GB32327@Krystal>
	 <1284351183.7321.36.camel@marge.simson.net>
	 <20100913064153.GB14728@elte.hu>
	 <1284361716.25120.19.camel@marge.simson.net>
	 <1284366936.2275.27.camel@laptop>
	 <1284369373.14710.11.camel@marge.simson.net>
	 <1284370660.2275.86.camel@laptop>
	 <1284371457.14888.9.camel@marge.simson.net>
	 <1284371756.2275.108.camel@laptop>  <1284374728.2275.159.camel@laptop>
	 <1284378235.2275.227.camel@laptop>
Content-Type: text/plain
Date: Mon, 13 Sep 2010 14:32:18 +0200
Message-Id: <1284381138.7410.4.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-09-13 at 13:43 +0200, Peter Zijlstra wrote:
> On Mon, 2010-09-13 at 12:45 +0200, Peter Zijlstra wrote:
> > What we want is real deadlines, the patch provides the infrastructure,
> > let me frob something for that. 
> 
> Here, real deadline, but totally untested (except for compile).

You're fast.  Now to see if I can find the early forever Loop :)

> Please read through the logic. The idea was to do as we always do,
> except keep a deadline on enqueue for now + __sched_period, once we find
> that a deadline expired, we force run that task.

Yeah, I'll go read/piddle.

	-Mike

