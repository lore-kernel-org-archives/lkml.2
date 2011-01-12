Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754421Ab1ALIgz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 03:36:55 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:37596 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751276Ab1ALIgw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 03:36:52 -0500
Date: Wed, 12 Jan 2011 09:36:16 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, David Ahern <daahern@cisco.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Kirill Smelkov <kirr@mns.spb.ru>, Mike Galbraith <efault@gmx.de>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Thomas Renninger <trenn@suse.de>, Tom Zanussi <tzanussi@gmail.com>
Subject: Re: [GIT PULL 0/3] perf/urgent fixes
Message-ID: <20110112083616.GD9868@elte.hu>
References: <1294775438-14324-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1294775438-14324-1-git-send-email-acme@infradead.org>
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
> Regards,
> 
> - Arnaldo
> 
> Arnaldo Carvalho de Melo (3):
>   perf evsel: Fix order of event list deletion
>   perf top: Fix annotate segv
>   Revert "perf tools: Emit clearer message for sys_perf_event_open ENOENT return"
> 
>  tools/perf/builtin-record.c |    4 +---
>  tools/perf/builtin-stat.c   |    1 +
>  tools/perf/builtin-top.c    |    5 +++--
>  tools/perf/perf.c           |    2 --
>  4 files changed, 5 insertions(+), 7 deletions(-)

Pulled, thanks a lot Arnaldo!

	Ingo
