Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751692Ab1EORyh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 May 2011 13:54:37 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:48488 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750876Ab1EORyg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 May 2011 13:54:36 -0400
Date: Sun, 15 May 2011 19:54:17 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Lin Ming <ming.m.lin@intel.com>, Mike Galbraith <efault@gmx.de>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: Re: [GIT PULL 0/2] perf/urgent fixes
Message-ID: <20110515175417.GA2495@elte.hu>
References: <1305477500-20739-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305477500-20739-1-git-send-email-acme@infradead.org>
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
> Arnaldo Carvalho de Melo (2):
>   perf tools: Honour the cpu list parameter when also monitoring a thread list
>   perf evlist: Fix per thread mmap setup
> 
>  tools/perf/builtin-record.c |    2 +-
>  tools/perf/builtin-test.c   |    2 +-
>  tools/perf/builtin-top.c    |    8 +-
>  tools/perf/util/evlist.c    |  153 ++++++++++++++++++++++++++++++-------------
>  tools/perf/util/evlist.h    |    3 +-
>  tools/perf/util/python.c    |    2 +-
>  6 files changed, 116 insertions(+), 54 deletions(-)

Pulled, thanks a lot Arnaldo!

	Ingo
