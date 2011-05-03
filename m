Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751473Ab1ECIWx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 04:22:53 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38530 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751074Ab1ECIWv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 04:22:51 -0400
Date: Tue, 3 May 2011 10:22:34 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Borislav Petkov <bp@amd64.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Tony Luck <tony.luck@intel.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        EDAC devel <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/4] perf: Add persistent event facilities
Message-ID: <20110503082234.GB6999@elte.hu>
References: <1304357691-14354-1-git-send-email-bp@amd64.org>
 <1304357691-14354-3-git-send-email-bp@amd64.org>
 <20110503064046.GD7751@elte.hu>
 <20110503071215.GA18979@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110503071215.GA18979@aftab>
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


* Borislav Petkov <bp@amd64.org> wrote:

> > we could move the other perf_events.c facilities there as well, and maybe 
> > split up the file a bit, it's 7.5 KLOC now which is a bit excessive.
> 
> Right, so I left perf_event.c as a whole on purpose (only renamed) because it 
> makes more sense IMHO for someone who actually wrote it to split it in 
> logical parts (^hint hint^). I mean, I could do it too but it'll take me much 
> more time :).

Well you are now writing new events code as well so spending that time might be 
a good investment in terms of getting persistent.c right as well.

Could you send a Git pull request against perf/core that does the obvious file 
movement and renaming? We can do that first step straight away and get the ball 
rolling.

Thanks,

	Ingo
