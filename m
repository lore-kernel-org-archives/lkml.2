Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755359Ab1CBHHn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 02:07:43 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:49811 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751264Ab1CBHHm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 02:07:42 -0500
Date: Wed, 2 Mar 2011 08:07:23 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [GIT PULL 0/6] perf/core top tui fixes and improvements
Message-ID: <20110302070723.GA11361@elte.hu>
References: <1298999027-30673-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1298999027-30673-1-git-send-email-acme@infradead.org>
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
>         Please consider pulling from:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux-2.6 perf/core
> 
> Regards,
> 
> - Arnaldo
> 
> Arnaldo Carvalho de Melo (6):
>   perf top browser: Fix up exit keys
>   perf ui browser: Introduce ui_browser__show_title
>   perf top browser: Handle empty active symbols list
>   perf tui: Make ui__warning modal
>   perf top: Fix reporting of invalid --vmlinux
>   perf top tui: Wait till the first sample to refresh the screen.
> 
>  tools/perf/builtin-top.c          |   26 ++++++++++++++++++++++----
>  tools/perf/util/top.h             |    1 +
>  tools/perf/util/ui/browser.c      |   18 +++++++++++++++---
>  tools/perf/util/ui/browser.h      |    3 ++-
>  tools/perf/util/ui/browsers/top.c |   13 +++++++++++++
>  tools/perf/util/ui/util.c         |    7 +++++--
>  6 files changed, 58 insertions(+), 10 deletions(-)

Pulled, thanks a lot Arnaldo!

	Ingo
