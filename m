Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758159Ab2DYKfh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 06:35:37 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:54978 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756970Ab2DYKff (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 06:35:35 -0400
Date: Wed, 25 Apr 2012 12:35:29 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH][GIT PULL][v3.4] tracing: Fix stacktrace of latency
 tracers (irqsoff and friends)
Message-ID: <20120425103528.GA22289@gmail.com>
References: <1334869614.28106.72.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1334869614.28106.72.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> 
> Ingo,
> 
> Found another stacktrace bug. This is on top of the last pull request I
> made.
> 
> -- Steve
> 
> 
> Please pull the latest tip/perf/urgent-2 tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
> tip/perf/urgent-2
> 
> Head SHA1: db4c75cbebd7e5910cd3bcb6790272fcc3042857
> 
> 
> Steven Rostedt (1):
>       tracing: Fix stacktrace of latency tracers (irqsoff and friends)
> 
> ----
>  kernel/trace/trace_output.c |    5 +++++
>  1 file changed, 5 insertions(+)

Pulled, thanks Steve!

	Ingo
