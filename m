Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754567Ab2CXHUP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2012 03:20:15 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:48532 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929Ab2CXHUN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2012 03:20:13 -0400
Date: Sat, 24 Mar 2012 08:20:09 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Wolfgang Mauerer <wolfgang.mauerer@siemens.com>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH][GIT PULL][v3.4] tracing: Fix ftrace stack trace entries
Message-ID: <20120324072008.GA20145@gmail.com>
References: <1332531275.23924.69.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1332531275.23924.69.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt <rostedt@goodmis.org> wrote:

> 
> Ingo,
> 
> Please pull the latest tip/perf/urgent tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
> tip/perf/urgent
> 
> Head SHA1: 01de982abf8c9e10fc3089e10585cd2cc914bdab
> 
> 
> Wolfgang Mauerer (1):
>       tracing: Fix ftrace stack trace entries
> 
> ----
>  kernel/trace/trace_entries.h |   16 ++++++++++++----
>  kernel/trace/trace_export.c  |    2 +-
>  2 files changed, 13 insertions(+), 5 deletions(-)

Pulled, thanks Steve!

	Ingo
