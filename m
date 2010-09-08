Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756543Ab0IHGF7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 02:05:59 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:43669 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751251Ab0IHGF4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 02:05:56 -0400
Date: Wed, 8 Sep 2010 08:05:46 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Koki Sanagi <sanagi.koki@jp.fujitsu.com>,
        "David S . Miller" <davem@davemloft.net>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [GIT PULL] tracing updates
Message-ID: <20100908060546.GA3439@elte.hu>
References: <1283878091-5751-1-git-send-regression-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1283878091-5751-1-git-send-regression-fweisbec@gmail.com>
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


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> Ingo,
> 
> Please pull the perf/core branch that can be found at:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
> 	perf/core
> 
> Thanks,
> 	Frederic
> ---
> 
> Koki Sanagi (3):
>       netdev: Add tracepoints to netdev layer
>       skb: Add tracepoints to freeing skb
>       perf: Add a script to show packets processing
> 
> Lai Jiangshan (1):
>       irq: Add tracepoint to softirq_raise
> 
> Neil Horman (1):
>       napi: Convert trace_napi_poll to TRACE_EVENT
> 
> 
>  include/linux/interrupt.h                         |    8 +-
>  include/trace/events/irq.h                        |   26 +-
>  include/trace/events/napi.h                       |   25 +-
>  include/trace/events/net.h                        |   82 ++++
>  include/trace/events/skb.h                        |   17 +
>  net/core/datagram.c                               |    1 +
>  net/core/dev.c                                    |    8 +
>  net/core/net-traces.c                             |    1 +
>  net/core/skbuff.c                                 |    1 +
>  tools/perf/scripts/python/bin/netdev-times-record |    8 +
>  tools/perf/scripts/python/bin/netdev-times-report |    5 +
>  tools/perf/scripts/python/netdev-times.py         |  464 +++++++++++++++++++++
>  12 files changed, 641 insertions(+), 5 deletions(-)

Pulled, thanks a lot!

	Ingo
