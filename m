Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753159Ab1ECGs0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 02:48:26 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:32924 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752019Ab1ECGsY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 02:48:24 -0400
Date: Tue, 3 May 2011 08:48:13 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Borislav Petkov <bp@amd64.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Tony Luck <tony.luck@intel.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        EDAC devel <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: [PATCH 2/4] perf: Add persistent event facilities
Message-ID: <20110503064813.GA20342@elte.hu>
References: <1304357691-14354-1-git-send-email-bp@amd64.org>
 <1304357691-14354-3-git-send-email-bp@amd64.org>
 <20110503064046.GD7751@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110503064046.GD7751@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> >  include/linux/perf_event.h |   22 +++++++++++++++-
> >  kernel/events/Makefile     |    2 +-
> >  kernel/events/core.c       |   29 ++++++++++++++++++---
> >  kernel/events/persistent.c |   59 ++++++++++++++++++++++++++++++++++++++++++++
> >  4 files changed, 105 insertions(+), 7 deletions(-)
> >  create mode 100644 kernel/events/persistent.c
> 
> I really like this new kernel/events/ subdirectory you created - we could move 
> the other perf_events.c facilities there as well, and maybe split up the file a 
> bit, it's 7.5 KLOC now which is a bit excessive.
> 
> We should probably do that before adding kernel/events/persistent.c - wanna do 
> those changes? Initial commit should be a mostly-rename thing: 
> kernel/perf_events.c could move into kernel/events/core.c or so - and then we 
> could split the core up some more, into various facilities.

Looks like you have a time machine and after reading my feedback you have have 
sneaked this exact change into patch 1/4! :-)

( The alternative interpretation is that i should start reading series at the 
  beginning - not in the most interesting looking (largest) places where i 
  would stupidly ask for changes you've put into 1/4 already. )

Thanks,

	Ingo
