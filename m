Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752532Ab2FTMfM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 08:35:12 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:36836 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751120Ab2FTMfK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 08:35:10 -0400
Date: Wed, 20 Jun 2012 14:35:02 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 0/3] [GIT PULL][v3.6] tracing: simple updates
Message-ID: <20120620123502.GD10561@gmail.com>
References: <20120615010123.722084844@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120615010123.722084844@goodmis.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> Ingo,
> 
> I understand that I'm currently on Thomas's "most loved" list, I figured
> I would send out these simple changes. Nothing that should cause me
> another brown paper bag fix in this.
> 
> Please pull the latest tip/perf/core tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
> tip/perf/core
> 
> Head SHA1: 7374e82771c6d5a9af2080be46f64a5826c7efb1
> 
> 
> Borislav Petkov (1):
>       ftrace: Remove a superfluous check
> 
> Steven Rostedt (2):
>       tracing: Add comments for the other bits of ftrace_event_call.flags
>       tracing: Register the ftrace internal events during early boot
> 
> ----
>  include/linux/ftrace_event.h |    3 +++
>  kernel/trace/ftrace.c        |    8 ++------
>  kernel/trace/trace_output.c  |    2 +-
>  3 files changed, 6 insertions(+), 7 deletions(-)

Pulled, thanks Steve!

	Ingo
