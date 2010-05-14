Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755457Ab0ENGWz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 02:22:55 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51098 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755272Ab0ENGWw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 02:22:52 -0400
Date: Fri, 14 May 2010 08:22:33 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Kirill Smelkov <kirr@mns.spb.ru>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>,
       Tom Zanussi <tzanussi@gmail.com>
Subject: Re: [GIT PULL 0/4] perf tools fixes
Message-ID: <20100514062233.GC24938@elte.hu>
References: <1273781964-29552-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1273781964-29552-1-git-send-email-acme@infradead.org>
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
> git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux-2.6 perf
> 
> Regards,
> 
> - Arnaldo
> 
> 
> Frederic Weisbecker (2):
>   perf hist: Fix hists__browse no-newt case
>   perf hist: Fix missing getline declaration
> 
> Kirill Smelkov (1):
>   perf trace scripts: Fix typos in perf-trace-python.txt
> 
> Stephane Eranian (1):
>   perf tools: change event inheritance logic in stat and record
> 
>  tools/perf/Documentation/perf-record.txt       |    4 ++--
>  tools/perf/Documentation/perf-stat.txt         |    4 ++--
>  tools/perf/Documentation/perf-trace-python.txt |    4 ++--
>  tools/perf/builtin-record.c                    |   12 ++++++------
>  tools/perf/builtin-stat.c                      |   10 +++++-----
>  tools/perf/util/hist.c                         |    1 +
>  tools/perf/util/hist.h                         |    2 +-
>  7 files changed, 19 insertions(+), 18 deletions(-)

Pulled, thanks Arnaldo!

	Ingo
