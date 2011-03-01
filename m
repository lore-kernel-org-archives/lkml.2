Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755405Ab1CAGWU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 01:22:20 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:57622 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752515Ab1CAGWT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 01:22:19 -0500
Date: Tue, 1 Mar 2011 07:22:03 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, David Ahern <daahern@cisco.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [GIT PULL 0/1] perf/urgent fix
Message-ID: <20110301062203.GB9344@elte.hu>
References: <1298923822-25376-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1298923822-25376-1-git-send-email-acme@infradead.org>
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
> Arnaldo Carvalho de Melo (1):
>   perf symbols: Fix vmlinux path when not using --symfs
> 
>  tools/perf/util/symbol.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)

Pulled, thanks a lot Arnaldo!

	Ingo
