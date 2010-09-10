Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756893Ab0IJFeK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 01:34:10 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43094 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756398Ab0IJFeJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 01:34:09 -0400
Date: Fri, 10 Sep 2010 07:33:59 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, Davidlohr Bueso <dave@gnu.org>,
        Jovi Zhang <bookjovi@gmail.com>
Subject: Re: [GIT PULL 0/1] perf/urgent symbols fix
Message-ID: <20100910053359.GB17127@elte.hu>
References: <1284076614-4154-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1284076614-4154-1-git-send-email-acme@infradead.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0053]
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
> Jovi Zhang (1):
>   perf symbols: Fix multiple initialization of symbol system
> 
>  tools/perf/util/symbol.c |    7 +++++++
>  tools/perf/util/symbol.h |    3 ++-
>  2 files changed, 9 insertions(+), 1 deletions(-)

Pulled, thanks Arnaldo!

	Ingo
