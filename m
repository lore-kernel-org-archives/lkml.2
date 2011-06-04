Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756133Ab1FDKNx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jun 2011 06:13:53 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:50991 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755004Ab1FDKNw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jun 2011 06:13:52 -0400
Date: Sat, 4 Jun 2011 12:13:34 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, David Ahern <daahern@cisco.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [GIT PULL 0/4] perf/urgent fixes
Message-ID: <20110604101334.GA16292@elte.hu>
References: <1307118363-24092-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1307118363-24092-1-git-send-email-acme@infradead.org>
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

> 
> Hi Ingo,
> 
> 	As we discussed, here are just the fixes from my last perf/core pull
> request, all related to having the python binding usable again, please consider
> pulling from:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux perf/urgent
> 
> Regards,
> 
> - Arnaldo
> 
> Arnaldo Carvalho de Melo (3):
>   perf evlist: Remove dependency on debug routines
>   perf python: Use exception to propagate errors
>   perf evlist: Don't die if sample_{id_all|type} is invalid
> 
> Frederic Weisbecker (1):
>   perf python: Fix argument name list of read_on_cpu()
> 
>  tools/perf/builtin-test.c |    2 +-
>  tools/perf/util/event.c   |   16 ----------
>  tools/perf/util/event.h   |    2 -
>  tools/perf/util/evlist.c  |   68 +++++++++++++++++++++++++--------------------
>  tools/perf/util/evlist.h  |    6 ++-
>  tools/perf/util/evsel.c   |   16 ++++++++++
>  tools/perf/util/evsel.h   |    7 ++++
>  tools/perf/util/python.c  |   14 ++++-----
>  tools/perf/util/session.c |   12 +++++++-
>  9 files changed, 83 insertions(+), 60 deletions(-)

Pulled, thanks a lot Arnaldo!

One suggestion: please merge perf/urgent into perf/core before 
queueing up more changes which would conflict.

Thanks,

	Ingo
