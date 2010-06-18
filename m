Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758656Ab0FRIv6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 04:51:58 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57869 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758083Ab0FRIv4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 04:51:56 -0400
Date: Fri, 18 Jun 2010 10:51:36 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Ian Munsie <imunsie@au1.ibm.com>, Mike Galbraith <efault@gmx.de>,
       Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Stephane Eranian <eranian@google.com>, Tom Zanussi <tzanussi@gmail.com>
Subject: Re: [GIT PULL 0/2] perf/urgent fixes for 2.6.35
Message-ID: <20100618085136.GB24562@elte.hu>
References: <1276807013-21626-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1276807013-21626-1-git-send-email-acme@infradead.org>
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
> Arnaldo Carvalho de Melo (1):
>   perf session: Remove threads from tree on PERF_RECORD_EXIT
> 
> Ian Munsie (1):
>   perf record: prevent kill(0, SIGTERM);
> 
>  tools/perf/builtin-record.c |    2 +-
>  tools/perf/util/event.c     |    4 +++-
>  tools/perf/util/session.c   |   11 +++++++++++
>  tools/perf/util/session.h   |    2 ++
>  tools/perf/util/thread.h    |    5 ++++-
>  5 files changed, 21 insertions(+), 3 deletions(-)

Pulled, thanks Arnaldo!

	Ingo
