Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754217Ab1AGPhw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 10:37:52 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:55089 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753127Ab1AGPhv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 10:37:51 -0500
Date: Fri, 7 Jan 2011 16:37:45 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Soeren Sandmann Pedersen <sandmann@redhat.com>
Subject: Re: [RFC GIT PULL] perf updates
Message-ID: <20110107153745.GA2516@elte.hu>
References: <1294325513-14276-1-git-send-email-fweisbec@gmail.com>
 <20110107122317.GA20761@elte.hu>
 <20110107152421.GA2631@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110107152421.GA2631@nowhere>
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


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> On Fri, Jan 07, 2011 at 01:23:17PM +0100, Ingo Molnar wrote:
> > 
> > * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > 
> > > Ingo,
> > > 
> > > Please pull the perf/core branch that can be found at:
> > > 
> > > git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
> > > 	perf/core
> > > 	
> > > Soeren reported some time ago that callchains were broken on
> > > x86_64 with cpu-clock/task-clock events. After some time I
> > > finally found the problem was in the irq low level arg saving.
> > > It touches fragile code though, I hope some people can
> > > have a look over the fix.
> > > 
> > > Thanks,
> > > 	Frederic
> > > ---
> > > 
> > > Frederic Weisbecker (2):
> > >       x86: Fix rbp saving in pt_regs on irq entry
> > >       perf: Build tools with frame pointer
> > 
> > Is this variant fine with Jan too?
> 
> So, Arnaldo has picked up the second patch.
> 
> For the first I need to resend with a fix on CFI annotations.

ok, i'll wait with pulling then.

Thanks,

	Ingo
