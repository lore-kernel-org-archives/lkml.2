Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932374Ab0HKGft (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 02:35:49 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:48112 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751304Ab0HKGfs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 02:35:48 -0400
Date: Wed, 11 Aug 2010 08:35:38 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [GIT PULL 0/4] perf/core improvements
Message-ID: <20100811063538.GA30593@elte.hu>
References: <1281477226-11504-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1281477226-11504-1-git-send-email-acme@infradead.org>
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
> Arnaldo Carvalho de Melo (4):
>   perf ui: Make SPACE work as PGDN in all browsers
>   perf annotate: Cycle thru sorted lines with samples
>   perf ui browser: Add ui_browser__show counterpart: __hide
>   perf ui hist browser: Fixup key bindings
> 
>  tools/perf/util/ui/browser.c           |   19 ++++++-
>  tools/perf/util/ui/browser.h           |    4 +-
>  tools/perf/util/ui/browsers/annotate.c |  101 +++++++++++++++++++++++--------
>  tools/perf/util/ui/browsers/hists.c    |   20 ++++---
>  tools/perf/util/ui/browsers/map.c      |   10 +--
>  tools/perf/util/ui/helpline.c          |    2 +-
>  tools/perf/util/ui/helpline.h          |    1 +
>  7 files changed, 113 insertions(+), 44 deletions(-)

Pulled, thanks a lot Arnaldo!

	Ingo
