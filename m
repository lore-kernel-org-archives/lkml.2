Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757945Ab1I3SKw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 14:10:52 -0400
Received: from fallback.mail.elte.hu ([157.181.151.13]:33886 "EHLO
	fallback.mail.elte.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757859Ab1I3SKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 14:10:50 -0400
Date: Fri, 30 Sep 2011 20:09:14 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Neil Horman <nhorman@tuxdriver.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>, arnaldo.melo@gmail.com
Subject: Re: [GIT PULL 0/1] perf/urgent fix
Message-ID: <20110930180914.GA17853@elte.hu>
References: <1317336827-19810-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317336827-19810-1-git-send-email-acme@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
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
> git://github.com/acmel/linux.git perf/urgent
> 
> 	This is on top of the request I sent to Linus, that was basically
> grafted from v3.1-rc7. Perhaps you may want to first merge Linus and then
> this, up to ya.
> 
> Regards,
> 
> - Arnaldo
> 
> 
> Jiri Olsa (1):
>   perf tools: Fix raw sample reading
> 
>  tools/perf/util/evsel.c |    7 +++++--
>  1 files changed, 5 insertions(+), 2 deletions(-)

Pulled, thanks a lot Arnaldo!

	Ingo
