Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752540Ab0HSKZj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 06:25:39 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:60007 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752411Ab0HSKZg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 06:25:36 -0400
Date: Thu, 19 Aug 2010 12:25:22 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, Bernd Petrovitsch <bernd@sysprog.at>,
        Kusanagi Kouichi <slash@ac.auone-net.jp>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [GIT PULL 0/1] perf/urgent fix
Message-ID: <20100819102522.GB29666@elte.hu>
References: <1282169898-28321-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1282169898-28321-1-git-send-email-acme@infradead.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0005]
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
> 	Or perhaps apply it directly, as git.kernel.org is taking ages to
> sync with master today...
> 
> Regards,
> 
> - Arnaldo
> 
> Kusanagi Kouichi (1):
>   perf tools: Fix build error on read only source.
> 
>  tools/perf/Makefile          |   14 ++++++++++----
>  tools/perf/feature-tests.mak |    2 +-
>  2 files changed, 11 insertions(+), 5 deletions(-)

Pulled, thanks Arnaldo!

	Ingo
