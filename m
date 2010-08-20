Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751497Ab0HTIHb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 04:07:31 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55337 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751153Ab0HTIH2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 04:07:28 -0400
Date: Fri, 20 Aug 2010 10:07:14 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [GIT PULL 0/3] perf/core improvements
Message-ID: <20100820080714.GB17551@elte.hu>
References: <1282272469-3675-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1282272469-3675-1-git-send-email-acme@infradead.org>
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
> git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux-2.6 perf/core
> 
> Regards,
> 
> - Arnaldo
> 
> Arnaldo Carvalho de Melo (3):
>   perf ui browser: Abstract some more slang operations
>   perf ui browser: Return the exit key in all browsers
>   perf ui browser: Add routines to compactly specify exit keys
> 
>  tools/perf/builtin-annotate.c          |   17 ++--
>  tools/perf/util/ui/browser.c           |   93 +++++++++++--------
>  tools/perf/util/ui/browser.h           |    9 ++-
>  tools/perf/util/ui/browsers/annotate.c |   38 ++++----
>  tools/perf/util/ui/browsers/hists.c    |  157 ++++++++++++++------------------
>  tools/perf/util/ui/browsers/map.c      |   23 ++---
>  tools/perf/util/ui/util.c              |    4 +-
>  tools/perf/util/util.h                 |   13 ---
>  8 files changed, 161 insertions(+), 193 deletions(-)

Pulled, thanks a lot Arnaldo!

	Ingo
