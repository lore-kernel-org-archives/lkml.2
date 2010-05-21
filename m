Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756325Ab0EUHw6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 03:52:58 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:60315 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753601Ab0EUHw5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 03:52:57 -0400
Date: Fri, 21 May 2010 09:52:41 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Russ Anderson <rja@sgi.com>,
       Stephane Eranian <eranian@google.com>, Tom Zanussi <tzanussi@gmail.com>
Subject: Re: [GIT PULL v2 0/2] Allow disabling TUI per command in
 ~/.perfconfig
Message-ID: <20100521075241.GA4110@elte.hu>
References: <1274404121-6115-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1274404121-6115-1-git-send-email-acme@infradead.org>
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


* Arnaldo Carvalho de Melo <acme@infradead.org> wrote:

> Hi Ingo,
> 
> 	I noticed some problems in the previous TUI 
> disabling patch, fixed in this v2 series, that also 
> includes a removal of some gettimeofday calls of little 
> utility submitted by Russ.
> 
>         Please pull from:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux-2.6 perf
> 
> Regards,
> 
> - Arnaldo
> 
> 
> Arnaldo Carvalho de Melo (1):
>   perf tui: Allow disabling the TUI on a per command basis in ~/.perfconfig
> 
> Russ Anderson (1):
>   perf record: remove unneeded gettimeofday() call
> 
>  tools/perf/builtin-record.c |   17 +----------------
>  tools/perf/builtin-report.c |    8 ++++----
>  tools/perf/perf.c           |   25 +++++++++++++++++++++++--
>  tools/perf/util/cache.h     |    2 +-
>  tools/perf/util/newt.c      |    9 ++++++---
>  5 files changed, 35 insertions(+), 26 deletions(-)

Pulled, thanks Arnaldo!

	Ingo
