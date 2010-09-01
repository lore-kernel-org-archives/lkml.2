Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754868Ab0IARbP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 13:31:15 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:50186 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751564Ab0IARbO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 13:31:14 -0400
Date: Wed, 1 Sep 2010 19:30:59 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Neil Brown <neilb@suse.de>,
        "John W. Linville" <linville@tuxdriver.com>,
        "ksummit-2010-discuss@lists.linux-foundation.org" 
	<ksummit-2010-discuss@lists.linux-foundation.org>
Subject: Re: [PATCH][GIT PULL] ring-buffer: Place duplicate expression into a
 single function
Message-ID: <20100901173059.GB23357@elte.hu>
References: <AANLkTinCaKNXadoTtOvBhO3K5mOyzHi=ZJw4guWWB1W6@mail.gmail.com>
 <20100826210328.4ccd5aaf@notabene>
 <1283220647.1377.69.camel@gandalf.stny.rr.com>
 <20100831132708.GA2484@tuxdriver.com>
 <1283263428.2945.83.camel@powerslave>
 <20100901080715.5834450d@notabene>
 <1283295699.1377.732.camel@gandalf.stny.rr.com>
 <20100901133653.GB2486@tuxdriver.com>
 <1283351527.2356.22.camel@gandalf.stny.rr.com>
 <1283359792.2356.39.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1283359792.2356.39.camel@gandalf.stny.rr.com>
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


* Steven Rostedt <rostedt@goodmis.org> wrote:

> 
> Ingo,
> 
> Please pull the latest tip/perf/core tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> tip/perf/core
> 
> 
> Steven Rostedt (1):
>       ring-buffer: Place duplicate expression into a single function
> 
> ----
>  kernel/trace/ring_buffer.c |   21 +++++++++++++++------
>  1 files changed, 15 insertions(+), 6 deletions(-)

Pulled, thanks Steve!

	Ingo
