Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757397Ab2INLkP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 07:40:15 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:44538 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539Ab2INLkN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 07:40:13 -0400
Date: Fri, 14 Sep 2012 13:40:07 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 0/6 v2] [GIT PULL][3.7] tracing: cleanups and fixes
Message-ID: <20120914114007.GA13421@gmail.com>
References: <20120914030012.315074731@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120914030012.315074731@goodmis.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> Ingo,
> 
> As I believe the -pg removal from perf was holding up the patch
> set, although Frederic and I are working that out, I rebased my
> patch set to remove that change, for a later time.
> 
> The rest holds fixes to bugs that are in your queue for 3.7.
> 
> Please pull the latest tip/perf/core tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
> tip/perf/core
> 
> Head SHA1: c6aaf4d0bb86e2154ea31a33804cec300611255f
> 
> 
> Josh Triplett (1):
>       trace: Stop compiling in trace_clock unconditionally
> 
> Masami Hiramatsu (3):
>       ftrace/x86: Adjust x86 regs.ip as like as x86-64
>       kprobes/x86: Fix kprobes to collectly handle IP on ftrace
>       kprobes/x86: Fix to support jprobes on ftrace-based kprobe
> 
> Steven Rostedt (1):
>       ftrace/x86-64: Allow to change RIP in handlers
> 
> Yuanhan Liu (1):
>       tracing: Skip printing "OK" if failed to disable event
> 
> ----
>  arch/x86/kernel/entry_32.S  |    3 +--
>  arch/x86/kernel/entry_64.S  |    4 ++++
>  arch/x86/kernel/kprobes.c   |   43 +++++++++++++++++++++++++++++++------------
>  kernel/Makefile             |    2 +-
>  kernel/kprobes.c            |    3 ---
>  kernel/trace/Kconfig        |    5 +++++
>  kernel/trace/Makefile       |    6 +-----
>  kernel/trace/trace_events.c |    4 +++-
>  8 files changed, 46 insertions(+), 24 deletions(-)

Pulled, thanks Steve!

	Ingo
