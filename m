Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753116Ab0H3GxK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 02:53:10 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38815 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751597Ab0H3GxI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 02:53:08 -0400
Date: Mon, 30 Aug 2010 08:52:59 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: Re: [GIT PULL 0/6] perf/core new features and improvements
Message-ID: <20100830065259.GB20247@elte.hu>
References: <1282781246-8782-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1282781246-8782-1-git-send-email-acme@infradead.org>
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
>   perf hists: Fix hist_entry__init_have_children
>   perf hists browser: replace rb_first() != NULL by !RB_EMPTY_ROOT()
>   perf hists browser: Init the has_children fields just once
>   perf hists browser: Introduce "expand/collapse all callchains" action
> 
> Srikar Dronamraju (1):
>   perf symbols: List symbols in a dso in ascending name order
> 
> Tom Zanussi (1):
>   perf tools: Fix linking errors with --as-needed flag
> 
>  tools/perf/Makefile                 |   21 ++++--
>  tools/perf/util/symbol.c            |   14 ++++
>  tools/perf/util/symbol.h            |    1 +
>  tools/perf/util/ui/browsers/hists.c |  139 +++++++++++++++++++++++++++++------
>  4 files changed, 145 insertions(+), 30 deletions(-)

Pulled, thanks a lot Arnaldo!

	Ingo
