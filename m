Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751791Ab1JRGf1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 02:35:27 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:46367 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751064Ab1JRGf0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 02:35:26 -0400
Date: Tue, 18 Oct 2011 08:33:46 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, arnaldo.melo@gmail.com
Subject: Re: [GIT PULL 0/3] perf/core fixes
Message-ID: <20111018063346.GI16304@elte.hu>
References: <1318859659-1171-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1318859659-1171-1-git-send-email-acme@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arnaldo Carvalho de Melo <acme@infradead.org> wrote:

> Hi Ingo,
> 
>         Please consider pulling from:
> 
> git://github.com/acmel/linux.git perf/core
> 
> Regards,
> 
> - Arnaldo
> 
> Arnaldo Carvalho de Melo (2):
>   perf top: Honour --hide_{user,kernel}_symbols and the 'U' hotkey
>   perf top: Fix the 'E' hotkey, select among multiple events
> 
> Mike Galbraith (1):
>   perf hists browser: Add missing stdarg.h include
> 
>  tools/perf/builtin-top.c      |    9 +++++++--
>  tools/perf/util/hist.c        |   17 +++++++++++------
>  tools/perf/util/hist.h        |    5 +++--
>  tools/perf/util/ui/helpline.h |    1 +
>  4 files changed, 22 insertions(+), 10 deletions(-)

Pulled, thanks Arnaldo!

	Ingo
