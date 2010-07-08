Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753682Ab0GHGhL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 02:37:11 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60124 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752094Ab0GHGhJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 02:37:09 -0400
Date: Thu, 8 Jul 2010 08:36:44 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>,
       "2 . 6 . 31 . x-2 . 6 . 34 . x" <stable@kernel.org>
Subject: Re: [GIT PULL] perf fixes
Message-ID: <20100708063644.GA26474@elte.hu>
References: <1278563811-21818-1-git-send-regression-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1278563811-21818-1-git-send-regression-fweisbec@gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_20 autolearn=no SpamAssassin version=3.2.5
	-1.0 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.0562]
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
> This resurrects flat and graph (absolute fractals) callchains.
> All tested with and without newt.
> 
> As you know there are still things to fix: filtering by parents (probably a
> regression) and dso multiple callchains (not a regression).
> 
> Thanks,
> 	Frederic
> ---
> 
> Frederic Weisbecker (2):
>       perf: Resurrect flat callchains
>       perf: Sync callchains with period based hits
> 
> 
>  tools/perf/builtin-report.c |    2 +-
>  tools/perf/util/callchain.c |   35 ++++++++++++++++++-----------------
>  tools/perf/util/callchain.h |    5 ++++-
>  3 files changed, 23 insertions(+), 19 deletions(-)

Pulled, thanks Frederic!

	Ingo
