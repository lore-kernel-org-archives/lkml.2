Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752003Ab1JKFwM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 01:52:12 -0400
Received: from fallback.mail.elte.hu ([157.181.151.13]:59137 "EHLO
	fallback.mail.elte.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851Ab1JKFwG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 01:52:06 -0400
Date: Tue, 11 Oct 2011 07:50:17 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 00/20] [GIT PULL][v3.2] tracing: queued updates
Message-ID: <20111011055017.GA32616@elte.hu>
References: <20111010133852.829771373@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111010133852.829771373@goodmis.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> 
> Ingo,
> 
> With kernel.org down, I've queued up quite a lot of patches for 3.2.
> As the list is slowly growing, I would like to get these into tip
> so we can focus on the new patches.
> 
> I removed the trace_printk() patches as Peter and I are still discussing
> how they should work. But the rest of the patches are good to go.
> 
> -- Steve
> 
> 
> Please pull the latest tip/perf/core tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> tip/perf/core

Hm, this URI does not seem to work for me - yesterday and today i was 
getting:

 $ git pull git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git tip/perf/core
 fatal: The remote end hung up unexpectedly

I am able to pull Linus's tree successfully:

 $ git pull git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
 From git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux
 * branch            master     -> FETCH_HEAD
 Already up-to-date.

So git.kernel.org connectivity is OK.

Thanks,

	Ingo
