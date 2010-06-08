Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756553Ab0FHWq0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 18:46:26 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55282 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753477Ab0FHWqZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 18:46:25 -0400
Date: Wed, 9 Jun 2010 00:45:22 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@redhat.com>,
       Roland McGrath <roland@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jason Baron <jbaron@redhat.com>, Masami Hiramatsu <mhiramat@redhat.com>,
       "2 . 6 . 33 . x-2 . 6 . 34 . x" <stable@kernel.org>
Subject: Re: [GIT PULL] tracing fix
Message-ID: <20100608224522.GA10006@elte.hu>
References: <1276036189-10354-1-git-send-regression-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1276036189-10354-1-git-send-regression-fweisbec@gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_20 autolearn=no SpamAssassin version=3.2.5
	-1.0 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.0558]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> Ingo,
> 
> Please pull the perf/urgent branch that can be found at:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
> 	perf/urgent
> 
> Thanks,
> 	Frederic
> ---
> 
> Oleg Nesterov (1):
>       tracing: Fix null pointer deref with SEND_SIG_FORCED
> 
> 
>  include/trace/events/signal.h |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)

Pulled, thanks Frederic!

	Ingo
