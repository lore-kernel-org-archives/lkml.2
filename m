Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753079Ab0DDTCc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Apr 2010 15:02:32 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:44160 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750883Ab0DDTC1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Apr 2010 15:02:27 -0400
Date: Sun, 4 Apr 2010 21:02:11 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Arnd Bergmann <arnd@arndb.de>, Stephane Eranian <eranian@google.com>
Subject: Re: [GIT PULL] perf updates
Message-ID: <20100404190211.GA4564@elte.hu>
References: <1270391804-6552-1-git-send-regression-fweisbec@gmail.com>
 <20100404144223.GB5608@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100404144223.GB5608@nowhere>
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

> On Sun, Apr 04, 2010 at 04:36:40PM +0200, Frederic Weisbecker wrote:
> > Ingo,
> > 
> > Please pull the perf/core branch that can be found at:
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
> > 	perf/core
> > 
> > Thanks,
> > 	Frederic
> > ---
> > 
> > Frederic Weisbecker (2):
> >       perf: Drop the frame reliablity check
> >       perf: Fetch hot regs from the template caller
> > 
> > Arnd Bergmann (1):
> >       perf_event: Make perf fd non seekable
> > 
> > Hitoshi Mitake (1):
> >       Swap inclusion order of util.h and string.h in util/string.c
> 
> 
> I just did a last minute rebase, just to prepend the title of this
> one with "perf: "
> 
> 
> > 
> > 
> >  arch/x86/kernel/cpu/perf_event.c |    3 +--
> >  include/trace/ftrace.h           |   23 ++++++++++++-----------
> >  kernel/perf_event.c              |    1 +
> >  tools/perf/util/string.c         |    2 +-
> >  4 files changed, 15 insertions(+), 14 deletions(-)

Pulled, thanks a lot Frederic!

	Ingo
