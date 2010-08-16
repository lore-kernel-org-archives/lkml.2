Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754923Ab0HPRap (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 13:30:45 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52316 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750845Ab0HPRap (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 13:30:45 -0400
Date: Mon, 16 Aug 2010 19:30:37 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [GIT PULL 0/1] perf/urgent TUI annotate fix
Message-ID: <20100816173037.GA2383@elte.hu>
References: <1281978631-15200-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1281978631-15200-1-git-send-email-acme@infradead.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.5
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0428]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arnaldo Carvalho de Melo <acme@infradead.org> wrote:

> From: Arnaldo Carvalho de Melo <infradead.org>
> 
> Hi Ingo,
> 
> 	I extracted a fix from the three patch perf/core series I sent,
> will rework the other, non critical patches on a new perf/core branch.
> 
>         Please pull from:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux-2.6 perf/urgent
> 
> Regards,
> 
> - Arnaldo
> 
> Arnaldo Carvalho de Melo (1):
>   perf annotate tui: Fix exit and RIGHT keys handling
> 
>  tools/perf/util/ui/browsers/annotate.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)


Pulled, thanks Arnaldo!

	Ingo
