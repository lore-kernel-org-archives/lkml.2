Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759767Ab0GQJfo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jul 2010 05:35:44 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:33863 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759725Ab0GQJfm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jul 2010 05:35:42 -0400
Date: Sat, 17 Jul 2010 11:35:32 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, Chase Douglas <chase.douglas@canonical.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: Re: [GIT PULL 0/3] perf/core fixes and improvements
Message-ID: <20100717093532.GA12435@elte.hu>
References: <1279303773-27861-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1279303773-27861-1-git-send-email-acme@infradead.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.5 required=5.9 tests=BAYES_40 autolearn=no SpamAssassin version=3.2.5
	0.5 BAYES_40               BODY: Bayesian spam probability is 20 to 40%
	[score: 0.2943]
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
> Masami Hiramatsu (3):
>   perf probe: Fix error message if get_real_path() failed
>   perf probe: Support comp_dir to find an absolute source path
>   perf probe: Fix the logic of die_compare_name
> 
>  tools/perf/util/probe-event.c  |   69 ++++++++++++++++++++++++++++
>  tools/perf/util/probe-event.h  |    1 +
>  tools/perf/util/probe-finder.c |   96 ++++++++++++++--------------------------
>  3 files changed, 103 insertions(+), 63 deletions(-)

Pulled, thanks Arnaldo!

	Ingo
