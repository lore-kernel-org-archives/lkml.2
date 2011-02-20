Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752301Ab1BTMk6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Feb 2011 07:40:58 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:42328 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751407Ab1BTMk4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Feb 2011 07:40:56 -0500
Date: Sun, 20 Feb 2011 13:40:51 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, Michael Witten <mfwitten@gmail.com>
Subject: Re: [GIT PULL 0/4] perf/core cleanups
Message-ID: <20110220124051.GA25700@elte.hu>
References: <1298054872-16434-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1298054872-16434-1-git-send-email-acme@infradead.org>
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
> git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux-2.6 perf/core
> 
> 	This just trims the Makefile perf stole from git aeons ago, trowing
> away things that either are unused or plain don't make any sense for us.
> 
> Regards,
> 
> - Arnaldo
> 
> Michael Witten (4):
>   perf tools: Makefile: Remove vestigial git-specific cruft
>   perf tools: Makefile: Remove platform-specific cruft
>   perf tools: Makefile: Remove tool-specific cruft
>   perf tools: Makefile: Remove various and sundry cruft
> 
>  tools/perf/.gitignore      |    1 -
>  tools/perf/Makefile        |  576 ++------------------------------------------
>  tools/perf/util/exec_cmd.c |   19 --
>  tools/perf/util/util.h     |   26 --
>  4 files changed, 18 insertions(+), 604 deletions(-)

Pulled, thanks a lot guys!

	Ingo
