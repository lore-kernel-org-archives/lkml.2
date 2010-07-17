Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759852Ab0GQKR7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jul 2010 06:17:59 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:33581 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759782Ab0GQKR6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jul 2010 06:17:58 -0400
Date: Sat, 17 Jul 2010 12:17:48 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Josh Hunt <johunt@akamai.com>
Cc: peterz@infradead.org, linux-kernel@vger.kernel.org, juhlenko@akamai.com,
        Mike Galbraith <efault@gmx.de>
Subject: Re: [PATCH] trivial: Use correct macro to display
 sched_child_runs_first in /proc/sched_debug
Message-ID: <20100717101748.GA14106@elte.hu>
References: <4C40D470.3010100@akamai.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C40D470.3010100@akamai.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 1.0
X-ELTE-SpamLevel: s
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=1.0 required=5.9 tests=BAYES_50 autolearn=no SpamAssassin version=3.2.5
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.4980]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Josh Hunt <johunt@akamai.com> wrote:

> The sched_child_runs_first value in /proc/sched_debug is currently
> displayed using a macro meant to split ns time values. This patch uses
> the correct macro to display it as a plain decimal value.
> 
> Signed-off-by: Josh Hunt <johunt@akamai.com>
> ---
>  kernel/sched_debug.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)

Note, the patch wouldnt apply because it is whitespace damaged - please have a 
look at Documentation/email-clients.txt, or send the patch as an attachment.

Thanks,

	Ingo
