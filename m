Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757694Ab2EJI5c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 04:57:32 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:36174 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757636Ab2EJI53 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 04:57:29 -0400
Date: Thu, 10 May 2012 10:57:23 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/3] [GIT PULL] tracing: cleanups
Message-ID: <20120510085723.GB8186@gmail.com>
References: <20120509165751.114716410@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120509165751.114716410@goodmis.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> 
> Ingo,
> 
> Please pull the latest tip/perf/core tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
> tip/perf/core
> 
> Head SHA1: 68179686ac67cb08f08b1ef28b860d5ed899f242
> 
> 
> Jiri Olsa (1):
>       tracing: Use seq_*_private interface for some seq files
> 
> Minho Ban (1):
>       tracing: Prevent wasting time evaluating parameters in trace_preempt_on/off
> 
> Steven Rostedt (1):
>       tracing: Remove ftrace_disable/enable_cpu()
> 
> ----
>  include/linux/ftrace.h |    8 ++++--
>  kernel/trace/ftrace.c  |   44 +++++++---------------------
>  kernel/trace/trace.c   |   74 +++++-------------------------------------------
>  3 files changed, 24 insertions(+), 102 deletions(-)

Pulled, thanks Steve!

	Ingo
