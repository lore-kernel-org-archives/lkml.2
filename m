Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759687Ab0EDR7F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 13:59:05 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41186 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757243Ab0EDR7C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 13:59:02 -0400
Date: Tue, 4 May 2010 19:58:33 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH][GIT PULL] ring-buffer: Wrap open-coded WARN_ONCE
Message-ID: <20100504175833.GB3398@elte.hu>
References: <1272994366.9739.227.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1272994366.9739.227.camel@gandalf.stny.rr.com>
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
> Oops, I forgot to add this one too. I just pushed it after you did your
> last pull.
> 
> Please pull the latest tip/tracing/core tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> tip/tracing/core
> 
> 
> Borislav Petkov (1):
>       ring-buffer: Wrap open-coded WARN_ONCE
> 
> ----
>  kernel/trace/ring_buffer.c |   14 +++++---------
>  1 files changed, 5 insertions(+), 9 deletions(-)

Pulled, thanks Steve!

	Ingo
