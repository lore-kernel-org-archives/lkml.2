Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752046Ab1AYART (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 19:17:19 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:43813 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751307Ab1AYARP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 19:17:15 -0500
Date: Tue, 25 Jan 2011 01:16:58 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] perf fixes
Message-ID: <20110125001658.GA17623@elte.hu>
References: <20110124133400.GA1228@elte.hu>
 <AANLkTinsVNy9a1bR0AgD7=Vupoujt03RuZ32v39XSknx@mail.gmail.com>
 <20110124200738.GA10833@elte.hu>
 <AANLkTi=C0L=21zhH_L+cRPv2ZCRE9L93tKtC9ELrcTBW@mail.gmail.com>
 <AANLkTi=V61L6vgFZ_4u20dZvv2=tvi-XJMc2HqOnjMo4@mail.gmail.com>
 <20110124203802.GC29975@ghostprotocols.net>
 <20110124212526.GA13724@elte.hu>
 <20110124220032.GE29975@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110124220032.GE29975@ghostprotocols.net>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arnaldo Carvalho de Melo <acme@redhat.com> wrote:

> Em Mon, Jan 24, 2011 at 10:25:26PM +0100, Ingo Molnar escreveu:
> > * Arnaldo Carvalho de Melo <acme@redhat.com> wrote:
> > > Was this on a freshly installed machine? Or on a freshly updated one?
> > > 
> > > Probably its the build-id collecting at the end of a session, on the
> > > first run you had a cold cache and it had to figure out which binaries
> > > to cache on ~/.debug, second time it was already cached so it was fast.
> > 
> > Hm, it would be nice to not surprise users with an unlimited-timeout, up to half a 
> > minute 'frozen' app. Can we possibly display a more finegrained progress indicator?
> 
> Definetely, adding this to the todo list.
> 
> In fact perf_session__process_events already has an ui_progress stuff,
> its just that it works only on report/TUI. Need to make it work with
> some /-|/- spinning text progress indicator after a "collecting
> build-ids:" string, something like that.

Yeah, something like that would awesome!

No need for it to be particularly pretty or complex - just _some_ minimal feedback 
to the user gives us most of the bang for the buck already.

( And, of course, the best solution is to make it all run even faster. When it comes
  to debuginfo data structures i can not prevent myself from thinking 'bloat!' ;-)

Thanks,

	Ingo
