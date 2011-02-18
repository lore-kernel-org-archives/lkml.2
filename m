Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755614Ab1BRH1M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 02:27:12 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:60981 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753279Ab1BRH1J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 02:27:09 -0500
Date: Fri, 18 Feb 2011 08:26:46 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, Arun Sharma <arun@sharma-home.net>,
        "David S . Miller" <davem@davemloft.net>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <robert.richter@amd.com>,
        Stephane Eranian <eranian@google.com>,
        Steven Rostedt <rostedt@goodmis.org>, Tom Zanussi <tzanussi@gmail.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [GIT PULL 0/5] perf/core improvements and fixes
Message-ID: <20110218072645.GB11404@elte.hu>
References: <1297975291-12792-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1297975291-12792-1-git-send-email-acme@infradead.org>
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
> Arnaldo Carvalho de Melo (4):
>   perf python: Add cgroup.c to setup.py to get it building again
>   perf hists: Print number of samples, not the period sum
>   perf record: Delay setting the header writing atexit call
>   perf report: Tell the user when a perf.data file has no samples
> 
> Stephane Eranian (1):
>   perf: make perf stat print user provided full event names
> 
>  tools/perf/builtin-record.c    |   10 +++++-----
>  tools/perf/builtin-report.c    |    6 ++++++
>  tools/perf/util/evsel.c        |    1 +
>  tools/perf/util/evsel.h        |    7 +++++++
>  tools/perf/util/hist.c         |    7 +++++--
>  tools/perf/util/parse-events.c |   10 ++++++++++
>  tools/perf/util/setup.py       |    2 +-
>  7 files changed, 35 insertions(+), 8 deletions(-)

Pulled, thanks a lot Arnaldo!

	Ingo
