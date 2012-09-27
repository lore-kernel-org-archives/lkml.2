Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755928Ab2I0GHz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 02:07:55 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:45013 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755095Ab2I0GHl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 02:07:41 -0400
Date: Thu, 27 Sep 2012 08:07:36 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 0/2] [GIT PULL][v3.7] tracing: A couple more updates
Message-ID: <20120927060736.GA5996@gmail.com>
References: <20120925191941.504217238@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120925191941.504217238@goodmis.org>
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
> Head SHA1: 8781915ad2716adcd8cd5cc52cee791fc8b00fdf
> 
> 
> Ezequiel Garcia (1):
>       trace: Move trace event enable from fs_initcall to core_initcall
> 
> Mandeep Singh Baines (1):
>       tracing: Add an option for disabling markers
> 
> ----
>  kernel/trace/trace.c          |    6 ++-
>  kernel/trace/trace.h          |    1 +
>  kernel/trace/trace_events.c   |  108 +++++++++++++++++++++++++++--------------
>  kernel/trace/trace_syscalls.c |    2 +-
>  4 files changed, 79 insertions(+), 38 deletions(-)

Pulled, thanks Steve!

	Ingo
