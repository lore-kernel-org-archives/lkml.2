Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757111Ab1AMRGf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 12:06:35 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:34860 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756796Ab1AMRGd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 12:06:33 -0500
Date: Thu, 13 Jan 2011 18:06:17 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Kirill Smelkov <kirr@mns.spb.ru>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <robert.richter@amd.com>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: Re: [GIT PULL 0/2] perf/urgent fixes and an disabled by default
 improvement
Message-ID: <20110113170617.GA12595@elte.hu>
References: <1294927876-23553-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1294927876-23553-1-git-send-email-acme@infradead.org>
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
> git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux-2.6 perf/urgent
> 
> 	The 'nodelay' mode for perf record is disabled by default and allows
> potentially many 'perf script' usecases that need to receive events as they
> happen, with no latency.
> 
> Regards,
> 
> - Arnaldo
> 
> Kirill Smelkov (1):
>   perf record: Add "nodelay" mode, disabled by default
> 
> Stephane Eranian (1):
>   perf sched: Fix list of events, dropping unsupported ':r' modifier
> 
>  tools/perf/Documentation/perf-record.txt |    3 +++
>  tools/perf/builtin-record.c              |    8 ++++++++
>  tools/perf/builtin-sched.c               |   18 +++++++++---------
>  3 files changed, 20 insertions(+), 9 deletions(-)

Pulled, thanks a lot Arnaldo!

	Ingo
