Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933375Ab1ERSNR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 14:13:17 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:33469 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757309Ab1ERSNQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 14:13:16 -0400
Date: Wed, 18 May 2011 20:13:05 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 00/15] [GIT PULL] ftrace/recordmcount: cleanups and
 updates for recordmcount processing
Message-ID: <20110518181305.GB8190@elte.hu>
References: <20110518160809.724215604@goodmis.org>
 <1305736137.11267.13.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305736137.11267.13.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
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

> On Wed, 2011-05-18 at 12:08 -0400, Steven Rostedt wrote:
> > Ingo,
> > 
> > Please pull the latest tip/perf/core-2 tree, which can be found at:
> > 
> >   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> > tip/perf/core-2
> > 
> 
> Note, this is not based off of my tip/perf/core branch, but is based off
> of tip separately.

I pulled your tip/perf/core (b9df92d2a94e) on May 1, almost 3 weeks ago, into 
tip:perf/core.

> I'm not sure why you don't want to pull my tip/perf/core directly yet.

Because i already have? :-)

> [...] I'd like to get that infrastructure in and tested before the 40 merge 
> window so that we can focus on the perf function tracing in the 41 window, 
> and not try to figure out where bugs are between the two.
> 
> That pull request is here:
> 
>   http://marc.info/?l=linux-kernel&m=130469692420787

Well, that is an RFC patchset, named:

 [RFC][PATCH 00/13] ftrace: Allow multiple users to pick and choose functions

In that mail you specifically said:

 " I'm posting this patch series as an RFC, but I do not expect it to change 
   much. I still have to put it through more tests even though I ran several on 
   each set already. "

... with no pull vector in it. If you want me to pull something you need to put 
it into a branch i can see and you need to send a pull request :-)

Thanks,

	Ingo
