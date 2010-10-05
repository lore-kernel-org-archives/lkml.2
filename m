Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757540Ab0JEGS0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 02:18:26 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:42645 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753967Ab0JEGSZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 02:18:25 -0400
Date: Tue, 5 Oct 2010 08:18:03 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, Bernd Petrovitsch <bernd@sysprog.at>,
        "David S . Miller" <davem@davemloft.net>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Frederik Deweerdt <frederik.deweerdt@xprog.eu>,
        Kusanagi Kouichi <slash@ac.auone-net.jp>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <robert.richter@amd.com>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [GIT PULL 0/3] perf/urgent fixes
Message-ID: <20101005061803.GA12267@elte.hu>
References: <1286218483-7219-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1286218483-7219-1-git-send-email-acme@infradead.org>
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
> Frederik Deweerdt (1):
>   perf ui hist browser: Fix segfault on 'a' for annotate
> 
> Kusanagi Kouichi (1):
>   perf tools: Fix build breakage
> 
> Stephane Eranian (1):
>   perf trace scripting: Fix extern struct definitions
> 
>  tools/perf/Makefile                     |    2 +-
>  tools/perf/util/trace-event-scripting.c |    4 ++--
>  tools/perf/util/ui/browsers/hists.c     |    2 +-
>  3 files changed, 4 insertions(+), 4 deletions(-)

Pulled, thanks a lot Arnaldo!

	Ingo
