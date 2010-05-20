Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757117Ab0ETUA3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 16:00:29 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56808 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753378Ab0ETUA2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 16:00:28 -0400
Date: Thu, 20 May 2010 22:00:15 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Stephane Eranian <eranian@google.com>, Tom Zanussi <tzanussi@gmail.com>
Subject: Re: [GIT PULL 0/2] perf fixes and improvements
Message-ID: <20100520200015.GA11470@elte.hu>
References: <1274371845-27784-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1274371845-27784-1-git-send-email-acme@infradead.org>
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
> Arnaldo Carvalho de Melo (2):
>   perf TUI: Make 'space' be an alias to 'PgDn'
>   perf annotate: Use build-ids to find the right DSO
> 
>  tools/perf/util/build-id.c  |   22 ++++++++++++++++++++++
>  tools/perf/util/build-id.h  |    2 ++
>  tools/perf/util/callchain.c |    1 +
>  tools/perf/util/callchain.h |    1 -
>  tools/perf/util/hist.c      |   34 ++++++++++++++++++++++++++--------
>  tools/perf/util/newt.c      |    2 ++
>  tools/perf/util/symbol.c    |   12 +++---------
>  7 files changed, 56 insertions(+), 18 deletions(-)

Pulled, thanks Arnaldo!

	Ingo
