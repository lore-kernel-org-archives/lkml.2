Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754965Ab1DFLLK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 07:11:10 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:53156 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753994Ab1DFLLJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 07:11:09 -0400
Date: Wed, 6 Apr 2011 13:10:54 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, 2nddept-manager@sdl.hitachi.co.jp,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Lin Ming <ming.m.lin@intel.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [GIT PULL 0/5] perf/urgent fixes
Message-ID: <20110406111054.GA24706@elte.hu>
References: <1302087623-14724-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1302087623-14724-1-git-send-email-acme@infradead.org>
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


* Arnaldo Carvalho de Melo <acme@infradead.org> wrote:

> Hi Ingo,
> 
>         Please consider pulling from:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux-2.6 perf/urgent
> 
> Regards,
> 
> - Arnaldo
> 
> 
> Masami Hiramatsu (5):
>   perf probe: Fix to ensure function declared file
>   perf probe: Fix to remove redundant close
>   perf probe: Fix multiple --vars options behavior
>   perf probe: Fix to find recursively inlined function
>   perf probe: Fix listing incorrect line number with inline function
> 
>  tools/perf/util/probe-event.c  |   19 ++---
>  tools/perf/util/probe-finder.c |  159 ++++++++++++++++++++++++++--------------
>  2 files changed, 113 insertions(+), 65 deletions(-)

Pulled, thanks a lot Arnaldo!

	Ingo
