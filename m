Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755262Ab0HCFo1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 01:44:27 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:43813 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755194Ab0HCFo0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 01:44:26 -0400
Date: Tue, 3 Aug 2010 07:44:19 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [GIT PULL 0/3] perf/core fixes and improvements
Message-ID: <20100803054419.GB1130@elte.hu>
References: <1280801352-4630-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1280801352-4630-1-git-send-email-acme@infradead.org>
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
>         Please pull from:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux-2.6 perf/core
> 
> Regards,
> 
> - Arnaldo
> 
> Arnaldo Carvalho de Melo (3):
>   perf session: Free the ref_reloc_sym memory at the right place
>   perf session: Invalidate last_match when removing threads from rb_tree
>   perf tools: Don't keep unreferenced maps when unmaps are detected
> 
>  tools/perf/util/hist.c    |    2 +
>  tools/perf/util/map.c     |   49 +++++++++++++++++++++++++++++---------------
>  tools/perf/util/map.h     |   10 ++++++++-
>  tools/perf/util/session.c |    8 +++++++
>  tools/perf/util/symbol.c  |   43 +++++++++++++++++++++++++++++++++++++++
>  tools/perf/util/symbol.h  |    2 +
>  6 files changed, 96 insertions(+), 18 deletions(-)

Pulled, thanks Arnaldo!

	Ingo
