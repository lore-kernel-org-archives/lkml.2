Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757024Ab0FBHNr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 03:13:47 -0400
Received: from fallback.mail.elte.hu ([157.181.151.13]:55117 "EHLO
	fallback.mail.elte.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751350Ab0FBHNq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 03:13:46 -0400
Date: Wed, 2 Jun 2010 09:13:38 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <peterz@infradead.org>, Pierre Tardy <tardyp@gmail.com>,
       Stephane Eranian <eranian@google.com>, Tom Zanussi <tzanussi@gmail.com>
Subject: Re: [GIT PULL 0/2] perf/urgent fixes
Message-ID: <20100602071338.GC17765@elte.hu>
References: <1275394648-13234-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1275394648-13234-1-git-send-email-acme@infradead.org>
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
> git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux-2.6 perf/urgent
> 
> Regards,
> 
> - Arnaldo
> 
> Konstantin Stepanyuk (1):
>   perf hist: fix objdump output parsing
> 
> Pierre Tardy (1):
>   perf scripts python: Give field dict to unhandled callback
> 
>  tools/perf/scripts/python/check-perf-trace.py      |    3 +-
>  tools/perf/util/hist.c                             |    2 +-
>  .../util/scripting-engines/trace-event-python.c    |   50 +++++++++++++------
>  3 files changed, 36 insertions(+), 19 deletions(-)

Pulled, thanks Arnaldo!

	Ingo
