Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754827Ab2AEJV0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 04:21:26 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:37509 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754501Ab2AEJVX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 04:21:23 -0500
Date: Thu, 5 Jan 2012 10:19:16 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 00/16] [GIT PULL] tracing: fixes/cleanups, no
 stop-machine, update stack tracer
Message-ID: <20120105091916.GA22598@elte.hu>
References: <20111221123624.193898256@goodmis.org>
 <20120101180949.GA25066@elte.hu>
 <20120102105856.GA6661@elte.hu>
 <20120102134856.GA32673@elte.hu>
 <1325635373.12696.4.camel@gandalf.stny.rr.com>
 <1325635922.12696.8.camel@gandalf.stny.rr.com>
 <1325653301.12696.20.camel@gandalf.stny.rr.com>
 <20120104141107.GA24770@elte.hu>
 <1325696759.12696.24.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1325696759.12696.24.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> On Wed, 2012-01-04 at 15:11 +0100, Ingo Molnar wrote:
> > * Steven Rostedt <rostedt@goodmis.org> wrote:
> > 
> > > My mistake, I forgot to add the "minimum config" for booting 
> > > the box. When I did that, it booted fine. I kicked off the 
> > > bisect again, and lets see what happens.
> > 
> > Okay.
> > 
> > I too did a lot of testing, breaking my promise to do other 
> > stuff ;-)
> > 
> > *Both* of your trees [the NMI and the cleanup/fixes tree], when 
> > merged produced hangs or spontaneous reboots, within 5 
> > iterations typically.
> 
> I actually haven't looked at the NMI branch yet. I'm still 
> trying to figure out why the ftrace one would lockup. I'll try 
> another box to see if that one also locks up on tip/master 
> with your config.

Any update on this?

I'm also seeing build failures with certain configs:

kernel/trace/trace_stack.c:387:3: error: implicit declaration of function ‘ftrace_set_early_filter’ 
[-Werror=implicit-function-declaration]

Thanks,

	Ingo
