Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757454Ab2CSK7I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 06:59:08 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:58427 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752865Ab2CSK7G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 06:59:06 -0400
Date: Mon, 19 Mar 2012 11:59:02 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/6] [GIT PULL] tracing: updates
Message-ID: <20120319105902.GA4154@gmail.com>
References: <20120314162629.118638243@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120314162629.118638243@goodmis.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> Ingo,
> 
> Please pull the latest tip/perf/core tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
> tip/perf/core
> 
> Head SHA1: 37d73998920859784e6504462a2fd5f52cc08051
> 
> 
> Gerlando Falauto (1):
>       tracing: Do not select FRAME_POINTER on PPC
> 
> Jiri Olsa (1):
>       perf: Add ifdef to remove unused enum switch warnings
> 
> Mark Brown (1):
>       tracing: Fix build breakage without CONFIG_PERF_EVENTS
> 
> Rajesh Bhagat (1):
>       ftrace: Fix function_graph for archs that test ftrace_trace_function
> 
> Steven Rostedt (2):
>       tracing/ring-buffer: Only have tracing_on disable tracing buffers
>       tracing: Keep NMI watchdog from triggering when dumping trace
> 
> ----
>  include/linux/ftrace_event.h |    2 +
>  include/linux/ring_buffer.h  |    3 +
>  kernel/trace/Kconfig         |    2 +-
>  kernel/trace/ftrace.c        |    3 +-
>  kernel/trace/ring_buffer.c   |  157 ++++++++++++++++--------------------------
>  kernel/trace/trace.c         |  109 +++++++++++++++++++++++++++++
>  kernel/trace/trace.h         |    3 +-
>  7 files changed, 178 insertions(+), 101 deletions(-)

Pulled, thanks Steve!

	Ingo
