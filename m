Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752365Ab0GWHIL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 03:08:11 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41106 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751966Ab0GWHIJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 03:08:09 -0400
Date: Fri, 23 Jul 2010 09:07:51 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, Borislav Petkov <borislav.petkov@amd.com>,
        Conny Seidel <conny.seidel@amd.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Gleb Natapov <gleb@redhat.com>, Mike Galbraith <efault@gmx.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [GIT PULL 0/2] perf/urgent fixes
Message-ID: <20100723070751.GA23461@elte.hu>
References: <1279831017-26967-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1279831017-26967-1-git-send-email-acme@infradead.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0010]
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
>   perf annotate: Fix handling of goto labels that are valid hex numbers
> 
> Conny Seidel (1):
>   perf tools: Fix fallback to cplus_demangle() when bfd_demangle() is
>     not available
> 
>  tools/perf/Makefile    |   40 +++++++++++++++++++++-------------------
>  tools/perf/util/hist.c |    8 ++++++--
>  2 files changed, 27 insertions(+), 21 deletions(-)

Pulled, thanks Arnaldo!

	Ingo
