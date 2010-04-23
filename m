Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756799Ab0DWJ0h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 05:26:37 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47207 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751306Ab0DWJ0g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 05:26:36 -0400
Date: Fri, 23 Apr 2010 11:26:03 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [GIT PULL] tracing update v2
Message-ID: <20100423092603.GA20333@elte.hu>
References: <20100421080544.GA13107@elte.hu>
 <1271894959-14131-1-git-send-regression-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1271894959-14131-1-git-send-regression-fweisbec@gmail.com>
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


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> Ingo,
> 
> Please pull the tracing/core branch that can be found at:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
> 	tracing/core
> 
> Thanks,
> 	Frederic
> ---
> 
> Frederic Weisbecker (1):
>       tracing: Dump either the oops's cpu source or all cpus buffers
> 
> 
>  Documentation/kernel-parameters.txt |    6 +++-
>  Documentation/trace/ftrace.txt      |    6 +++-
>  drivers/char/sysrq.c                |    2 +-
>  include/linux/ftrace.h              |    4 ++-
>  include/linux/kernel.h              |   11 ++++++-
>  kernel/trace/trace.c                |   51 ++++++++++++++++++++++++++--------
>  kernel/trace/trace_selftest.c       |    5 ++-
>  7 files changed, 64 insertions(+), 21 deletions(-)

Pulled, thanks Frederic!

	Ingo
